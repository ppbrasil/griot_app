// Mocks generated by Mockito 5.4.2 from annotations
// in griot_app/test/features/authentication/data/repositories/auth_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:griot_app/accounts/domain/entities/account.dart' as _i6;
import 'package:griot_app/authentication/data/data_sources/auth_data_source.dart'
    as _i3;
import 'package:griot_app/authentication/data/models/token_model.dart' as _i2;
import 'package:griot_app/core/network/network_info.dart' as _i7;
import 'package:griot_app/user/data/data_sources/users_remote_data_source.dart'
    as _i5;
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

class _FakeTokenModel_0 extends _i1.SmartFake implements _i2.TokenModel {
  _FakeTokenModel_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AuthRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthRemoteDataSource extends _i1.Mock
    implements _i3.AuthRemoteDataSource {
  MockAuthRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.TokenModel> login(
    String? username,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #login,
          [
            username,
            password,
          ],
        ),
        returnValue: _i4.Future<_i2.TokenModel>.value(_FakeTokenModel_0(
          this,
          Invocation.method(
            #login,
            [
              username,
              password,
            ],
          ),
        )),
      ) as _i4.Future<_i2.TokenModel>);
  @override
  _i4.Future<void> storeTokenToSharedPreferences(
          _i2.TokenModel? tokenToStore) =>
      (super.noSuchMethod(
        Invocation.method(
          #storeTokenToSharedPreferences,
          [tokenToStore],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<bool> destroyTokenFromSharedPreferences() => (super.noSuchMethod(
        Invocation.method(
          #destroyTokenFromSharedPreferences,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
}

/// A class which mocks [UsersRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockUsersRemoteDataSource extends _i1.Mock
    implements _i5.UsersRemoteDataSource {
  MockUsersRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i6.Account>> getBelovedAccountsListFromAPI() =>
      (super.noSuchMethod(
        Invocation.method(
          #getBelovedAccountsListFromAPI,
          [],
        ),
        returnValue: _i4.Future<List<_i6.Account>>.value(<_i6.Account>[]),
      ) as _i4.Future<List<_i6.Account>>);
  @override
  _i4.Future<List<_i6.Account>> getOwnedAccountsListFromAPI() =>
      (super.noSuchMethod(
        Invocation.method(
          #getOwnedAccountsListFromAPI,
          [],
        ),
        returnValue: _i4.Future<List<_i6.Account>>.value(<_i6.Account>[]),
      ) as _i4.Future<List<_i6.Account>>);
  @override
  _i4.Future<void> storeMainAccountId({required int? mainAccountId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #storeMainAccountId,
          [],
          {#mainAccountId: mainAccountId},
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i7.NetworkInfo {
  MockNetworkInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> get isConnected => (super.noSuchMethod(
        Invocation.getter(#isConnected),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
}
