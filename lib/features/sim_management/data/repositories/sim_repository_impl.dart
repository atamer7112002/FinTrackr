import 'package:dartz/dartz.dart';
import '../../domain/entities/sim_card.dart';
import '../../domain/repositories/sim_repository.dart';
import '../../../../core/error/failures.dart';
import '../datasources/sim_local_data_source.dart';

class SimRepositoryImpl implements SimRepository {
  final SimLocalDataSource localDataSource;

  SimRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<SimCard>>> getAvailableSimCards() async {
    try {
      final hasPermission = await localDataSource.checkPermissions();
      if (!hasPermission) {
        return const Left(PermissionFailure());
      }

      final simCards = await localDataSource.getSimCards();

      if (simCards.isEmpty) {
        return const Left(NoSimCardsFailure());
      }

      return Right(simCards);
    } catch (e) {
      return Left(SystemFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkSimPermissions() async {
    try {
      final result = await localDataSource.checkPermissions();
      return Right(result);
    } catch (e) {
      return Left(SystemFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> requestSimPermissions() async {
    try {
      final result = await localDataSource.requestPermissions();
      if (!result) {
        return const Left(PermissionFailure('User denied permission'));
      }
      return Right(result);
    } catch (e) {
      return Left(SystemFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<SimCard>>> watchSimCards() {
    try {
      return localDataSource
          .watchSimCards()
          .map((simCards) {
            if (simCards.isEmpty) {
              return const Left<Failure, List<SimCard>>(NoSimCardsFailure());
            }
            return Right<Failure, List<SimCard>>(simCards);
          })
          .handleError((error) {
            return Left<Failure, List<SimCard>>(
              SystemFailure(error.toString()),
            );
          });
    } catch (e) {
      return Stream.value(Left(SystemFailure(e.toString())));
    }
  }
}
