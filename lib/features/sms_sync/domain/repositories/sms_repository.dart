import 'package:dartz/dartz.dart';
import '../entities/sms_message.dart';
import '../../../../core/error/failures.dart';

abstract class SmsRepository {
  Future<Either<Failure, List<SmsMessage>>> getFinancialSms();
  Future<Either<Failure, bool>> checkSmsPermissions();
  Future<Either<Failure, bool>> requestSmsPermissions();
  Future<Either<Failure, bool>> syncSms(List<SmsMessage> messages);
}
