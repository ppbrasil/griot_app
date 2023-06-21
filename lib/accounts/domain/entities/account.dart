import 'package:equatable/equatable.dart';
import 'package:griot_app/accounts/domain/entities/beloved_one.dart';

class Account extends Equatable {
  final int? id;
  final String name;
  final List<BelovedOne>? belovedOnesList;

  const Account({
    this.id,
    required this.name,
    this.belovedOnesList,
  });

  @override
  List<Object> get props => [name];
}
