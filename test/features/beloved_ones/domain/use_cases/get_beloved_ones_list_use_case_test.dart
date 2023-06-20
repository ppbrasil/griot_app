import 'package:dartz/dartz.dart';
import 'package:griot_app/beloved_ones/domain/entities/beloved_one.dart';
import 'package:griot_app/beloved_ones/domain/repositories/beloved_one_repository.dart';
import 'package:griot_app/beloved_ones/domain/use_cases/get_beloved_ones_list_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_beloved_ones_list_use_case_test.mocks.dart';

@GenerateMocks([BelovedOnesRepository])
void main() {
  late GetBelovedOnesListUseCase usecase;
  late MockBelovedOnesRepository mockBelovedOnesRepository;

  setUp(() {
    mockBelovedOnesRepository = MockBelovedOnesRepository();
    usecase = GetBelovedOnesListUseCase(mockBelovedOnesRepository);
  });

  const BelovedOne tBelovedOne1 = BelovedOne();
  const BelovedOne tBelovedOne2 = BelovedOne();
  const List<BelovedOne> tBelovedOnesList = [tBelovedOne1, tBelovedOne2];

  test('Should get a memory\'s details from the repository', () async {
    // arrange
    when(mockBelovedOnesRepository.performGeBelovedOnesList())
        .thenAnswer((_) async => const Right(tBelovedOnesList));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, equals(const Right(tBelovedOnesList)));
    verify(mockBelovedOnesRepository.performGeBelovedOnesList());
    verifyNoMoreInteractions(mockBelovedOnesRepository);
  });
}
