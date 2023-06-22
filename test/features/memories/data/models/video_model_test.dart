import 'dart:convert';

import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:griot_app/memories/domain/entities/video.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tId = 1;
  const tFile =
      "https://griot-memories-data.s3.amazonaws.com/videos/2013-09-05_18.02.34.mp4";
  const tName = "My First Video";

  VideoModel tVideoModel = const VideoModel(
    id: tId,
    file: tFile,
    name: tName,
    memoryId: null,
  );

  test(
    'Should be a subclass of Memory entity',
    () async {
      expect(tVideoModel, isA<Video>());
    },
  );

  group('fromJson', () {
    test('Should return a valid VideoModel from a valid JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('video_details_sucess.json'));
      // act
      final result = VideoModel.fromJson(jsonMap);
      // assert
      expect(result, tVideoModel);
    });
  });

  group('toJson', () {
    test(
        'Should return a JSON map containing the proper data for a memory WITHOUT id',
        () async {
      // act
      final result = tVideoModel.toJson();
      // assert
      final expectedMap = {
        "id": tId,
        "url": tFile,
        "name": tName,
        "memory": null,
      };
      expect(result, expectedMap);
    });
  });
}
