import 'dart:convert';

import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
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

  MemoryModel tMemoryModelone = MemoryModel(
    id: 78,
    title: "My First Memory",
    accountId: 1,
    videos: [tVideoOne, tVideoTwo],
  );

  test(
    'Should be a subclass of Memory entity',
    () async {
      expect(tMemoryModelone, isA<Memory>());
    },
  );
  group('fromJson', () {
    test('Should return a valid memory model from a valid JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('memory_details_success.json'));
      // act
      final result = MemoryModel.fromJson(jsonMap);
      // assert
      expect(result, tMemoryModelone);
    });
  });
}
