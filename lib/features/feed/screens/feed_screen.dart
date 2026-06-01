import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fccu_societies_hub/core/router/app_router.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/notifications/providers/notifications_provider.dart';
import 'package:fccu_societies_hub/features/posts/providers/posts_provider.dart';
import 'package:fccu_societies_hub/features/posts/widgets/posts_list.dart';
import 'package:fccu_societies_hub/features/profile/widgets/profile_menu_sheet.dart';
import 'package:fccu_societies_hub/models/post.dart';
import 'package:fccu_societies_hub/widgets/avatar.dart';

enum _SortMode { recent, popular }

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  _SortMode _sortMode = _SortMode.recent;

  List<Post> _sorted(List<Post> posts) {
    if (_sortMode == _SortMode.popular) {
      final copy = List<Post>.from(posts);
      copy.sort((a, b) => (b.likeCount + b.commentCount).compareTo(a.likeCount + a.commentCount));
      return copy;
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    final unreadAsync = ref.watch(unreadCountProvider);
    final unreadCount = unreadAsync.value ?? 0;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Feed'),

          actions: [
            // Notification bell
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => context.push(AppRoutes.notifications),
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        unreadCount > 99 ? '99+' : '$unreadCount',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.s_12),
              child: GestureDetector(
                onTap: () => showProfileMenu(context),
                child: const Avatar(),
              ),
            ),
          ],

          bottom: const TabBar(
            tabs: [Tab(text: 'Following'), Tab(text: 'Discover')],
          ),
        ),

        // Sort button only visible on Discover tab
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        body: TabBarView(
          children: [
            // Following tab
            PostsList(
              postsProviderActual: feedProvider,
              failMsg: 'Follow societies to see their posts',
            ),

            // Discover tab with sort toggle
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s_16,
                    vertical: AppSpacing.s_8,
                  ),
                  child: Row(
                    children: [
                      Text('Sort by:', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(width: AppSpacing.s_8),
                      ChoiceChip(
                        label: const Text('Recent'),
                        selected: _sortMode == _SortMode.recent,
                        onSelected: (_) => setState(() => _sortMode = _SortMode.recent),
                      ),
                      const SizedBox(width: AppSpacing.s_8),
                      ChoiceChip(
                        label: const Text('Popular'),
                        selected: _sortMode == _SortMode.popular,
                        onSelected: (_) => setState(() => _sortMode = _SortMode.popular),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PostsList(
                    transform: _sortMode == _SortMode.popular ? _sorted : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
