import 'package:dartz/dartz.dart';
import '../../domain/entities/sms_message.dart';
import '../../domain/repositories/sms_repository.dart';
import '../../../../core/error/failures.dart';
import '../datasources/sms_local_data_source.dart';

class SmsRepositoryImpl implements SmsRepository {
  final SmsLocalDataSource localDataSource;

  SmsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<SmsMessage>>> getFinancialSms() async {
    try {
      final hasPermission = await localDataSource.checkPermissions();
      if (!hasPermission) {
        return const Left(PermissionFailure('SMS permission denied'));
      }

      final messages = await localDataSource.getFinancialSms();
      return Right(messages);
    } catch (e) {
      return Left(SystemFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkSmsPermissions() async {
    try {
      final result = await localDataSource.checkPermissions();
      return Right(result);
    } catch (e) {
      return Left(SystemFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> requestSmsPermissions() async {
    try {
      final result = await localDataSource.requestPermissions();
      if (!result) {
        return const Left(PermissionFailure('User denied SMS permission'));
      }
      return Right(result);
    } catch (e) {
      return Left(SystemFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> syncSms(List<SmsMessage> messages) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(true);
    } catch (e) {
      return Left(SystemFailure(e.toString()));
    }
  }
}
