import 'dart:convert';

import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:griot_app/memories/data/models/memories_list_model.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tMemoryModel1 = MemoryModel(
    title: "My first memory",
    id: 1,
    videos: [],
    accountId: 1,
  );
  const tMemoryModel2 = MemoryModel(
    title: "My second memory",
    id: 2,
    videos: [],
    accountId: 1,
  );
  const tMemoryModel3 = MemoryModel(
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
