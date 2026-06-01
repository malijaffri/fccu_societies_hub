import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fccu_societies_hub/core/widgets/app_scaffold.dart';
import 'package:fccu_societies_hub/features/auth/screens/login_screen.dart';
import 'package:fccu_societies_hub/features/auth/screens/register_screen.dart';
import 'package:fccu_societies_hub/features/auth/screens/welcome_screen.dart';
import 'package:fccu_societies_hub/features/create_event/screens/create_event_screen.dart';
import 'package:fccu_societies_hub/features/create_post/screens/create_post_screen.dart';
import 'package:fccu_societies_hub/features/events/screens/event_details_screen.dart';
import 'package:fccu_societies_hub/features/events/screens/events_screen.dart';
import 'package:fccu_societies_hub/features/feed/screens/feed_screen.dart';
import 'package:fccu_societies_hub/features/posts/screens/post_details_screen.dart';
import 'package:fccu_societies_hub/features/notifications/screens/notifications_screen.dart';
import 'package:fccu_societies_hub/features/profile/screens/edit_profile_screen.dart';
import 'package:fccu_societies_hub/features/profile/screens/profile_screen.dart';
import 'package:fccu_societies_hub/features/profile/screens/settings_screen.dart';
import 'package:fccu_societies_hub/features/search/screens/search_screen.dart';
import 'package:fccu_societies_hub/features/session/models/session_mode.dart';
import 'package:fccu_societies_hub/features/session/providers/session_mode_provider.dart';
import 'package:fccu_societies_hub/features/societies/screens/society_details_screen.dart';

// ---------------------------------------------------------------------------
// Route definitions
// ---------------------------------------------------------------------------

class AppRoute {
  final String routeBase;
  final List<String> expectedParams;

  const AppRoute(this.routeBase, [this.expectedParams = const []]);

  String resolve([Map<String, String> params = const {}]) {
    // Dart Set.== is identity-based, not structural, so != always returns true
    // for two separately-created Sets even with identical contents. Use
    // containsAll both ways for correct structural comparison.
    final given = params.keys.toSet();
    final expected = expectedParams.toSet();
    if (given.length != expected.length || !given.containsAll(expected)) {
      throw ArgumentError(
        'Passed parameters $given don\'t match required set $expected',
      );
    }
    if (expectedParams.isEmpty) return routeBase;
    final joinedParams = expectedParams.map((p) => params[p]!).join('/');
    return '$routeBase/$joinedParams';
  }

  String asRoute() {
    if (expectedParams.isEmpty) return routeBase;
    final joinedParams = expectedParams.map((p) => ':$p').join('/');
    return '$routeBase/$joinedParams';
  }
}

class AppRoutes {
  AppRoutes._();

  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const homeFeed = '/';
  static const search = '/search';
  static const events = '/events';
  static const post = AppRoute('/post', ['id']);
  static const society = AppRoute('/society', ['id']);
  static const event = AppRoute('/event', ['id']);
  static const createPost = '/create-post';
  static const createEvent = '/create-event';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const settings = '/settings';
  static const notifications = '/notifications';

  static const _authRoutes = [welcome, login, register];

  static bool isAuthRoute(String location) => _authRoutes.contains(location);
}

// ---------------------------------------------------------------------------
// RouterNotifier — bridges Riverpod session state into GoRouter's listenable
// ---------------------------------------------------------------------------

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<SessionMode>>(sessionModeProvider, (_, _) {
      notifyListeners();
    });
  }

  final Ref _ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final session = _ref.read(sessionModeProvider).value;
    final onAuthRoute = AppRoutes.isAuthRoute(state.matchedLocation);

    return switch (session) {
      // Authenticated and guest users are redirected away from auth screens
      SessionMode.authenticated => onAuthRoute ? AppRoutes.homeFeed : null,
      SessionMode.guest => onAuthRoute ? AppRoutes.homeFeed : null,
      // Logged-out users are redirected to welcome from any non-auth screen
      SessionMode.loggedOut => onAuthRoute ? null : AppRoutes.welcome,
      // While session is still loading don't redirect
      null => null,
    };
  }
}

final _routerNotifierProvider = Provider<RouterNotifier>(
  (ref) => RouterNotifier(ref),
  // keep the notifier alive for the lifetime of the app
);

// ---------------------------------------------------------------------------
// Single, stable GoRouter instance
// ---------------------------------------------------------------------------

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(_routerNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.homeFeed,
    refreshListenable: notifier,
    redirect: notifier.redirect,

    routes: [
      GoRoute(path: AppRoutes.welcome, builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: AppRoutes.register, builder: (_, _) => const RegisterScreen()),

      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppScaffold(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: AppRoutes.homeFeed, builder: (_, _) => const FeedScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: AppRoutes.search, builder: (_, _) => const SearchScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: AppRoutes.events, builder: (_, _) => const EventsScreen())],
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.post.asRoute(),
        builder: (_, state) => PostDetailsScreen(postId: state.pathParameters['id']!),
      ),

      GoRoute(
        path: AppRoutes.society.asRoute(),
        builder: (_, state) => SocietyDetailsScreen(societyId: state.pathParameters['id']!),
      ),

      GoRoute(
        path: AppRoutes.event.asRoute(),
        builder: (_, state) => EventDetailsScreen(eventId: state.pathParameters['id']!),
      ),

      GoRoute(path: AppRoutes.createPost, builder: (_, _) => const CreatePostScreen()),
      GoRoute(path: AppRoutes.createEvent, builder: (_, _) => const CreateEventScreen()),
      GoRoute(path: AppRoutes.profile, builder: (_, _) => const ProfileScreen()),
      GoRoute(path: AppRoutes.editProfile, builder: (_, _) => const EditProfileScreen()),
      GoRoute(path: AppRoutes.settings, builder: (_, _) => const SettingsScreen()),
      GoRoute(path: AppRoutes.notifications, builder: (_, _) => const NotificationsScreen()),
    ],
  );
});
