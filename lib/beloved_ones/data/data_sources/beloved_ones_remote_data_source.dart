import 'package:griot_app/beloved_ones/domain/entities/beloved_one.dart';
import 'package:griot_app/core/data/token_provider.dart';
import 'package:http/http.dart' as http;

abstract class BelovedOnesRemoteDataSource {
  Future<List<BelovedOne>> getBelovedOnesListFromAPI();
}

class ProfilesRemoteDataSourceImpl implements BelovedOnesRemoteDataSource {
  final http.Client client;
  final TokenProvider tokenProvider;

  ProfilesRemoteDataSourceImpl(
      {required this.client, required this.tokenProvider});

  @override
  Future<List<BelovedOne>> getBelovedOnesListFromAPI() {
    // TODO: implement getBelovedOnesListFromAPI
    throw UnimplementedError();
  }
}
