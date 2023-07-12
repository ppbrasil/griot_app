import 'package:bloc_test/bloc_test.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:griot_app/core/services/griot_video_services.dart';
import 'package:griot_app/memories/presentation/bloc/griot_video_player_bloc_bloc.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:test/test.dart';

import 'memories_griot_video_player_bloc_bloc_test.mocks.dart';

@GenerateMocks([
  GriotVideoService,
  ChewieController,
])
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  late GriotVideoPlayerBlocBloc bloc;
  late MockGriotVideoService mockGriotVideoService;
  late MockChewieController mockChewieController;

  setUp(() {
    mockGriotVideoService = MockGriotVideoService();
    mockChewieController = MockChewieController();
    const String tUrl = 'my/url';

    bloc = GriotVideoPlayerBlocBloc(videoUrl: tUrl);
  });

  test('Initial state should be Empty', () {
    expect(bloc.state, equals(GriotVideoPlayerBlocLoadingState()));
  });

  group('GriotVideoPlayerBlocInitializedEvent', () {
    blocTest<GriotVideoPlayerBlocBloc, GriotVideoPlayerBlocState>(
      'should emit GriotVideoPlayerBlocLoadedState state when loading of dependencies finishes successfully',
      build: () {
        when(mockGriotVideoService.initialize())
            .thenAnswer((_) async => Future.value());
        when(mockGriotVideoService.chewieController)
            .thenAnswer((_) => mockChewieController);

        return bloc;
      },
      act: (bloc) => bloc.add(const GriotVideoPlayerBlocInitializedEvent()),
      expect: () => [
        GriotVideoPlayerBlocLoadingState(),
        GriotVideoPlayerBlocLoadedState(
            chewieController: mockGriotVideoService.chewieController),
      ],
    );
    blocTest<GriotVideoPlayerBlocBloc, GriotVideoPlayerBlocState>(
      'should emit GriotVideoPlayerFailureState state when loading of dependencies fails',
      build: () {
        when(mockGriotVideoService.initialize()).thenThrow(
            Exception('Failed to initialize video player controller'));

        return bloc;
      },
      act: (bloc) => bloc.add(const GriotVideoPlayerBlocInitializedEvent()),
      expect: () => [
        GriotVideoPlayerBlocLoadingState(),
        GriotVideoPlayerFailureState(),
      ],
    );
  });

  group('GriotVideoPlayerBlocOrientationChangedEvent', () {
    blocTest<GriotVideoPlayerBlocBloc, GriotVideoPlayerBlocState>(
      'should exit full screen when orientation changes to portrait and player is in full screen',
      build: () {
        when(mockChewieController.enterFullScreen()).thenAnswer((_) {});
        when(mockChewieController.exitFullScreen()).thenAnswer((_) {});
        return bloc;
      },
      act: (bloc) {
        // Configure mockChewieController to start in full screen
        when(mockChewieController.isFullScreen).thenReturn(true);

        // Simulate orientation change to portrait
        bloc.add(const GriotVideoPlayerBlocOrientationChangedEvent(
            orientation: NativeDeviceOrientation.portraitUp,
            isFullScreen: true));
      },
      verify: (_) {
        // Verify that the player exited full screen
        verify(mockChewieController.exitFullScreen()).called(1);
      },
    );

    blocTest<GriotVideoPlayerBlocBloc, GriotVideoPlayerBlocState>(
      'should enter full screen when orientation changes to landscape and player is not in full screen',
      build: () {
        when(mockChewieController.enterFullScreen()).thenAnswer((_) {});
        when(mockChewieController.exitFullScreen()).thenAnswer((_) {});
        return bloc;
      },
      act: (bloc) {
        // Configure mockChewieController to start not in full screen
        when(mockChewieController.isFullScreen).thenReturn(false);

        // Simulate orientation change to landscape
        bloc.add(const GriotVideoPlayerBlocOrientationChangedEvent(
            orientation: NativeDeviceOrientation.landscapeLeft,
            isFullScreen: false));
      },
      verify: (_) {
        // Verify that the player entered full screen
        verify(mockChewieController.enterFullScreen()).called(1);
      },
    );
  });
}
