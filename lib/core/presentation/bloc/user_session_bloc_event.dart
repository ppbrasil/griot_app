part of 'user_session_bloc_bloc.dart';

abstract class UserSessionBlocEvent extends Equatable {
  const UserSessionBlocEvent();

  @override
  List<Object> get props => [];
}

class TokenFailedBlocEvent extends UserSessionBlocEvent {}
