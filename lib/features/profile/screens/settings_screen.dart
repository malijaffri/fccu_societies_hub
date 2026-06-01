import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Manage notification preferences'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Notifications settings coming soon'))),
          ),
          ListTile(
            title: const Text('Privacy'),
            subtitle: const Text('Control privacy settings'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Privacy settings coming soon'))),
          ),
          ListTile(
            title: const Text('About'),
            subtitle: const Text('App version and information'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Version 1.0.0'))),
          ),
          ListTile(
            title: const Text('Help & Support'),
            subtitle: const Text('Get help and report issues'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () =>
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Help & Support coming soon'))),
          ),
        ],
      ),
    );
  }
}
