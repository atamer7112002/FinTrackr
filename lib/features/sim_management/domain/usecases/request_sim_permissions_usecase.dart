import 'package:dartz/dartz.dart';
import '../repositories/sim_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class RequestSimPermissionsUseCase implements UseCase<bool, NoParams> {
  final SimRepository repository;

  RequestSimPermissionsUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.requestSimPermissions();
  }
}
