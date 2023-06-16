import 'package:griot_app/memories/domain/entities/memory.dart';

class MemoryModel extends Memory {
  final int account;

  const MemoryModel({
    required super.id,
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
      if (id != null) 'id': id,
      'account': account,
      'title': title,
    };
  }
}
