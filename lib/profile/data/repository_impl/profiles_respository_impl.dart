import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:griot_app/profile/data/data_sources/profiles_remote_data_source.dart';
import 'package:griot_app/profile/domain/entities/profile.dart';
import 'package:griot_app/profile/domain/repositories/profile_respository.dart';

class ProfilesRepositoryImpl implements ProfilesRepository {
  final NetworkInfo networkInfo;
  final ProfilesRemoteDataSource remoteDataSource;

  ProfilesRepositoryImpl(
      {required this.networkInfo, required this.remoteDataSource});

  @override
  Future<Either<Failure, Profile>> performGetProfileDetails() async {
    if (await networkInfo.isConnected) {
      try {
        Profile profile = await remoteDataSource.getProfileDetailsFromAPI();

        return Right(profile);
      } on ServerFailure {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Profile>> performUpdateProfileDetails({
    String? profilePicture,
    String? name,
    String? middleName,
    String? lastName,
    DateTime? birthDate,
    String? gender,
    String? language,
    String? timeZone,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        Profile profile = await remoteDataSource.updateProfileDetailsOverAPI(
          profilePicture: profilePicture,
          name: name,
          middleName: middleName,
          lastName: lastName,
          birthDate: birthDate,
          gender: gender,
          language: language,
          timeZone: timeZone,
        );

        return Right(profile);
      } on ServerFailure {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }
}
