import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fccu_societies_hub/core/router/app_router.dart';

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,

      floatingActionButton: switch (currentIndex) {
        0 => FloatingActionButton.extended(
          onPressed: () => context.push(AppRoutes.createPost),
          icon: const Icon(Icons.edit_rounded),
          label: const Text('Post'),
        ),

        2 => FloatingActionButton.extended(
          onPressed: () => context.push(AppRoutes.createEvent),
          icon: const Icon(Icons.event_rounded),
          label: const Text('Event'),
        ),

        _ => null,
      },

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

        onDestinationSelected: (index) => navigationShell.goBranch(index, initialLocation: index == currentIndex),

        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Feed'),

          NavigationDestination(icon: Icon(Icons.search_rounded), label: 'Search'),

          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event_rounded),
            label: 'Events',
          ),
        ],
      ),
    );
  }
}
