import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final int? id;
  final String file;
  final String? thumbnail;
  final String? name;
  final int? memoryId;

  const Video({
    required this.id,
    required this.file,
    required this.thumbnail,
    required this.name,
    required this.memoryId,
  });

  @override
  List<Object?> get props => [id, getBaseUrl(file), name, memoryId];
}

String getBaseUrl(String url) {
  var uri = Uri.parse(url);
  var baseUrl = '${uri.scheme}://${uri.host}${uri.path}';
  return baseUrl;
}
