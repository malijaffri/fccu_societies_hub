import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/post/widgets/posts_list.dart';
import 'package:fccu_societies_hub/features/profile/widgets/profile_menu_sheet.dart';
import 'package:fccu_societies_hub/mock/mock_posts.dart';
import 'package:fccu_societies_hub/widgets/avatar.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,

    child: Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.s_12),
            child: GestureDetector(onTap: () => showProfileMenu(context), child: const Avatar()),
          ),
        ],

        bottom: const TabBar(
          tabs: [
            Tab(text: 'Followed'),
            Tab(text: 'Discover'),
          ],
        ),
      ),

      body: TabBarView(
        children: [
          PostsList(posts: mockPosts(count: 10)),

          PostsList(posts: mockPosts(count: 20)),
        ],
      ),
    ),
  );
}
