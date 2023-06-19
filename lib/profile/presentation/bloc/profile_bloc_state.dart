part of 'profile_bloc_bloc.dart';

abstract class ProfileBlocState extends Equatable {
  const ProfileBlocState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileBlocState {}

class ProfileGetDetailsLoading extends ProfileBlocState {}

class ProfileGetDetailsSuccess extends ProfileBlocState {
  final Profile profile;

  const ProfileGetDetailsSuccess({required this.profile});

  @override
  List<Object> get props => [profile];
}

class ProfileGetDetailsFailure extends ProfileBlocState {
  final String message;

  const ProfileGetDetailsFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class ProfileUpdateLoading extends ProfileBlocState {}

class ProfileUpdateSuccess extends ProfileBlocState {
  final Profile profile;

  const ProfileUpdateSuccess({required this.profile});

  @override
  List<Object> get props => [profile];
}

class ProfileUpdateFailure extends ProfileBlocState {
  final String message;

  const ProfileUpdateFailure({required this.message});

  @override
  List<Object> get props => [message];
}
