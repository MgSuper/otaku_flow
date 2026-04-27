import 'package:shared_preferences/shared_preferences.dart';

abstract interface class OnboardingStorage {
  Future<bool> isCompleted();
  Future<void> setCompleted();
}

class SharedPrefsOnboardingStorage implements OnboardingStorage {
  final SharedPreferences _prefs;
  static const _key = 'onboarding_completed';

  SharedPrefsOnboardingStorage(this._prefs);

  @override
  Future<bool> isCompleted() async {
    return _prefs.getBool(_key) ?? false;
  }

  @override
  Future<void> setCompleted() async {
    await _prefs.setBool(_key, true);
  }
}
