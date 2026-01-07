import 'package:dartz/dartz.dart';
import '../entities/sim_card.dart';
import '../repositories/sim_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetSimCardsUseCase implements UseCase<List<SimCard>, NoParams> {
  final SimRepository repository;

  GetSimCardsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SimCard>>> call(NoParams params) async {
    return await repository.getAvailableSimCards();
  }
}
