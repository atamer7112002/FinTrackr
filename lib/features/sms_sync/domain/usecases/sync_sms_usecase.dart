import 'package:dartz/dartz.dart';
import '../repositories/sms_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/sms_message.dart';

class SyncSmsUseCase implements UseCase<bool, List<SmsMessage>> {
  final SmsRepository repository;

  SyncSmsUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(List<SmsMessage> params) async {
    return await repository.syncSms(params);
  }
}
