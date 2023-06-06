import 'package:equatable/equatable.dart';

class Token extends Equatable{
  final String tokenString;
  
  const Token({required this.tokenString});
  
  @override
  List<Object> get props => [tokenString];
}