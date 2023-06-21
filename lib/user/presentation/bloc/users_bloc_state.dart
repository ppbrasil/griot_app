part of 'users_bloc_bloc.dart';

abstract class UsersBlocState extends Equatable {
  const UsersBlocState();

  @override
  List<Object> get props => [];
}

class UsersBlocInitial extends UsersBlocState {}

class UsersBlocLoading extends UsersBlocState {}

class UsersBlocSuccess extends UsersBlocState {
  final List<Account> ownedAccounstList;

  const UsersBlocSuccess({required this.ownedAccounstList});

  @override
  List<Object> get props => [ownedAccounstList];
}

class UsersBlocError extends UsersBlocState {}
