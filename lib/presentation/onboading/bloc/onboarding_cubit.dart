// import 'package:electra/core/utils/constants/onboarding_length.dart';
// import 'package:electra/core/utils/constants/storage_keys.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart';

// class OnboardingCubit extends HydratedCubit<int> {
//   static const int _initialStep = 1;

//   OnboardingCubit() : super(_initialStep);

//   void next() => emit(state + 1);

//   void previous() => emit(state - 1);

//   void skip() => emit(OnboardingConstants.length + 1);

//   void reset() => emit(_initialStep);

//   @override
//   int? fromJson(Map<String, dynamic> json) {
//     return json[StorageKeys.onboarding];
//   }

//   @override
//   Map<String, dynamic>? toJson(int state) {
//     return {StorageKeys.onboarding: state};
//   }
// }

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
