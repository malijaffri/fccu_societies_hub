import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'package:fccu_societies_hub/core/router/go_router_refresh_stream.dart';
import 'package:fccu_societies_hub/core/widgets/app_scaffold.dart';
import 'package:fccu_societies_hub/features/auth/screens/login_screen.dart';
import 'package:fccu_societies_hub/features/auth/screens/register_screen.dart';
import 'package:fccu_societies_hub/features/auth/screens/welcome_screen.dart';
import 'package:fccu_societies_hub/features/create_event/screens/create_event_screen.dart';
import 'package:fccu_societies_hub/features/create_post/screens/create_post_screen.dart';
import 'package:fccu_societies_hub/features/events/screens/events_screen.dart';
import 'package:fccu_societies_hub/features/feed/screens/feed_screen.dart';
import 'package:fccu_societies_hub/features/posts/screens/post_details_screen.dart';
import 'package:fccu_societies_hub/features/profile/screens/profile_screen.dart';
import 'package:fccu_societies_hub/features/profile/screens/settings_screen.dart';
import 'package:fccu_societies_hub/features/search/screens/search_screen.dart';

class AppRoute {
  final String routeBase;
  final List<String> expectedParams;

  const AppRoute(this.routeBase, [this.expectedParams = const []]);

  String resolve([Map<String, String> params = const {}]) {
    if (params.keys.toSet() != expectedParams.toSet()) {
      throw ArgumentError('Passed parameters don\'t match required set');
    }

    if (expectedParams.isEmpty) {
      return routeBase;
    }

    final joinedParams = expectedParams.map((p) => params[p]!).join('/');

    return '$routeBase/$joinedParams';
  }

  String asRoute() {
    if (expectedParams.isEmpty) {
      return routeBase;
    }

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
  static const createPost = '/create-post';
  static const createEvent = '/create-event';
  static const profile = '/profile';
  static const settings = '/settings';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.homeFeed,

  refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),

  redirect: (context, state) {
    final loggedIn = FirebaseAuth.instance.currentUser != null;

    final isAuthRoute = const [AppRoutes.welcome, AppRoutes.login, AppRoutes.register].contains(state.matchedLocation);

    if (!loggedIn && !isAuthRoute) {
      return AppRoutes.welcome;
    }

    if (loggedIn && isAuthRoute) {
      return AppRoutes.homeFeed;
    }

    return null;
  },

  routes: [
    GoRoute(path: AppRoutes.welcome, builder: (context, state) => const WelcomeScreen()),

    GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),

    GoRoute(path: AppRoutes.register, builder: (context, state) => const RegisterScreen()),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppScaffold(navigationShell: navigationShell),

      branches: [
        .new(
          routes: [GoRoute(path: AppRoutes.homeFeed, builder: (context, state) => const FeedScreen())],
        ),

        .new(
          routes: [GoRoute(path: AppRoutes.search, builder: (context, state) => const SearchScreen())],
        ),

        .new(
          routes: [GoRoute(path: AppRoutes.events, builder: (context, state) => const EventsScreen())],
        ),
      ],
    ),

    GoRoute(
      path: AppRoutes.post.asRoute(),
      builder: (context, state) => PostDetailsScreen(postId: state.pathParameters['id']!),
    ),

    GoRoute(path: AppRoutes.createPost, builder: (context, state) => const CreatePostScreen()),

    GoRoute(path: AppRoutes.createEvent, builder: (context, state) => const CreateEventScreen()),

    GoRoute(path: AppRoutes.profile, builder: (context, state) => const ProfileScreen()),

    GoRoute(path: AppRoutes.settings, builder: (context, state) => const SettingsScreen()),
  ],
);
