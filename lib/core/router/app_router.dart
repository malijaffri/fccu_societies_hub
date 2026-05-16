import 'package:go_router/go_router.dart';

import 'package:fccu_societies_hub/core/widgets/app_scaffold.dart';
import 'package:fccu_societies_hub/features/create_event/screens/create_event_screen.dart';
import 'package:fccu_societies_hub/features/create_post/screens/create_post_screen.dart';
import 'package:fccu_societies_hub/features/events/screens/events_screen.dart';
import 'package:fccu_societies_hub/features/feed/screens/feed_screen.dart';
import 'package:fccu_societies_hub/features/posts/screens/post_details_screen.dart';
import 'package:fccu_societies_hub/features/search/screens/search_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppScaffold(navigationShell: navigationShell),

      branches: [
        .new(
          routes: [GoRoute(path: '/', builder: (context, state) => const FeedScreen())],
        ),

        .new(
          routes: [GoRoute(path: '/search', builder: (context, state) => const SearchScreen())],
        ),

        .new(
          routes: [GoRoute(path: '/events', builder: (context, state) => const EventsScreen())],
        ),
      ],
    ),

    GoRoute(
      path: '/post/:id',
      builder: (context, state) => PostDetailsScreen(postId: state.pathParameters['id']!),
    ),

    GoRoute(path: '/create-post', builder: (context, state) => const CreatePostScreen()),

    GoRoute(path: '/create-event', builder: (context, state) => const CreateEventScreen()),
  ],
);
