import 'dart:convert';

import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:griot_app/memories/data/models/memories_list_model.dart';
import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tVideoOneId = 37;
  const tVideoOneFile =
      "https://griot-memories-data.s3.amazonaws.com/videos/78-14027.mp4";
  const tVideoOneMemorId = 78;

  VideoModel tVideoOne = const VideoModel(
    id: tVideoOneId,
    file: tVideoOneFile,
    memoryId: tVideoOneMemorId,
  );

  const tVideoTwoId = 38;
  const tVideoTwoFile =
      "https://griot-memories-data.s3.amazonaws.com/videos/78-14028.mp4";
  const tVideoTwoMemorId = 78;

  VideoModel tVideoTwo = const VideoModel(
    id: tVideoTwoId,
    file: tVideoTwoFile,
    memoryId: tVideoTwoMemorId,
  );
  const tMemoryId = 78;
  const tAccountid = 1;
  const tTitle = "My First Memory";

  MemoryModel tMemoryModel1 = MemoryModel(
    id: tMemoryId,
    accountId: tAccountid,
    title: tTitle,
    videos: [tVideoOne, tVideoTwo],
  );

  MemoryModel tMemoryModel2 = MemoryModel(
    title: "My second memory",
    id: 2,
    videos: [],
    accountId: 1,
  );
  MemoryModel tMemoryModel3 = MemoryModel(
    title: "My third memory",
    id: 3,
    videos: [],
    accountId: 1,
  );

  group('fromList', () {
    test('Should return a valid MemoryListModel from a valid JSON list',
        () async {
      // arrange
      final List<dynamic> jsonList =
          json.decode(fixture('memories_list_success.json'));
      // act
      final result = MemoryListModel.fromList(jsonList);
      // assert
      expect(result.memories[0], tMemoryModel1);
      expect(result.memories[1], tMemoryModel2);
      expect(result.memories[2], tMemoryModel3);
    });
  });
}
