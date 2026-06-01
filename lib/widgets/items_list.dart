import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/widgets/app_error.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';
import 'package:fccu_societies_hub/core/widgets/empty_state.dart';

abstract class ItemsList<T> extends ConsumerWidget {
  static const noItemsYet = 'No items yet';
  static const noItemsFound = 'No items found';
  static const noItemsLong = 'Items will appear here.';

  final bool Function(T)? filter;
  final bool Function(T)? userFilter;
  final List<T> Function(List<T>)? transform;
  final String? failMsg;

  const ItemsList({super.key, this.filter, this.userFilter, this.transform, this.failMsg});

  FutureProvider<List<T>> get itemsProvider;

  IconData get icon;

  Widget itemCard(T item);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(itemsProvider);

          await ref.read(itemsProvider.future);
        },

        child: itemsAsync.when(
          data: (items) {
            final filtered = filter != null ? items.where(filter!).toList() : items;
            final userFiltered = userFilter != null ? filtered.where(userFilter!).toList() : filtered;
            final displayed = transform != null ? transform!(userFiltered) : userFiltered;

            if (displayed.isEmpty) {
              return EmptyState(
                icon: icon,
                title: userFilter == null && transform == null ? noItemsYet : noItemsFound,
                subtitle: failMsg ?? noItemsLong,
              );
            }

            return ListView.separated(
              padding: const .all(AppSpacing.s_16),
              itemCount: displayed.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s_16),
              itemBuilder: (context, index) => itemCard(displayed[index]),
            );
          },

          loading: () => const AppLoading(),

          error: (error, _) => AppError(error: error, onRetry: () => ref.invalidate(itemsProvider)),
        ),
      ),
    );
  }
}
