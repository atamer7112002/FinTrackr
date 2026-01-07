import 'package:get_it/get_it.dart';
import '../../features/sim_management/data/datasources/sim_local_data_source.dart';
import '../../features/sim_management/data/repositories/sim_repository_impl.dart';
import '../../features/sim_management/domain/repositories/sim_repository.dart';
import '../../features/sim_management/domain/usecases/get_sim_cards_usecase.dart';
import '../../features/sim_management/domain/usecases/check_sim_permissions_usecase.dart';
import '../../features/sim_management/domain/usecases/request_sim_permissions_usecase.dart';
import '../../features/sim_management/presentation/bloc/sim_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<SimLocalDataSource>(() => SimLocalDataSourceImpl());

  sl.registerLazySingleton<SimRepository>(
    () => SimRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetSimCardsUseCase(sl()));
  sl.registerLazySingleton(() => CheckSimPermissionsUseCase(sl()));
  sl.registerLazySingleton(() => RequestSimPermissionsUseCase(sl()));

  sl.registerFactory(
    () => SimBloc(
      getSimCards: sl(),
      checkPermissions: sl(),
      requestPermissions: sl(),
    ),
  );
}
