import 'package:equatable/equatable.dart';
import '../../domain/entities/sim_card.dart';
import '../../../../core/error/failures.dart';

abstract class SimState extends Equatable {
  const SimState();

  @override
  List<Object?> get props => [];
}

class SimInitial extends SimState {}

class SimLoading extends SimState {}

class SimLoaded extends SimState {
  final List<SimCard> simCards;

  const SimLoaded(this.simCards);

  @override
  List<Object?> get props => [simCards];
}

class SimError extends SimState {
  final Failure failure;

  const SimError(this.failure);

  @override
  List<Object?> get props => [failure];
}

class PermissionDenied extends SimState {}

class NoSimCardsFound extends SimState {}
