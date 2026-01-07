import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_sim_cards_usecase.dart';
import '../../domain/usecases/check_sim_permissions_usecase.dart';
import '../../domain/usecases/request_sim_permissions_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import 'sim_event.dart';
import 'sim_state.dart';

class SimBloc extends Bloc<SimEvent, SimState> {
  final GetSimCardsUseCase getSimCards;
  final CheckSimPermissionsUseCase checkPermissions;
  final RequestSimPermissionsUseCase requestPermissions;

  SimBloc({
    required this.getSimCards,
    required this.checkPermissions,
    required this.requestPermissions,
  }) : super(SimInitial()) {
    on<LoadSimCards>(_onLoadSimCards);
    on<RefreshSimCards>(_onRefreshSimCards);
    on<CheckPermissions>(_onCheckPermissions);
    on<RequestPermissions>(_onRequestPermissions);
  }

  Future<void> _onLoadSimCards(
    LoadSimCards event,
    Emitter<SimState> emit,
  ) async {
    emit(SimLoading());

    final permissionResult = await checkPermissions(NoParams());
    await permissionResult.fold((failure) async => emit(SimError(failure)), (
      hasPermission,
    ) async {
      if (!hasPermission) {
        emit(PermissionDenied());
        return;
      }

      final result = await getSimCards(NoParams());
      result.fold((failure) {
        if (failure is NoSimCardsFailure) {
          emit(NoSimCardsFound());
        } else if (failure is PermissionFailure) {
          emit(PermissionDenied());
        } else {
          emit(SimError(failure));
        }
      }, (simCards) => emit(SimLoaded(simCards)));
    });
  }

  Future<void> _onRefreshSimCards(
    RefreshSimCards event,
    Emitter<SimState> emit,
  ) async {
    final result = await getSimCards(NoParams());
    result.fold((failure) {
      if (failure is NoSimCardsFailure) {
        emit(NoSimCardsFound());
      } else if (failure is PermissionFailure) {
        emit(PermissionDenied());
      } else {
        emit(SimError(failure));
      }
    }, (simCards) => emit(SimLoaded(simCards)));
  }

  Future<void> _onCheckPermissions(
    CheckPermissions event,
    Emitter<SimState> emit,
  ) async {
    final result = await checkPermissions(NoParams());
    result.fold((failure) => emit(SimError(failure)), (hasPermission) {
      if (!hasPermission) {
        emit(PermissionDenied());
      }
    });
  }

  Future<void> _onRequestPermissions(
    RequestPermissions event,
    Emitter<SimState> emit,
  ) async {
    final result = await requestPermissions(NoParams());
    result.fold((failure) => emit(PermissionDenied()), (granted) {
      if (granted) {
        add(LoadSimCards());
      } else {
        emit(PermissionDenied());
      }
    });
  }
}
