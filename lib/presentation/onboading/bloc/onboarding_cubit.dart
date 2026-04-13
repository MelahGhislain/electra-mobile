import 'package:electra/core/utils/constants/onboarding_length.dart';
import 'package:electra/core/utils/constants/storage_keys.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class OnboardingCubit extends HydratedCubit<int> {
  static const int _initialStep = 1;  
  
  OnboardingCubit() : super(_initialStep);

  void next() => emit(state + 1);

  void previous() => emit(state - 1);

  void skip() => emit(OnboardingConstants.length + 1);

  void reset() => emit(_initialStep);

  @override
  int? fromJson(Map<String, dynamic> json) {
    return json[StorageKeys.onboarding];
  }

  @override
  Map<String, dynamic>? toJson(int state) {
    return {StorageKeys.onboarding: state};
  }
}