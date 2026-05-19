import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fccu_societies_hub/core/router/app_router.dart';
import 'package:fccu_societies_hub/features/auth/providers/auth_repository_provider.dart';

class ProfileMenuSheet extends ConsumerWidget {
  const ProfileMenuSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        mainAxisSize: .min,

        children: [
          ListTile(
            leading: const Icon(Icons.person_outline_rounded),

            title: const Text('Profile'),

            onTap: () {
              Navigator.pop(context);

              context.push(AppRoutes.profile);
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),

            onTap: () {
              Navigator.pop(context);

              context.push(AppRoutes.settings);
            },
          ),

          ListTile(
            leading: Icon(Icons.logout_rounded, color: colorScheme.error),

            title: Text('Logout', style: .new(color: colorScheme.error)),

            onTap: () async {
              Navigator.pop(context);

              await ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
    );
  }
}

void showProfileMenu(BuildContext context) =>
    showModalBottomSheet(context: context, showDragHandle: true, builder: (context) => const ProfileMenuSheet());
