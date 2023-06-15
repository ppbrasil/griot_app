import 'dart:convert';

import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tMemoryModel = MemoryModel(title: "My first memory", id: 1, account: 1);

  test(
    'Should be a subclass of Memory entity',
    () async {
      expect(tMemoryModel, isA<Memory>());
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
      expect(result, tMemoryModel);
    });
  });
}
