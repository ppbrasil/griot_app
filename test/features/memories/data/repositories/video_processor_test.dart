import 'package:griot_app/core/error/exceptions.dart';

import 'package:griot_app/memories/data/data_source/memories_remote_data_source.dart';
import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:griot_app/memories/data/repositories/video_processor.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/entities/video.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

import 'video_processor_test.mocks.dart';

@GenerateMocks([MemoriesRemoteDataSource])
void main() {
  late VideoProcessingService videoServices;
  late MockMemoriesRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockMemoriesRemoteDataSource();
    videoServices =
        VideoProcessingService(remoteDataSource: mockRemoteDataSource);
  });
  group('deleteVideos', () {
    VideoModel tVideo1 = const VideoModel(id: 1, file: 'MyPath1');
    VideoModel tVideo2 = const VideoModel(id: 2, file: 'MyPath2');
    List<VideoModel> tVideoList = [tVideo1, tVideo2];

    test('Should return void when successfully delete a Video list ', () async {
      // arrange
      when(mockRemoteDataSource.deleteVideoFromAPI(
              videoId: anyNamed('videoId')))
          .thenAnswer((_) async => 0);
      // act
      await videoServices.deleteVideos(videos: tVideoList);
      // assert
      verify(mockRemoteDataSource.deleteVideoFromAPI(
              videoId: anyNamed('videoId')))
          .called(2);
    });
    test('Should throw an error if it\'s not able to delete a video ',
        () async {
      // arrange
      when(mockRemoteDataSource.deleteVideoFromAPI(
              videoId: anyNamed('videoId')))
          .thenThrow(ServerException());
      // assert
      expectLater(videoServices.deleteVideos(videos: tVideoList),
          throwsA(isA<ServerException>()));
    });
  });

  group('addVideos', () {
    int tMemoryId = 1;
    VideoModel tVideo1 = const VideoModel(id: 1, file: 'MyPath1');
    VideoModel tVideo2 = const VideoModel(id: 2, file: 'MyPath2');
    List<Video> tVideoList = [tVideo1, tVideo2];
    List<VideoModel> tVideoModelList = [tVideo1, tVideo2];

    test('Should return void when successfully post a Video list ', () async {
      // arrange
      when(mockRemoteDataSource.postVideoToAPI(
              memoryId: tMemoryId, video: tVideo1))
          .thenAnswer((_) async => tVideo1);
      when(mockRemoteDataSource.postVideoToAPI(
              memoryId: tMemoryId, video: tVideo2))
          .thenAnswer((_) async => tVideo2);
      // act
      await videoServices.addVideos(memoryId: tMemoryId, videos: tVideoList);
      // assert
      verify(mockRemoteDataSource.postVideoToAPI(
              memoryId: 1, video: anyNamed('video')))
          .called(2);
    });
    test('Should throw an error if it\'s not able to delete a video ',
        () async {
      // arrange
      when(mockRemoteDataSource.deleteVideoFromAPI(
              videoId: anyNamed('videoId')))
          .thenThrow(ServerException());
      // assert
      expectLater(videoServices.deleteVideos(videos: tVideoModelList),
          throwsA(isA<ServerException>()));
    });
  });
  group('processVideoChanges', () {
    Video tPreviousVideo = const Video(
        id: 1,
        file: 'MyPath2',
        memoryId: 1,
        name: null,
        thumbnail: null,
        thumbnailData: null);
    VideoModel tNewVideoModel = const VideoModel(
        id: null, file: 'MyPath1', memoryId: 1, name: null, thumbnail: null);

    Memory tMemory = Memory(
        id: 1, videos: [tNewVideoModel], accountId: 1, title: 'First Memory');
    Memory tRetrievedMemory = Memory(
        id: 1, videos: [tPreviousVideo], accountId: 1, title: 'Second Memory');

    test('Should process video changes correctly', () async {
      // arrange
      when(mockRemoteDataSource.deleteVideoFromAPI(videoId: tPreviousVideo.id))
          .thenAnswer((_) async => 0);
      when(mockRemoteDataSource.postVideoToAPI(
              memoryId: tMemory.id, video: tNewVideoModel))
          .thenAnswer((_) async => tNewVideoModel);
      // act
      await videoServices.processVideoChanges(tMemory, tRetrievedMemory);

      // assert
      verify(mockRemoteDataSource.deleteVideoFromAPI(
              videoId: anyNamed('videoId')))
          .called(1);
      verify(mockRemoteDataSource.postVideoToAPI(
              memoryId: anyNamed('memoryId'), video: anyNamed('video')))
          .called(1);
    });
  });
}
