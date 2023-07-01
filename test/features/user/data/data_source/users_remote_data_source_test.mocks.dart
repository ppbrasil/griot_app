// Mocks generated by Mockito 5.4.1 from annotations
// in griot_app/test/features/user/data/data_source/users_remote_data_source_test.dart.
// Do not manually edit this file.

// @dart=2.19

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:dartz/dartz.dart' as _i4;
import 'package:griot_app/core/data/griot_http_client_wrapper.dart' as _i5;
import 'package:griot_app/core/data/token_provider.dart' as _i7;
import 'package:griot_app/core/domain/repositories/core_repository.dart' as _i2;
import 'package:griot_app/core/network/network_info.dart' as _i8;
import 'package:http/http.dart' as _i3;
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

class _FakeCoreRepository_0 extends _i1.SmartFake
    implements _i2.CoreRepository {
  _FakeCoreRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeClient_1 extends _i1.SmartFake implements _i3.Client {
  _FakeClient_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_2<L, R> extends _i1.SmartFake implements _i4.Either<L, R> {
  _FakeEither_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GriotHttpServiceWrapper].
///
/// See the documentation for Mockito's code generation for more information.
class MockGriotHttpServiceWrapper extends _i1.Mock
    implements _i5.GriotHttpServiceWrapper {
  MockGriotHttpServiceWrapper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.CoreRepository get coreRepository => (super.noSuchMethod(
        Invocation.getter(#coreRepository),
        returnValue: _FakeCoreRepository_0(
          this,
          Invocation.getter(#coreRepository),
        ),
      ) as _i2.CoreRepository);
  @override
  _i3.Client get client => (super.noSuchMethod(
        Invocation.getter(#client),
        returnValue: _FakeClient_1(
          this,
          Invocation.getter(#client),
        ),
      ) as _i3.Client);
  @override
  _i6.Future<_i4.Either<Exception, _i3.Response>> get(
    Uri? url, {
    required Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [url],
          {#headers: headers},
        ),
        returnValue: _i6.Future<_i4.Either<Exception, _i3.Response>>.value(
            _FakeEither_2<Exception, _i3.Response>(
          this,
          Invocation.method(
            #get,
            [url],
            {#headers: headers},
          ),
        )),
      ) as _i6.Future<_i4.Either<Exception, _i3.Response>>);
  @override
  _i6.Future<_i4.Either<Exception, _i3.Response>> post(
    Uri? url, {
    required Map<String, String>? headers,
    required Object? body,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [url],
          {
            #headers: headers,
            #body: body,
          },
        ),
        returnValue: _i6.Future<_i4.Either<Exception, _i3.Response>>.value(
            _FakeEither_2<Exception, _i3.Response>(
          this,
          Invocation.method(
            #post,
            [url],
            {
              #headers: headers,
              #body: body,
            },
          ),
        )),
      ) as _i6.Future<_i4.Either<Exception, _i3.Response>>);
  @override
  _i6.Future<_i4.Either<Exception, _i3.Response>> put(
    Uri? url, {
    required Map<String, String>? headers,
    required Object? body,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #put,
          [url],
          {
            #headers: headers,
            #body: body,
          },
        ),
        returnValue: _i6.Future<_i4.Either<Exception, _i3.Response>>.value(
            _FakeEither_2<Exception, _i3.Response>(
          this,
          Invocation.method(
            #put,
            [url],
            {
              #headers: headers,
              #body: body,
            },
          ),
        )),
      ) as _i6.Future<_i4.Either<Exception, _i3.Response>>);
  @override
  _i6.Future<_i4.Either<Exception, _i3.Response>> delete(
    Uri? url, {
    required Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [url],
          {#headers: headers},
        ),
        returnValue: _i6.Future<_i4.Either<Exception, _i3.Response>>.value(
            _FakeEither_2<Exception, _i3.Response>(
          this,
          Invocation.method(
            #delete,
            [url],
            {#headers: headers},
          ),
        )),
      ) as _i6.Future<_i4.Either<Exception, _i3.Response>>);
  @override
  _i6.Future<_i4.Either<Exception, _i3.Response>> patch(
    Uri? url, {
    required Map<String, String>? headers,
    required Object? body,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #patch,
          [url],
          {
            #headers: headers,
            #body: body,
          },
        ),
        returnValue: _i6.Future<_i4.Either<Exception, _i3.Response>>.value(
            _FakeEither_2<Exception, _i3.Response>(
          this,
          Invocation.method(
            #patch,
            [url],
            {
              #headers: headers,
              #body: body,
            },
          ),
        )),
      ) as _i6.Future<_i4.Either<Exception, _i3.Response>>);
  @override
  _i6.Future<_i4.Either<Exception, _i3.StreamedResponse>> multipartRequest(
    String? method,
    Uri? url, {
    required Map<String, String>? headers,
    required List<_i3.MultipartFile>? files,
    Map<String, String>? fields,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #multipartRequest,
          [
            method,
            url,
          ],
          {
            #headers: headers,
            #files: files,
            #fields: fields,
          },
        ),
        returnValue:
            _i6.Future<_i4.Either<Exception, _i3.StreamedResponse>>.value(
                _FakeEither_2<Exception, _i3.StreamedResponse>(
          this,
          Invocation.method(
            #multipartRequest,
            [
              method,
              url,
            ],
            {
              #headers: headers,
              #files: files,
              #fields: fields,
            },
          ),
        )),
      ) as _i6.Future<_i4.Either<Exception, _i3.StreamedResponse>>);
  @override
  _i6.Future<_i4.Either<Exception, _i3.Response>> handleError(
          dynamic response) =>
      (super.noSuchMethod(
        Invocation.method(
          #handleError,
          [response],
        ),
        returnValue: _i6.Future<_i4.Either<Exception, _i3.Response>>.value(
            _FakeEither_2<Exception, _i3.Response>(
          this,
          Invocation.method(
            #handleError,
            [response],
          ),
        )),
      ) as _i6.Future<_i4.Either<Exception, _i3.Response>>);
  @override
  _i6.Future<_i4.Either<Exception, _i3.StreamedResponse>> handleMultipartError(
          _i3.StreamedResponse? response) =>
      (super.noSuchMethod(
        Invocation.method(
          #handleMultipartError,
          [response],
        ),
        returnValue:
            _i6.Future<_i4.Either<Exception, _i3.StreamedResponse>>.value(
                _FakeEither_2<Exception, _i3.StreamedResponse>(
          this,
          Invocation.method(
            #handleMultipartError,
            [response],
          ),
        )),
      ) as _i6.Future<_i4.Either<Exception, _i3.StreamedResponse>>);
}

/// A class which mocks [TokenProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockTokenProvider extends _i1.Mock implements _i7.TokenProvider {
  MockTokenProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<String> getToken() => (super.noSuchMethod(
        Invocation.method(
          #getToken,
          [],
        ),
        returnValue: _i6.Future<String>.value(''),
      ) as _i6.Future<String>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i8.NetworkInfo {
  MockNetworkInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<bool> get isConnected => (super.noSuchMethod(
        Invocation.getter(#isConnected),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
}
