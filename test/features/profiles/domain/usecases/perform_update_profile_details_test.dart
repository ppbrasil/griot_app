import 'package:dartz/dartz.dart';
import 'package:griot_app/profile/domain/entities/profile.dart';
import 'package:griot_app/profile/domain/repositories/profile_respository.dart';
import 'package:griot_app/profile/domain/use_cases/perform_update_profile_dateils.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'perform_update_profile_details_test.mocks.dart';

@GenerateMocks([ProfilesRepository])
void main() {
  late PerformUpdateProfileDetails usecase;
  late MockProfilesRepository mockProfilesRepository;

  setUp(() {
    mockProfilesRepository = MockProfilesRepository();
    usecase = PerformUpdateProfileDetails(mockProfilesRepository);
  });

  const tProfile = Profile();

  const tUpdateProfileParams = Params(
    name: 'test',
    middleName: 'user',
  );

  test('Should update a profile\'s details via the repository', () async {
    // arrange
    when(mockProfilesRepository.performUpdateProfileDetails(
      profilePicture: anyNamed('profilePicture'),
      name: anyNamed('name'),
      middleName: anyNamed('middleName'),
      lastName: anyNamed('lastName'),
      birthDate: anyNamed('birthDate'),
      gender: anyNamed('gender'),
      language: anyNamed('language'),
      timeZone: anyNamed('timeZone'),
    )).thenAnswer((_) async => const Right(tProfile));

    // act
    final result = await usecase(tUpdateProfileParams);

    // assert
    expect(result, equals(const Right(tProfile)));
    verify(mockProfilesRepository.performUpdateProfileDetails(
      profilePicture: tUpdateProfileParams.profilePicture,
      name: tUpdateProfileParams.name,
      middleName: tUpdateProfileParams.middleName,
      lastName: tUpdateProfileParams.lastName,
      birthDate: tUpdateProfileParams.birthDate,
      gender: tUpdateProfileParams.gender,
      language: tUpdateProfileParams.language,
      timeZone: tUpdateProfileParams.timeZone,
    ));
    verifyNoMoreInteractions(mockProfilesRepository);
  });
}
