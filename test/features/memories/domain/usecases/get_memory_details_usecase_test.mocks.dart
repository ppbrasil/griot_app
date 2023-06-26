// Mocks generated by Mockito 5.4.1 from annotations
// in griot_app/test/features/memories/domain/usecases/get_memory_details_usecase_test.dart.
// Do not manually edit this file.

// @dart=2.19

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:griot_app/core/error/failures.dart' as _i5;
import 'package:griot_app/memories/domain/entities/memory.dart' as _i6;
import 'package:griot_app/memories/domain/repositories/memories_repository.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MemoriesRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockMemoriesRepository extends _i1.Mock
    implements _i3.MemoriesRepository {
  MockMemoriesRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>>
      performCreateDraftMemoryLocally({required int? accountId}) =>
          (super.noSuchMethod(
            Invocation.method(
              #performCreateDraftMemoryLocally,
              [],
              {#accountId: accountId},
            ),
            returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>>.value(
                _FakeEither_0<_i5.Failure, _i6.Memory>(
              this,
              Invocation.method(
                #performCreateDraftMemoryLocally,
                [],
                {#accountId: accountId},
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>> performcreateMemory(
          {required _i6.Memory? memory}) =>
      (super.noSuchMethod(
        Invocation.method(
          #performcreateMemory,
          [],
          {#memory: memory},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>>.value(
            _FakeEither_0<_i5.Failure, _i6.Memory>(
          this,
          Invocation.method(
            #performcreateMemory,
            [],
            {#memory: memory},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>>
      performAddVideoFromLibraryToMemory({required _i6.Memory? memory}) =>
          (super.noSuchMethod(
            Invocation.method(
              #performAddVideoFromLibraryToMemory,
              [],
              {#memory: memory},
            ),
            returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>>.value(
                _FakeEither_0<_i5.Failure, _i6.Memory>(
              this,
              Invocation.method(
                #performAddVideoFromLibraryToMemory,
                [],
                {#memory: memory},
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Memory>>> getMemoriesList() =>
      (super.noSuchMethod(
        Invocation.method(
          #getMemoriesList,
          [],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.Memory>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.Memory>>(
          this,
          Invocation.method(
            #getMemoriesList,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.Memory>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>> performGetMemoryDetails(
          {required int? memoryId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #performGetMemoryDetails,
          [],
          {#memoryId: memoryId},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>>.value(
            _FakeEither_0<_i5.Failure, _i6.Memory>(
          this,
          Invocation.method(
            #performGetMemoryDetails,
            [],
            {#memoryId: memoryId},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>>
      performAddVideoListFromLibraryToDraftMemory(
              {required _i6.Memory? memory}) =>
          (super.noSuchMethod(
            Invocation.method(
              #performAddVideoListFromLibraryToDraftMemory,
              [],
              {#memory: memory},
            ),
            returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>>.value(
                _FakeEither_0<_i5.Failure, _i6.Memory>(
              this,
              Invocation.method(
                #performAddVideoListFromLibraryToDraftMemory,
                [],
                {#memory: memory},
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>> performCommitChangesToMemory(
          {required _i6.Memory? memory}) =>
      (super.noSuchMethod(
        Invocation.method(
          #performCommitChangesToMemory,
          [],
          {#memory: memory},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>>.value(
            _FakeEither_0<_i5.Failure, _i6.Memory>(
          this,
          Invocation.method(
            #performCommitChangesToMemory,
            [],
            {#memory: memory},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Memory>>);
}
