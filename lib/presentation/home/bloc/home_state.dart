import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoaded extends HomeState {
  /// Whether the user has explicitly skipped the setup card.
  final bool setupSkipped;

  const HomeLoaded({required this.setupSkipped});

  /// Show the card only if not skipped AND setup is incomplete.
  /// [setupComplete] is passed in from the UserCubit state.
  bool showSetupCard(bool setupComplete) => !setupSkipped && !setupComplete;

  @override
  List<Object?> get props => [setupSkipped];
}
