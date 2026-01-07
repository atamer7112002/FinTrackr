import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permission denied']);
}

class DeviceNotSupportedFailure extends Failure {
  const DeviceNotSupportedFailure([
    super.message = 'Feature not supported on this device',
  ]);
}

class SystemFailure extends Failure {
  const SystemFailure([super.message = 'System error occurred']);
}

class NoSimCardsFailure extends Failure {
  const NoSimCardsFailure([super.message = 'No SIM cards detected']);
}
