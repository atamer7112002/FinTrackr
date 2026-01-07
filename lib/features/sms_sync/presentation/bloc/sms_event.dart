import 'package:equatable/equatable.dart';

abstract class SmsEvent extends Equatable {
  const SmsEvent();

  @override
  List<Object?> get props => [];
}

class LoadFinancialSms extends SmsEvent {}

class SyncSms extends SmsEvent {}

class RequestSmsPermission extends SmsEvent {}
