import 'package:dartz/dartz.dart';
import 'package:griot_app/beloved_ones/domain/entities/beloved_one.dart';
import 'package:griot_app/core/error/failures.dart';

abstract class BelovedOnesRepository {
  Future<Either<Failure, List<BelovedOne>>> performGeBelovedOnesList();
}
