part of 'user_session_bloc_bloc.dart';

abstract class UserSessionBlocState extends Equatable {
  const UserSessionBlocState();

  @override
  List<Object> get props => [];
}

class UserSessionBlocInitial extends UserSessionBlocState {}

class UserLostSessionEvent extends UserSessionBlocState {}
