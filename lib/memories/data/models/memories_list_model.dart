import 'package:griot_app/memories/data/models/memory_model.dart';

class MemoryListModel {
  final List<MemoryModel> memories;

  const MemoryListModel({required this.memories});

  static MemoryListModel fromList(List<dynamic> list) {
    List<MemoryModel> memoriesList =
        list.map((i) => MemoryModel.fromJson(i)).toList();

    return MemoryListModel(
      memories: memoriesList,
    );
  }
}
