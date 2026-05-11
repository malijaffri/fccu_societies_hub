import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/profile/widgets/profile_menu_sheet.dart';

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
            child: GestureDetector(
              onTap: () => showProfileMenu(context),

              child: const CircleAvatar(radius: 18, child: Icon(Icons.person_rounded)),
            ),
          ),
        ],

        bottom: const TabBar(
          tabs: [
            Tab(text: 'Followed'),
            Tab(text: 'Discover'),
          ],
        ),
      ),

      body: const TabBarView(
        children: [
          Center(child: Text('Followed Feed')),

          Center(child: Text('Discover Feed')),
        ],
      ),
    ),
  );
}
