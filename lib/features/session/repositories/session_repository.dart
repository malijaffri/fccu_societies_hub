import 'package:shared_preferences/shared_preferences.dart';

import 'package:fccu_societies_hub/features/session/models/session_mode.dart';

abstract class SessionRepository {
  Future<SessionMode> loadSessionMode();

  Future<void> setGuestMode();

  Future<void> clearGuestMode();
}

class LocalSessionRepository implements SessionRepository {
  static const _guestKey = 'guest_mode';

  @override
  Future<SessionMode> loadSessionMode() async {
    final prefs = await SharedPreferences.getInstance();

    final isGuest = prefs.getBool(_guestKey) ?? false;

    if (isGuest) {
      return SessionMode.guest;
    }

    return SessionMode.loggedOut;
  }

  @override
  Future<void> setGuestMode() async => await (await SharedPreferences.getInstance()).setBool(_guestKey, true);

  @override
  Future<void> clearGuestMode() async => await (await SharedPreferences.getInstance()).remove(_guestKey);
}
