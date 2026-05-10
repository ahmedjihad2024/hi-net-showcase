import 'dart:convert';

import 'package:hi_net/app/supported_locales.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../../data/responses/responses.dart';

abstract class AbstractAppPreferences {
  Future<bool> setSkippedOnBoarding();
  Future<bool> resetOnBoarding();

  Future<void> setToken(String token);
  Future<void> setRefreshToken(String token);
  Future<void> setTheme(bool isDark);

  Future<void> setLanguage(SupportedLocales language);

  Future<void> clearAllTokens();

  Future<void> reload();

  Future<void> setUserData(User user);

  Future<void> deleteUserData();

  Future<User?> getUserData();

  String? get token;

  String? get refreshToken;

  bool get isSkippedOnBoarding;

  bool get isUserRegistered;

  SupportedLocales? get language;

  bool? get isDark;
}

class AppPreferences implements AbstractAppPreferences {
  final SharedPreferences _sharedPreferences;

  const AppPreferences(this._sharedPreferences);

  SharedPreferences get sharedPreferences => _sharedPreferences;

  @override
  Future<bool> resetOnBoarding() async =>
      await _sharedPreferences.setBool(Constants.skippedOnBoarding, false);

  @override
  Future<bool> setSkippedOnBoarding() async =>
      await _sharedPreferences.setBool(Constants.skippedOnBoarding, true);

  @override
  bool get isSkippedOnBoarding =>
      _sharedPreferences.getBool(Constants.skippedOnBoarding) ?? false;

  @override
  Future<void> setToken(String token) async =>
      await _sharedPreferences.setString(Constants.accessToken, token);

  @override
  Future<void> setRefreshToken(String token) async =>
      await _sharedPreferences.setString(Constants.refreshToken, token);

  @override
  bool get isUserRegistered =>
      _sharedPreferences.getString(Constants.accessToken) != null;

  @override
  Future<void> clearAllTokens() async {
    await _sharedPreferences.remove(Constants.accessToken);
    await _sharedPreferences.remove(Constants.refreshToken);
  }

  @override
  String? get token => _sharedPreferences.getString(Constants.accessToken);

  @override
  String? get refreshToken =>
      _sharedPreferences.getString(Constants.refreshToken);

  @override
  SupportedLocales? get language {
    String? lan = _sharedPreferences.getString(Constants.language);
    if (lan == null) return null;
    return SupportedLocales.fromString(lan);
  }

  @override
  Future<void> setLanguage(SupportedLocales language) async =>
      _sharedPreferences.setString(Constants.language, language.name);

  @override
  bool? get isDark => _sharedPreferences.getBool(Constants.isDark);

  @override
  Future<void> setTheme(bool isDark) async =>
      _sharedPreferences.setBool(Constants.isDark, isDark);

  @override
  Future<void> reload() async => await _sharedPreferences.reload();

  bool get isLiveActivityEnabled =>
      _sharedPreferences.getBool(Constants.liveActivityEnabled) ?? true;

  Future<void> setLiveActivityEnabled(bool enabled) async =>
      _sharedPreferences.setBool(Constants.liveActivityEnabled, enabled);

  @override
  Future<void> setUserData(User user) async {
    final jsonString = jsonEncode(user.toJson());
    await _sharedPreferences.setString('user-data', jsonString);
  }

  @override
  Future<void> deleteUserData() async {
    await _sharedPreferences.remove('user-data');
  }

  @override
  Future<User?> getUserData() async {
    final jsonString = _sharedPreferences.getString('user-data');
    if (jsonString == null) {
      return null;
    }
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return User.fromJson(json);
  }
}
