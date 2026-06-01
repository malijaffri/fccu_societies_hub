import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fccu_societies_hub/core/router/app_router.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/session/providers/session_mode_provider.dart';
import 'package:fccu_societies_hub/features/session/providers/session_repository_provider.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _isGuestLoading = false;

  Future<void> _continueAsGuest() async {
    setState(() => _isGuestLoading = true);

    try {
      await ref.read(sessionRepositoryProvider).setGuestMode();

      // Invalidate the session provider so it re-reads SharedPreferences.
      // RouterNotifier listens to sessionModeProvider and will call
      // notifyListeners(), causing GoRouter to re-evaluate the redirect.
      // The redirect sends guests from /welcome → / automatically.
      ref.invalidate(sessionModeProvider);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _isGuestLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s_24),

            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  Center(
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.groups_rounded, size: 48, color: colorScheme.onPrimaryContainer),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.s_32),

                  Text(
                    'FCCU Societies Hub',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: AppSpacing.s_12),

                  Text(
                    'Discover societies, stay updated with events, and connect with your campus community.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.s_40),

                  FilledButton(
                    onPressed: () => context.push(AppRoutes.register),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.s_14),
                      child: Text('Create Account'),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.s_12),

                  OutlinedButton(
                    onPressed: () => context.push(AppRoutes.login),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.s_14),
                      child: Text('Login'),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.s_24),

                  TextButton(
                    onPressed: _isGuestLoading ? null : _continueAsGuest,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s_12),
                      child: _isGuestLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Continue as Guest'),
                    ),
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
