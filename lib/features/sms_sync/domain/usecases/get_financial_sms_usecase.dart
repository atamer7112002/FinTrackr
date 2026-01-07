import 'package:dartz/dartz.dart';
import '../entities/sms_message.dart';
import '../repositories/sms_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetFinancialSmsUseCase implements UseCase<List<SmsMessage>, NoParams> {
  final SmsRepository repository;

  GetFinancialSmsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SmsMessage>>> call(NoParams params) async {
    return await repository.getFinancialSms();
  }
}
