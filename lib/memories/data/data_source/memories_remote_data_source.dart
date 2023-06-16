import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';

abstract class MemoriesRemoteDataSource {
  Future<List<Memory>> getMemoriesListFromAPI();
  Future<Memory> getMemoryDetailsFromAPI({int memoryId});
  Future<Memory> postMemoryToAPI({String title});
}
