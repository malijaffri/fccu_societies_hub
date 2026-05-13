import 'package:flutter/material.dart';

class GlobalSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const GlobalSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,

      hintText: 'Search posts, events, societies...',

      leading: const Icon(Icons.search_rounded),

      trailing: controller.text.isNotEmpty
          ? [IconButton(onPressed: controller.clear, icon: const Icon(Icons.close_rounded))]
          : null,
    );
  }
}
