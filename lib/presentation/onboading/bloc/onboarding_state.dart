import 'package:electra/presentation/onboading/models/onboarding_settings.dart';
import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final OnboardingSettings settings;

  const OnboardingState({required this.settings});

  OnboardingState copyWith({OnboardingSettings? settings}) {
    return OnboardingState(settings: settings ?? this.settings);
  }

  @override
  List<Object?> get props => [settings];
}
