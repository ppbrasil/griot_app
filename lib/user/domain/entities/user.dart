import 'package:equatable/equatable.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';

class User extends Equatable {
  final int? id;
  final List<Account>? ownedAccounts;
  final List<Account>? belovedAccounts;

  const User({
    this.id,
    required this.ownedAccounts,
    required this.belovedAccounts,
  });

  @override
  List<Object> get props => [];
}
