import 'package:equatable/equatable.dart';

class Memory extends Equatable {
  final String title;

  const Memory({required this.title});

  @override
  List<Object> get props => [title];
}
