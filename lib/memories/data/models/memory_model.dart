import 'package:griot_app/memories/domain/entities/memory.dart';

class MemoryModel extends Memory {
  final int id;
  final int account;

  const MemoryModel({
    required this.account,
    required this.id,
    required super.title,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      account: json['account'],
      id: json['id'],
      title: json['title'],
    );
  }
}
