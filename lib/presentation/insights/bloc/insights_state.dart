import 'package:electra/domain/entities/insights/insights.dart';
import 'package:equatable/equatable.dart';

abstract class InsightsState extends Equatable {
  const InsightsState();

  @override
  List<Object?> get props => [];
}

class InsightsInitial extends InsightsState {
  const InsightsInitial();
}

class InsightsLoading extends InsightsState {
  const InsightsLoading();
}

class InsightsLoaded extends InsightsState {
  final SpendingInsights insights;
  final String period;
  final DateTime anchorDate;

  const InsightsLoaded({
    required this.insights,
    required this.period,
    required this.anchorDate,
  });

  @override
  List<Object?> get props => [insights, period, anchorDate];
}

class InsightsFailure extends InsightsState {
  final String message;
  const InsightsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
