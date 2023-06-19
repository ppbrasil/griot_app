part of 'profile_bloc_bloc.dart';

abstract class ProfileBlocEvent extends Equatable {
  const ProfileBlocEvent();

  @override
  List<Object> get props => [];
}

class GetProfileInfoEvent extends ProfileBlocEvent {
  const GetProfileInfoEvent();

  @override
  List<Object> get props => [];
}

class UpdateProfileInfoEvent extends ProfileBlocEvent {
  final Profile profile;

  const UpdateProfileInfoEvent({required this.profile});

  @override
  List<Object> get props => [profile];
}
