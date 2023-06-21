import 'package:griot_app/accounts/data/models/account_model.dart';
import 'package:griot_app/user/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    super.id,
    required super.ownedAccounts,
    required super.belovedAccounts,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<AccountModel> ownedAccounts = [];
    List<AccountModel> belovedAccounts = [];

    if (json['owned_accounts'] != null) {
      json['owned_accounts'].forEach((v) {
        ownedAccounts.add(AccountModel.fromJson(v));
      });
    }

    if (json['beloved_accounts'] != null) {
      json['beloved_accounts'].forEach((v) {
        belovedAccounts.add(AccountModel.fromJson(v));
      });
    }

    return UserModel(
      id: json['id'] as int?,
      ownedAccounts: ownedAccounts,
      belovedAccounts: belovedAccounts,
    );
  }
}
