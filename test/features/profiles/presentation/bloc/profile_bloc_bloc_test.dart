import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/profile/domain/entities/profile.dart';
import 'package:griot_app/profile/domain/use_cases/perform_get_profile_details.dart'
    as getProfileUseCase;
import 'package:griot_app/profile/domain/use_cases/perform_update_profile_dateils.dart'
    as updateProfileUseCase;
import 'package:griot_app/profile/presentation/bloc/profile_bloc_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'profile_bloc_bloc_test.mocks.dart';

@GenerateMocks([
  getProfileUseCase.PerformGetProfileDetails,
  updateProfileUseCase.PerformUpdateProfileDetails,
])
void main() {
  late ProfileBlocBloc bloc;
  late MockPerformGetProfileDetails mockGetProfileDetaislUseCase;
  late MockPerformUpdateProfileDetails mockUpdateProfileDetailsUseCase;

  setUp(() {
    mockGetProfileDetaislUseCase = MockPerformGetProfileDetails();
    mockUpdateProfileDetailsUseCase = MockPerformUpdateProfileDetails();
    bloc = ProfileBlocBloc(
      getDetails: mockGetProfileDetaislUseCase,
      updateDetails: mockUpdateProfileDetailsUseCase,
    );
  });

  test('Initial state should be Empty', () {
    expect(bloc.state, equals(ProfileInitial()));
  });

  group('GetProfileInfoEvent', () {
    Profile tProfile = const Profile();

    blocTest<ProfileBlocBloc, ProfileBlocState>(
      'should emit ProfileGetDetailsSuccess state when Profile details retrieval is successful',
      build: () {
        when(mockGetProfileDetaislUseCase.call(getProfileUseCase.NoParams()))
            .thenAnswer(
          (_) async => Right(tProfile),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const GetProfileInfoEvent()),
      expect: () => [
        ProfileGetDetailsLoading(),
        ProfileGetDetailsSuccess(profile: tProfile),
      ],
    );

    blocTest<ProfileBlocBloc, ProfileBlocState>(
      'should emit ProfileGetDetailsFailure state when Profile details retrieval is unsuccessful',
      build: () {
        when(mockGetProfileDetaislUseCase.call(getProfileUseCase.NoParams()))
            .thenAnswer(
          (_) async => const Left(
              ServerFailure(message: 'Failed to fetch profile details')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const GetProfileInfoEvent()),
      expect: () => [
        ProfileGetDetailsLoading(),
        const ProfileGetDetailsFailure(
            message: 'Failed to fetch profile details'),
      ],
    );
  });
  group('UpdateProfileInfoEvent', () {
    Profile tProfile = const Profile();

    blocTest<ProfileBlocBloc, ProfileBlocState>(
      'should emit ProfileUpdateSuccess state when Profile update is successful',
      build: () {
        when(mockUpdateProfileDetailsUseCase
                .call(const updateProfileUseCase.Params()))
            .thenAnswer(
          (_) async => Right(tProfile),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateProfileInfoEvent(profile: tProfile)),
      expect: () => [
        ProfileUpdateLoading(),
        ProfileUpdateSuccess(profile: tProfile),
      ],
    );

    blocTest<ProfileBlocBloc, ProfileBlocState>(
      'should emit ProfileUpdateSuccess state when Profile update is unsuccessful',
      build: () {
        when(mockUpdateProfileDetailsUseCase
                .call(const updateProfileUseCase.Params()))
            .thenAnswer(
          (_) async => const Left(
              ServerFailure(message: 'Failed to update profile details')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateProfileInfoEvent(profile: tProfile)),
      expect: () => [
        ProfileUpdateLoading(),
        const ProfileUpdateFailure(message: 'Failed to update profile details'),
      ],
    );
  });
}
