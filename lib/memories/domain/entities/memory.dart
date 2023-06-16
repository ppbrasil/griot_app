import 'package:equatable/equatable.dart';

class Memory extends Equatable {
  final int? id;
  final String title;

  const Memory({this.id, required this.title});

  @override
  List<Object> get props => [title];
}
