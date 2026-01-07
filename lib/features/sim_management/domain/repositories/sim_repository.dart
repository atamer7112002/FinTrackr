import 'package:dartz/dartz.dart';
import '../entities/sim_card.dart';
import '../../../../core/error/failures.dart';

abstract class SimRepository {
  Future<Either<Failure, List<SimCard>>> getAvailableSimCards();
  Future<Either<Failure, bool>> checkSimPermissions();
  Future<Either<Failure, bool>> requestSimPermissions();
  Stream<Either<Failure, List<SimCard>>> watchSimCards();
}
