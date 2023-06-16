import 'package:griot_app/memories/domain/entities/memory.dart';

class MemoryModel extends Memory {
  final int? id;
  final int account;

  const MemoryModel({
    this.id,
    required this.account,
    required super.title,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      account: json['account'],
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'title': title,
    };
  }
}
