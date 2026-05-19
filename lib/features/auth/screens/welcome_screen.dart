import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fccu_societies_hub/core/router/app_router.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/session/providers/session_repository_provider.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const .all(AppSpacing.s_24),

            child: ConstrainedBox(
              constraints: const .new(maxWidth: 420),

              child: Column(
                crossAxisAlignment: .stretch,

                children: [
                  Container(
                    width: 96,
                    height: 96,

                    decoration: BoxDecoration(color: colorScheme.primaryContainer, shape: .circle),

                    child: Icon(Icons.groups_rounded, size: 48, color: colorScheme.onPrimaryContainer),
                  ),

                  const SizedBox(height: AppSpacing.s_32),

                  Text(
                    'FCCU Societies Hub',

                    textAlign: .center,

                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: .w700),
                  ),

                  const SizedBox(height: AppSpacing.s_12),

                  Text(
                    'Discover societies, stay updated with events, and connect with your campus community.',

                    textAlign: .center,

                    style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.45),
                  ),

                  const SizedBox(height: AppSpacing.s_40),

                  FilledButton(
                    onPressed: () => context.push(AppRoutes.register),

                    child: const Padding(
                      padding: .symmetric(vertical: AppSpacing.s_14),

                      child: Text('Create Account'),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.s_12),

                  OutlinedButton(
                    onPressed: () => context.push(AppRoutes.login),

                    child: const Padding(
                      padding: .symmetric(vertical: AppSpacing.s_14),

                      child: Text('Login'),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.s_24),

                  TextButton(
                    onPressed: () async {
                      await ref.read(sessionRepositoryProvider).setGuestMode();

                      if (!context.mounted) {
                        return;
                      }

                      context.go(AppRoutes.homeFeed);
                    },
                    child: const Text('Continue as Guest'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
