import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/widgets/app_error.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';
import 'package:fccu_societies_hub/core/widgets/empty_state.dart';
import 'package:fccu_societies_hub/features/events/widgets/events_list.dart';
import 'package:fccu_societies_hub/features/posts/widgets/posts_list.dart';
import 'package:fccu_societies_hub/features/search/widgets/global_search_bar.dart';
import 'package:fccu_societies_hub/features/societies/providers/societies_provider.dart';
import 'package:fccu_societies_hub/features/societies/widgets/societies_list.dart';
import 'package:fccu_societies_hub/features/societies/widgets/society_list_section.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
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
    final societiesAsync = ref.watch(societiesProvider);

    final lowerQuery = _query.toLowerCase();

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
                userFilter: (post) =>
                    post.content.toLowerCase().contains(lowerQuery) ||
                    post.societyName.toLowerCase().contains(lowerQuery),
                failMsg: 'Your search did not match any results',
              )
            else
              const EmptyState(icon: Icons.forum_outlined, title: 'Posts', subtitle: 'Begin typing to see results'),

            if (_isSearching)
              EventsList(
                userFilter: (event) =>
                    event.title.toLowerCase().contains(lowerQuery) ||
                    event.description.toLowerCase().contains(lowerQuery) ||
                    event.societyName.toLowerCase().contains(lowerQuery) ||
                    (event.location?.toLowerCase().contains(lowerQuery) ?? false),
                failMsg: 'Your search did not match any results',
              )
            else
              const EmptyState(
                icon: Icons.calendar_month_outlined,
                title: 'Events',
                subtitle: 'Begin typing to see results',
              ),

            societiesAsync.when(
              data: (societies) {
                if (_isSearching) {
                  return SocietiesList(
                    userFilter: (society) =>
                        society.name.toLowerCase().contains(lowerQuery) ||
                        (society.description?.toLowerCase().contains(lowerQuery) ?? false),
                    failMsg: 'Your search did not match any results',
                  );
                }

                // TODO: memberSocietiesProvider
                final mySocieties = societies.where((society) => society.isMember).toList();

                final followedSocieties = societies.where((society) => society.isFollowed).toList();

                return ListView(
                  padding: const .only(top: AppSpacing.s_16, bottom: AppSpacing.s_24),

                  children: [
                    SocietyListSection(title: 'My Societies', societies: mySocieties),

                    SocietyListSection(title: 'Followed', societies: followedSocieties),

                    SocietyListSection(title: 'All Societies', societies: societies),
                  ],
                );
              },

              loading: () => const AppLoading(),

              error: (error, _) => AppError(error: error, onRetry: () => ref.invalidate(societiesProvider)),
            ),
          ],
        ),
      ),
    );
  }
}
