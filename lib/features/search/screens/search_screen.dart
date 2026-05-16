import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/widgets/empty_state.dart';
import 'package:fccu_societies_hub/features/events/widgets/event_card.dart';
import 'package:fccu_societies_hub/features/post/widgets/posts_list.dart';
import 'package:fccu_societies_hub/features/search/widgets/global_search_bar.dart';
import 'package:fccu_societies_hub/features/societies/widgets/society_card.dart';
import 'package:fccu_societies_hub/features/societies/widgets/society_list_section.dart';
import 'package:fccu_societies_hub/mock/mock_events.dart';
import 'package:fccu_societies_hub/mock/mock_societies.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  String _query = '';

  @override
  void initState() {
    super.initState();

    _controller.addListener(() => setState(() => _query = _controller.text.trim()));
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  bool get _isSearching => _query.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final lowerQuery = _query.toLowerCase();

    final filteredEvents = mockEvents
        .where(
          (event) =>
              event.title.toLowerCase().contains(lowerQuery) ||
              event.description.toLowerCase().contains(lowerQuery) ||
              event.societyName.toLowerCase().contains(lowerQuery),
        )
        .toList();

    final filteredSocieties = mockSocieties
        .where(
          (society) =>
              society.name.toLowerCase().contains(lowerQuery) ||
              (society.description?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .toList();

    final mySocieties = mockSocieties.where((society) => society.isMember).toList();

    final followedSocieties = mockSocieties.where((society) => society.isFollowed).toList();

    return DefaultTabController(
      length: 3,

      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,

          title: Padding(
            padding: const .all(AppSpacing.s_16),

            child: GlobalSearchBar(controller: _controller),
          ),

          bottom: const TabBar(
            tabs: [
              Tab(text: 'Posts'),
              Tab(text: 'Events'),
              Tab(text: 'Societies'),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            if (_isSearching)
              PostsList(
                filter: (post) =>
                    post.content.toLowerCase().contains(lowerQuery) ||
                    post.societyName.toLowerCase().contains(lowerQuery),
                filterFailMsg: 'Your search did not match any results',
              )
            else
              const EmptyState(icon: Icons.forum_outlined, title: 'Posts', subtitle: 'Begin typing to see results'),

            if (_isSearching)
              ListView.separated(
                padding: const .all(AppSpacing.s_16),

                itemCount: filteredEvents.length,

                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s_12),

                itemBuilder: (context, index) => EventCard(event: filteredEvents[index]),
              )
            else
              const EmptyState(
                icon: Icons.calendar_month_outlined,
                title: 'Events',
                subtitle: 'Begin typing to see results',
              ),

            if (_isSearching)
              ListView.separated(
                padding: const .all(AppSpacing.s_16),

                itemCount: filteredSocieties.length,

                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s_12),

                itemBuilder: (context, index) => SocietyCard(society: filteredSocieties[index]),
              )
            else
              ListView(
                padding: const .only(top: AppSpacing.s_16, bottom: AppSpacing.s_24),

                children: [
                  SocietyListSection(title: 'My Societies', societies: mySocieties),

                  SocietyListSection(title: 'Followed', societies: followedSocieties),

                  SocietyListSection(title: 'All Societies', societies: mockSocieties),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
