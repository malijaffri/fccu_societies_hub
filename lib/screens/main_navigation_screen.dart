import 'package:flutter/material.dart';

import 'posts_list_content.dart';
import 'welcome_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _TabData {
  const _TabData(this.widget, this.tab);

  final Widget widget;
  final Widget tab;
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  static const List<_TabData> _screens = [
    _TabData(
      PostsListContent(),
      NavigationDestination(
        selectedIcon: Icon(Icons.chat_bubble),
        icon: Icon(Icons.chat_bubble_outline),
        label: 'Posts',
      ),
    ),
    _TabData(
      Center(child: Text('Events Screen Placeholder')),
      NavigationDestination(
        selectedIcon: Icon(Icons.access_time_filled),
        icon: Icon(Icons.access_time),
        label: 'Events',
      ),
    ),
    _TabData(
      Center(child: Text('Create Post/Event Placeholder')),
      NavigationDestination(selectedIcon: Icon(Icons.add_circle), icon: Icon(Icons.add_circle_outline), label: 'New'),
    ),
    _TabData(
      Center(child: Text('Search Screen Placeholder')),
      NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Posts'),
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          icon: const CircleAvatar(child: Icon(Icons.person)),
          onSelected: (value) {
            if (value == 'logout') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (_) => false,
              );
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'profile', child: Text('Profile')),
            PopupMenuItem(value: 'settings', child: Text('Settings')),
            PopupMenuItem(value: 'logout', child: Text('Logout')),
          ],
        ),
      ],
    ),
    body: _screens[_currentIndex].widget,
    bottomNavigationBar: NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) => setState(() => _currentIndex = index),
      destinations: _screens.map((data) => data.tab).toList(growable: false),
    ),
  );
}
