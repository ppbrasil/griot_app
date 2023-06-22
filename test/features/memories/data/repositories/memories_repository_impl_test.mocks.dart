// Mocks generated by Mockito 5.4.1 from annotations
// in griot_app/test/features/memories/data/repositories/memories_repository_impl_test.dart.
// Do not manually edit this file.

// @dart=2.19

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:griot_app/core/network/network_info.dart' as _i8;
import 'package:griot_app/memories/data/data_source/memories_local_data_source.dart'
    as _i6;
import 'package:griot_app/memories/data/data_source/memories_remote_data_source.dart'
    as _i3;
import 'package:griot_app/memories/data/models/memory_model.dart' as _i2;
import 'package:griot_app/memories/data/models/video_model.dart' as _i7;
import 'package:griot_app/memories/domain/entities/video.dart' as _i5;
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

class _FakeMemoryModel_0 extends _i1.SmartFake implements _i2.MemoryModel {
  _FakeMemoryModel_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MemoriesRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockMemoriesRemoteDataSource extends _i1.Mock
    implements _i3.MemoriesRemoteDataSource {
  MockMemoriesRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i2.MemoryModel>> getMemoriesListFromAPI() =>
      (super.noSuchMethod(
        Invocation.method(
          #getMemoriesListFromAPI,
          [],
        ),
        returnValue:
            _i4.Future<List<_i2.MemoryModel>>.value(<_i2.MemoryModel>[]),
      ) as _i4.Future<List<_i2.MemoryModel>>);
  @override
  _i4.Future<_i2.MemoryModel> getMemoryDetailsFromAPI(
          {required int? memoryId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMemoryDetailsFromAPI,
          [],
          {#memoryId: memoryId},
        ),
        returnValue: _i4.Future<_i2.MemoryModel>.value(_FakeMemoryModel_0(
          this,
          Invocation.method(
            #getMemoryDetailsFromAPI,
            [],
            {#memoryId: memoryId},
          ),
        )),
      ) as _i4.Future<_i2.MemoryModel>);
  @override
  _i4.Future<_i2.MemoryModel> postMemoryToAPI({
    required String? title,
    required List<_i5.Video>? videos,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #postMemoryToAPI,
          [],
          {
            #title: title,
            #videos: videos,
          },
        ),
        returnValue: _i4.Future<_i2.MemoryModel>.value(_FakeMemoryModel_0(
          this,
          Invocation.method(
            #postMemoryToAPI,
            [],
            {
              #title: title,
              #videos: videos,
            },
          ),
        )),
      ) as _i4.Future<_i2.MemoryModel>);
}

/// A class which mocks [MemoriesLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockMemoriesLocalDataSource extends _i1.Mock
    implements _i6.MemoriesLocalDataSource {
  MockMemoriesLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i7.VideoModel>?> getVideosFromLibraryFromDevice() =>
      (super.noSuchMethod(
        Invocation.method(
          #getVideosFromLibraryFromDevice,
          [],
        ),
        returnValue: _i4.Future<List<_i7.VideoModel>?>.value(),
      ) as _i4.Future<List<_i7.VideoModel>?>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i8.NetworkInfo {
  MockNetworkInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> get isConnected => (super.noSuchMethod(
        Invocation.getter(#isConnected),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
}
