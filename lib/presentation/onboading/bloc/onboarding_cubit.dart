import 'package:electra/presentation/onboading/models/onboarding_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit()
    : super(
        OnboardingState(
          settings: OnboardingSettings(
            currency: "USD",
            language: "EN",
            expensesOnly: true,
            monthlyBudget: 0,
          ),
        ),
      );

  void changeCurrency(String currency) {
    emit(state.copyWith(settings: state.settings.copyWith(currency: currency)));
  }

  void changeLanguage(String language) {
    emit(state.copyWith(settings: state.settings.copyWith(language: language)));
  }

  void toggleAccountMode() {
    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          expensesOnly: !state.settings.expensesOnly,
        ),
      ),
    );
  }

  void changeBudget(double budget) {
    emit(
      state.copyWith(settings: state.settings.copyWith(monthlyBudget: budget)),
    );
  }
}
