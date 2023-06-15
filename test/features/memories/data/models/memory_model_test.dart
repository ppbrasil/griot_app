import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:test/test.dart';

void main() {
  const tMemoryModel = MemoryModel(title: 'My birthday');

  test(
    'Should be a subclass of Memory entity',
    () async {
      expect(tMemoryModel, isA<Memory>());
    },
  );
}
