import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_financial_sms_usecase.dart';
import '../../domain/usecases/sync_sms_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import 'sms_event.dart';
import 'sms_state.dart';

class SmsBloc extends Bloc<SmsEvent, SmsState> {
  final GetFinancialSmsUseCase getFinancialSms;
  final SyncSmsUseCase syncSms;

  SmsBloc({required this.getFinancialSms, required this.syncSms})
    : super(SmsInitial()) {
    on<LoadFinancialSms>(_onLoadFinancialSms);
    on<SyncSms>(_onSyncSms);
  }

  Future<void> _onLoadFinancialSms(
    LoadFinancialSms event,
    Emitter<SmsState> emit,
  ) async {
    emit(SmsLoading());

    final result = await getFinancialSms(NoParams());
    result.fold((failure) {
      if (failure is PermissionFailure) {
        emit(SmsPermissionDenied());
      } else {
        emit(SmsError(failure));
      }
    }, (messages) => emit(SmsLoaded(messages)));
  }

  Future<void> _onSyncSms(SyncSms event, Emitter<SmsState> emit) async {
    if (state is SmsLoaded) {
      final messages = (state as SmsLoaded).messages;
      emit(SmsSyncing(messages));

      final result = await syncSms(messages);
      result.fold((failure) => emit(SmsError(failure)), (_) {
        emit(SmsSyncSuccess(messages));
        Future.delayed(const Duration(seconds: 2), () {
          if (!isClosed) {
            add(LoadFinancialSms());
          }
        });
      });
    }
  }
}
