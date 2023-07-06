import 'package:flutter_test/flutter_test.dart';
import 'package:griot_app/core/data/token_provider.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'token_provider_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences mockSharedPreferences;
  late TokenProviderImpl tokenProvider;

  const tTokenString = 'abcdef123456';

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();

    tokenProvider = TokenProviderImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getToken', () {
    test('should return a valid token when one is in SharedPreferences',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(tTokenString);
      // act
      final result = await tokenProvider.getToken();
      // assert
      expect(result, 'Token $tTokenString');
    });

    test(
        'should throw NoTokenException when there is no token in SharedPreferences',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      final call = tokenProvider.getToken;
      // assert
      expect(() => call(), throwsA(isInstanceOf<NoTokenException>()));
    });
  });

  group('destroyToken', () {
    test('should remove token from SharedPreferences when there is one',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(tTokenString);
      when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);
      // act
      final call = tokenProvider.destroyToken;
      // assert
      expect(await call(), true);
      verify(mockSharedPreferences.remove('token'));
    });

    test(
        'should not throw an exception when there is no token in SharedPreferences',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      final call = tokenProvider.destroyToken;
      // assert
      expect(() => call(), throwsA(isA<NoTokenException>()));
      verifyNever(mockSharedPreferences.remove(any));
    });
  });
}
