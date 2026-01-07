import 'package:dartz/dartz.dart';
import '../repositories/sim_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class CheckSimPermissionsUseCase implements UseCase<bool, NoParams> {
  final SimRepository repository;

  CheckSimPermissionsUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.checkSimPermissions();
  }
}
