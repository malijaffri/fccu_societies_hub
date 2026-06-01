import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:fccu_societies_hub/core/theme/app_colors.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';
import 'package:fccu_societies_hub/features/societies/providers/societies_provider.dart';
import 'package:fccu_societies_hub/core/utils/number_formatter.dart';

class SocietyDetailsScreen extends ConsumerWidget {
  final String societyId;

  const SocietyDetailsScreen({super.key, required this.societyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final societyAsync = ref.watch(societyProvider(societyId));

    return Scaffold(
      body: societyAsync.when(
        data: (society) {
          if (society == null) {
            return const Center(child: Text('Society not found'));
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(society.name),
                  background: society.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: society.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const AppLoading(),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.lightSurface,
                            child: const Icon(Icons.image_not_supported_rounded),
                          ),
                        )
                      : Container(color: AppColors.lightSurface, child: const Icon(Icons.groups_rounded)),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.s_16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Followers', style: Theme.of(context).textTheme.bodySmall),
                                  Text(
                                    formatNumber(society.followerCount),
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Members', style: Theme.of(context).textTheme.bodySmall),
                                  Text(
                                    formatNumber(society.memberCount),
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s_24),
                        if (society.description != null) ...[
                          Text('About', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: AppSpacing.s_8),
                          Text(society.description!, style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: AppSpacing.s_24),
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: society.isMember
                                ? null
                                : () => ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(const SnackBar(content: Text('Join society feature coming soon'))),
                            child: Text(society.isMember ? 'Member' : 'Join Society'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          );
        },
        loading: () => const Scaffold(body: AppLoading()),
        error: (error, _) => Scaffold(body: Center(child: Text('Error: $error'))),
      ),
    );
  }
}
