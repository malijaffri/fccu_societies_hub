import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/settings/providers/app_settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s_8),
        children: [
          // ── Appearance ──────────────────────────────────────────────
          _SectionHeader('Appearance'),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s_16, vertical: AppSpacing.s_8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Theme', style: theme.textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.s_8),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('System'),
                      icon: Icon(Icons.brightness_auto_rounded),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode_rounded),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode_rounded),
                    ),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (set) => notifier.setThemeMode(set.first),
                ),
              ],
            ),
          ),

          const Divider(),

          // ── Notifications ────────────────────────────────────────────
          _SectionHeader('Notifications'),

          SwitchListTile(
            title: const Text('Likes on my posts'),
            subtitle: const Text('Get notified when someone likes your post'),
            value: settings.notifyOnLike,
            onChanged: notifier.setNotifyOnLike,
          ),
          SwitchListTile(
            title: const Text('Comments on my posts'),
            subtitle: const Text('Get notified when someone comments on your post'),
            value: settings.notifyOnComment,
            onChanged: notifier.setNotifyOnComment,
          ),

          const Divider(),

          // ── About ─────────────────────────────────────────────────────
          _SectionHeader('About'),

          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('Version'),
            trailing: Text('1.0.0', style: TextStyle(color: colorScheme.onSurfaceVariant)),
          ),
          ListTile(
            leading: const Icon(Icons.school_rounded),
            title: const Text('FCCU Societies Hub'),
            subtitle: Text(
              'CSCS-468-A Mobile App Development · SP2026',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(AppSpacing.s_16, AppSpacing.s_12, AppSpacing.s_16, AppSpacing.s_4),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
