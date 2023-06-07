import 'package:griot_app/authentication/domain/entities/token.dart';

class TokenModel extends Token {
  const TokenModel({required String tokenString}) : super(tokenString: tokenString);

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('token') || json['token'] == null) {
      throw const FormatException('Missing tokenString in the provided JSON');
    }

    return TokenModel(
      tokenString: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tokenString': tokenString,
    };
  }
}