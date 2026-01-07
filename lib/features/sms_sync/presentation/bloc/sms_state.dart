import 'package:equatable/equatable.dart';
import '../../domain/entities/sms_message.dart';
import '../../../../core/error/failures.dart';

abstract class SmsState extends Equatable {
  const SmsState();

  @override
  List<Object?> get props => [];
}

class SmsInitial extends SmsState {}

class SmsLoading extends SmsState {}

class SmsLoaded extends SmsState {
  final List<SmsMessage> messages;

  const SmsLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class SmsSyncing extends SmsState {
  final List<SmsMessage> messages;

  const SmsSyncing(this.messages);

  @override
  List<Object?> get props => [messages];
}

class SmsSyncSuccess extends SmsState {
  final List<SmsMessage> messages;

  const SmsSyncSuccess(this.messages);

  @override
  List<Object?> get props => [messages];
}

class SmsPermissionDenied extends SmsState {}

class SmsError extends SmsState {
  final Failure failure;

  const SmsError(this.failure);

  @override
  List<Object?> get props => [failure];
}
