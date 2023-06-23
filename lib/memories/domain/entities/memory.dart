import 'package:equatable/equatable.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/memories/domain/entities/video.dart';

class Memory extends Equatable {
  final int? id;
  final int accountId;
  final String? title;
  final List<Video>? videos;

  const Memory({
    required this.id,
    required this.title,
    required this.accountId,
    required this.videos,
  });

  @override
  List<Object> get props => [];
}
