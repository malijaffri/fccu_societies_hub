import 'package:flutter/material.dart';

import 'main_tabs/events_list_content.dart';
import 'main_tabs/new_post_form.dart';
import 'main_tabs/posts_list_content.dart';
import 'main_tabs/search_form.dart';
import 'welcome_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _TabData {
  const _TabData(this.name, this.widget, this.tab);

  final String name;
  final Widget widget;
  final Widget tab;
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  static const List<_TabData> _screens = [
    _TabData(
      'Posts',
      PostsListContent(),
      NavigationDestination(
        selectedIcon: Icon(Icons.chat_bubble),
        icon: Icon(Icons.chat_bubble_outline),
        label: 'Posts',
      ),
    ),
    _TabData(
      'Events',
      EventsListContent(),
      NavigationDestination(
        selectedIcon: Icon(Icons.access_time_filled),
        icon: Icon(Icons.access_time),
        label: 'Events',
      ),
    ),
    _TabData(
      'New',
      NewPostForm(),
      NavigationDestination(selectedIcon: Icon(Icons.add_circle), icon: Icon(Icons.add_circle_outline), label: 'New'),
    ),
    _TabData('Search', SearchForm(), NavigationDestination(icon: Icon(Icons.search), label: 'Search')),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_screens[_currentIndex].name),
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
