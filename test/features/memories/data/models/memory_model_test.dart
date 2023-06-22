import 'dart:convert';

import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tMemoryModelone = MemoryModel(
    id: 1,
    title: "My first memory",
    account: 1,
    videos: [],
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

  group('toJson', () {
    test(
        'Should return a JSON map containing the proper data for a memory WITHOUT id',
        () async {
      // act
      final result = tMemoryModelone.toJson();
      // assert
      final expectedMap = {
        "id": 1,
        "account": 1,
        "title": "My first memory",
        "videos": [],
      };
      expect(result, expectedMap);
    });
  });
}
