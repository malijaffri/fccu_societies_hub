import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fccu_societies_hub/models/app_settings.dart';

class AppSettingsNotifier extends Notifier<AppSettings> {
  static const _prefix = 'settings_';

  @override
  AppSettings build() {
    _load();
    return const AppSettings();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final map = {
      'notify_like': prefs.getBool('${_prefix}notify_like'),
      'notify_comment': prefs.getBool('${_prefix}notify_comment'),
      'theme_mode': prefs.getInt('${_prefix}theme_mode'),
    };
    state = AppSettings.fromPrefs(map);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final map = state.toPrefs();
    await prefs.setBool('${_prefix}notify_like', map['notify_like'] as bool);
    await prefs.setBool('${_prefix}notify_comment', map['notify_comment'] as bool);
    await prefs.setInt('${_prefix}theme_mode', map['theme_mode'] as int);
  }

  void setNotifyOnLike(bool value) {
    state = state.copyWith(notifyOnLike: value);
    _save();
  }

  void setNotifyOnComment(bool value) {
    state = state.copyWith(notifyOnComment: value);
    _save();
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _save();
  }
}

final appSettingsProvider = NotifierProvider<AppSettingsNotifier, AppSettings>(
  AppSettingsNotifier.new,
);
