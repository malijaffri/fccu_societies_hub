import 'package:flutter/material.dart';

class AppSettings {
  final bool notifyOnLike;
  final bool notifyOnComment;
  final ThemeMode themeMode;

  const AppSettings({
    this.notifyOnLike = true,
    this.notifyOnComment = true,
    this.themeMode = ThemeMode.system,
  });

  AppSettings copyWith({
    bool? notifyOnLike,
    bool? notifyOnComment,
    ThemeMode? themeMode,
  }) => AppSettings(
    notifyOnLike: notifyOnLike ?? this.notifyOnLike,
    notifyOnComment: notifyOnComment ?? this.notifyOnComment,
    themeMode: themeMode ?? this.themeMode,
  );

  static const _keyNotifyLike = 'notify_like';
  static const _keyNotifyComment = 'notify_comment';
  static const _keyTheme = 'theme_mode';

  Map<String, dynamic> toPrefs() => {
    _keyNotifyLike: notifyOnLike,
    _keyNotifyComment: notifyOnComment,
    _keyTheme: themeMode.index,
  };

  static AppSettings fromPrefs(Map<String, dynamic> prefs) => AppSettings(
    notifyOnLike: prefs[_keyNotifyLike] as bool? ?? true,
    notifyOnComment: prefs[_keyNotifyComment] as bool? ?? true,
    themeMode: ThemeMode.values[prefs[_keyTheme] as int? ?? ThemeMode.system.index],
  );
}
