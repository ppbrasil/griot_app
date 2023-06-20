import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/profile/domain/entities/profile.dart';
import 'package:griot_app/profile/domain/use_cases/perform_get_profile_details.dart'
    as getProfileUseCase;
import 'package:griot_app/profile/domain/use_cases/perform_update_profile_dateils.dart'
    as updateProfileUseCase;

part 'profile_bloc_event.dart';
part 'profile_bloc_state.dart';

class ProfileBlocBloc extends Bloc<ProfileBlocEvent, ProfileBlocState> {
  final getProfileUseCase.PerformGetProfileDetails getDetails;
  final updateProfileUseCase.PerformUpdateProfileDetails updateDetails;

  ProfileBlocBloc({
    required this.getDetails,
    required this.updateDetails,
  }) : super(ProfileInitial()) {
    on<GetProfileDetailsEvent>((event, emit) async {
      emit(ProfileGetDetailsLoading());
      final profileEither = await getDetails(getProfileUseCase.NoParams());
      profileEither.fold(
        (failure) => emit(const ProfileGetDetailsFailure(
            message: 'Failed to fetch profile details')),
        (profile) => emit(ProfileGetDetailsSuccess(profile: profile)),
      );
    });

    on<UpdateProfileDetailsEvent>((event, emit) async {
      emit(ProfileUpdateLoading());
      final profileEither = await updateDetails(updateProfileUseCase.Params(
        profilePicture: event.profile.profilePicture,
        name: event.profile.name,
        middleName: event.profile.middleName,
        lastName: event.profile.lastName,
        gender: event.profile.gender,
        birthDate: event.profile.birthDate,
        language: event.profile.language,
        timeZone: event.profile.timeZone,
      ));
      profileEither.fold(
        (failure) => emit(const ProfileUpdateFailure(
            message: 'Failed to update profile details')),
        (profile) => emit(ProfileUpdateSuccess(profile: profile)),
      );
    });
  }
}
