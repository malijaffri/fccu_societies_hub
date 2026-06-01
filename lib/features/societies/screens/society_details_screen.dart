import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:fccu_societies_hub/core/theme/app_colors.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/utils/number_formatter.dart';
import 'package:fccu_societies_hub/core/utils/show_auth_required_sheet.dart';
import 'package:fccu_societies_hub/core/widgets/app_error.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';
import 'package:fccu_societies_hub/core/widgets/empty_state.dart';
import 'package:fccu_societies_hub/features/auth/providers/current_user_provider.dart';
import 'package:fccu_societies_hub/features/events/providers/events_provider.dart';
import 'package:fccu_societies_hub/features/events/widgets/event_card.dart';
import 'package:fccu_societies_hub/features/posts/providers/posts_provider.dart';
import 'package:fccu_societies_hub/features/posts/widgets/post_card.dart';
import 'package:fccu_societies_hub/features/session/providers/session_permissions_provider.dart';
import 'package:fccu_societies_hub/features/societies/providers/societies_provider.dart';

class SocietyDetailsScreen extends ConsumerStatefulWidget {
  final String societyId;

  const SocietyDetailsScreen({super.key, required this.societyId});

  @override
  ConsumerState<SocietyDetailsScreen> createState() => _SocietyDetailsScreenState();
}

class _SocietyDetailsScreenState extends ConsumerState<SocietyDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _toggleFollow() async {
    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null) {
      if (mounted) showAuthRequiredSheet(context);
      return;
    }

    final society = ref.read(societyProvider(widget.societyId)).value;
    if (society == null) return;

    final repo = ref.read(societyRepositoryProvider);
    if (society.isFollowed) {
      await repo.unfollowSociety(widget.societyId, uid);
    } else {
      await repo.followSociety(widget.societyId, uid);
    }
    ref.invalidate(societyProvider(widget.societyId));
    ref.invalidate(societiesProvider);
  }

  Future<void> _toggleMember() async {
    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null) {
      if (mounted) showAuthRequiredSheet(context);
      return;
    }

    final society = ref.read(societyProvider(widget.societyId)).value;
    if (society == null) return;

    final repo = ref.read(societyRepositoryProvider);
    if (society.isMember) {
      await repo.leaveSociety(widget.societyId, uid);
    } else {
      await repo.joinSociety(widget.societyId, uid);
    }
    ref.invalidate(societyProvider(widget.societyId));
    ref.invalidate(societiesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final societyAsync = ref.watch(societyProvider(widget.societyId));
    final postsAsync = ref.watch(societyPostsProvider(widget.societyId));
    final eventsAsync = ref.watch(societyEventsProvider(widget.societyId));
    final canReact = ref.watch(canReactProvider);

    return Scaffold(
      body: societyAsync.when(
        loading: () => const Scaffold(body: AppLoading()),
        error: (error, _) => Scaffold(
          appBar: AppBar(),
          body: AppError(
            error: error,
            onRetry: () => ref.invalidate(societyProvider(widget.societyId)),
          ),
        ),
        data: (society) {
          if (society == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('Society not found')),
            );
          }

          return NestedScrollView(
            headerSliverBuilder: (context, _) => [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(society.name),
                  background: society.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: society.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => const AppLoading(),
                          errorWidget: (_, _, _) => Container(
                            color: AppColors.lightSurface,
                            child: const Icon(Icons.image_not_supported_rounded),
                          ),
                        )
                      : Container(
                          color: AppColors.lightSurface,
                          child: const Icon(Icons.groups_rounded, size: 64),
                        ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s_16,
                    AppSpacing.s_16,
                    AppSpacing.s_16,
                    AppSpacing.s_8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _Stat(
                              label: 'Followers',
                              value: formatNumber(society.followerCount),
                            ),
                          ),
                          Expanded(
                            child: _Stat(
                              label: 'Members',
                              value: formatNumber(society.memberCount),
                            ),
                          ),
                        ],
                      ),

                      if (society.description != null) ...[
                        const SizedBox(height: AppSpacing.s_16),
                        Text('About', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.s_4),
                        Text(society.description!, style: Theme.of(context).textTheme.bodyMedium),
                      ],

                      const SizedBox(height: AppSpacing.s_16),

                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: canReact ? _toggleMember : () => showAuthRequiredSheet(context),
                              child: Text(society.isMember ? 'Leave Society' : 'Join Society'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s_12),
                          OutlinedButton.icon(
                            onPressed: canReact ? _toggleFollow : () => showAuthRequiredSheet(context),
                            icon: Icon(
                              society.isFollowed ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                              size: 18,
                            ),
                            label: Text(society.isFollowed ? 'Following' : 'Follow'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    tabs: const [Tab(text: 'Posts'), Tab(text: 'Events')],
                  ),
                ),
              ),
            ],

            body: TabBarView(
              controller: _tabController,
              children: [
                // Posts tab
                postsAsync.when(
                  loading: () => const AppLoading(),
                  error: (e, _) => AppError(
                    error: e,
                    onRetry: () => ref.invalidate(societyPostsProvider(widget.societyId)),
                  ),
                  data: (posts) => posts.isEmpty
                      ? const EmptyState(
                          icon: Icons.forum_outlined,
                          title: 'No posts yet',
                          subtitle: 'This society hasn\'t posted anything yet.',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(AppSpacing.s_16),
                          itemCount: posts.length,
                          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s_16),
                          itemBuilder: (_, i) => PostCard(post: posts[i]),
                        ),
                ),

                // Events tab
                eventsAsync.when(
                  loading: () => const AppLoading(),
                  error: (e, _) => AppError(
                    error: e,
                    onRetry: () => ref.invalidate(societyEventsProvider(widget.societyId)),
                  ),
                  data: (events) => events.isEmpty
                      ? const EmptyState(
                          icon: Icons.event_outlined,
                          title: 'No events yet',
                          subtitle: 'This society hasn\'t scheduled any events.',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(AppSpacing.s_16),
                          itemCount: events.length,
                          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s_16),
                          itemBuilder: (_, i) => EventCard(event: events[i]),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: Theme.of(context).textTheme.bodySmall),
      Text(value, style: Theme.of(context).textTheme.titleMedium),
    ],
  );
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => tabBar != oldDelegate.tabBar;
}
