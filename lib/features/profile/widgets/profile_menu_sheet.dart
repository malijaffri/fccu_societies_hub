import 'package:flutter/material.dart';

class ProfileMenuSheet extends StatelessWidget {
  const ProfileMenuSheet({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Column(
      mainAxisSize: .min,

      children: [
        ListTile(
          leading: const Icon(Icons.person_outline_rounded),
          title: const Text('Profile'),

          onTap: () => Navigator.pop(context),
        ),

        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Settings'),

          onTap: () => Navigator.pop(context),
        ),

        ListTile(
          leading: Icon(Icons.logout_rounded, color: Theme.of(context).colorScheme.error),

          title: Text('Logout', style: .new(color: Theme.of(context).colorScheme.error)),

          onTap: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

void showProfileMenu(BuildContext context) =>
    showModalBottomSheet(context: context, showDragHandle: true, builder: (context) => ProfileMenuSheet());
