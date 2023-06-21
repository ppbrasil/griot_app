import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:griot_app/accounts/data/data_sources/beloved_ones_remote_data_source.dart';
import 'package:griot_app/accounts/data/models/beloved_one_model.dart';
import 'package:griot_app/profile/data/data_sources/profiles_remote_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:griot_app/core/data/token_provider.dart';
import 'package:griot_app/core/error/exceptions.dart';
import '../../../../../fixtures/fixture_reader.dart';
import 'beloved_ones_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client, TokenProvider])
void main() {
  late BelovedOnesRemoteDataSourceImpl datasource;
  late MockClient mockHttpClient;
  late MockTokenProvider mockTokenProvider;

  const tBelovedOneModel1 = BelovedOneModel(
    id: 1,
    profilePicture:
        "https://griot-memories-data.s3.amazonaws.com/profile_pictures/my_profile.jpeg",
    name: "Pedro",
    middleName: null,
    lastName: "Brasil",
    birthDate: null,
    gender: "male",
    language: "pt",
    timeZone: "America/Sao_Paulo",
  );
  const tBelovedOneModel2 = BelovedOneModel(
    id: 4,
    profilePicture: null,
    name: "Bianca",
    middleName: null,
    lastName: "Caffaro",
    birthDate: null,
    gender: "female",
    language: "pt",
    timeZone: "America/Sao_Paulo",
  );
  const tBelovedOneModel3 = BelovedOneModel(
    id: 2,
    profilePicture:
        "https://griot-memories-data.s3.amazonaws.com/profile_pictures/WhatsApp_Image_2023-06-03_at_10.05.53_AM.jpeg",
    name: "Ana Clara",
    middleName: null,
    lastName: "Estephan",
    birthDate: null,
    gender: "female",
    language: "pt",
    timeZone: "America/Sao_Paulo",
  );

  final List<BelovedOneModel> tBelovedOnesList = [
    tBelovedOneModel1,
    tBelovedOneModel2,
    tBelovedOneModel3
  ];

  setUp(() {
    mockHttpClient = MockClient();
    mockTokenProvider = MockTokenProvider();
    datasource = BelovedOnesRemoteDataSourceImpl(
        tokenProvider: mockTokenProvider, client: mockHttpClient);
  });

  group('getBelovedOnes', () {
    const String tEndpoint = "app.griot.me/api/account/list-beloved-ones/1/";
    const tToken = "yjtcuyrskuhbkjhftrwsujytfciukyhgiutfvk";
    final Map<String, String> tHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $tToken',
    };

    test(
      'should perform a GET request',
      () async {
        // arrange
        when(mockTokenProvider.getToken())
            .thenAnswer((_) async => 'Token $tToken');
        when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
            .thenAnswer((_) async =>
                http.Response(fixture('beloved_ones_list_success.json'), 200));

        // act
        await datasource.getBelovedOnesListFromAPI();

        // assert
        verify(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders));
      },
    );
  });
}
