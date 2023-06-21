import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/accounts/data/models/beloved_one_model.dart';

class AccountModel extends Account {
  final List<BelovedOneModel>? belovedOnesProfiles;

  const AccountModel({
    required super.id,
    required super.name,
    this.belovedOnesProfiles,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      belovedOnesProfiles: (json['beloved_ones_profiles'] as List<dynamic>)
          .map((belovedOne) =>
              BelovedOneModel.fromJson(belovedOne as Map<String, dynamic>))
          .toList(),
    );
  }
}
