import 'package:shared_preferences/shared_preferences.dart';

class OnboardingStorage {
  static const _key = 'has_seen_onboarding';
  final SharedPreferences _prefs;

  const OnboardingStorage(this._prefs);

  Future<bool> get hasSeenOnboarding async => _prefs.getBool(_key) ?? false;

  Future<void> markOnboardingSeen() => _prefs.setBool(_key, true);
}
