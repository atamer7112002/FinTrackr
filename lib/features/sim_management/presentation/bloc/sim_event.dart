import 'package:equatable/equatable.dart';

abstract class SimEvent extends Equatable {
  const SimEvent();

  @override
  List<Object?> get props => [];
}

class LoadSimCards extends SimEvent {}

class RefreshSimCards extends SimEvent {}

class CheckPermissions extends SimEvent {}

class RequestPermissions extends SimEvent {}
