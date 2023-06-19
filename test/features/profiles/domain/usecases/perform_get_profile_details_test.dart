import 'package:dartz/dartz.dart';
import 'package:griot_app/profile/domain/entities/profile.dart';
import 'package:griot_app/profile/domain/repositories/profile_respository.dart';
import 'package:griot_app/profile/domain/use_cases/perform_get_profile_details.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'perform_get_profile_details_test.mocks.dart';

@GenerateMocks([ProfilesRepository])
void main() {
  late PerformGetProfileDetails usecase;
  late MockProfilesRepository mockProfilesRepository;

  setUp(() {
    mockProfilesRepository = MockProfilesRepository();
    usecase = PerformGetProfileDetails(mockProfilesRepository);
  });

  const tProfile = Profile();

  test('Should get a profile\'s details from the repository', () async {
    // arrange
    when(mockProfilesRepository.performGetProfileDetails())
        .thenAnswer((_) async => const Right(tProfile));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, equals(const Right(tProfile)));
    verify(mockProfilesRepository.performGetProfileDetails());
    verifyNoMoreInteractions(mockProfilesRepository);
  });
}
