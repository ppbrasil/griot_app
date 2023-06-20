part of 'profile_bloc_bloc.dart';

abstract class ProfileBlocEvent extends Equatable {
  const ProfileBlocEvent();

  @override
  List<Object> get props => [];
}

class GetProfileDetailsEvent extends ProfileBlocEvent {
  const GetProfileDetailsEvent();

  @override
  List<Object> get props => [];
}

class UpdateProfileDetailsEvent extends ProfileBlocEvent {
  final Profile profile;

  const UpdateProfileDetailsEvent({required this.profile});

  @override
  List<Object> get props => [profile];
}
