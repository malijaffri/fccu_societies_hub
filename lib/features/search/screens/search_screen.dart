import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,

    child: Scaffold(
      appBar: AppBar(
        title: const Text('Search'),

        bottom: const TabBar(
          tabs: [
            Tab(text: 'Posts'),
            Tab(text: 'Events'),
            Tab(text: 'Societies'),
          ],
        ),
      ),

      body: const TabBarView(
        children: [
          Center(child: Text('Search Posts')),
          Center(child: Text('Search Events')),
          Center(child: Text('Search Societies')),
        ],
      ),
    ),
  );
}
