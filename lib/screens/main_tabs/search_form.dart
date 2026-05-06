import 'package:flutter/material.dart';

import '../../widgets/post_card.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();

  String? query;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: .all(32),
    child: Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            children: [
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        labelText: 'Search',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.trim().isEmpty ? 'Search query is required' : null,
                      onSaved: (newValue) {
                        query = newValue!.trim();
                        if (query!.isEmpty) query = null;
                      },
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) _formKey.currentState!.save();
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (true)
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 3, // TODO: Mock data count
            itemBuilder: (context, index) => PostCard(
              posterName: 'Society Name',
              postedAt: DateTime.now(),
              content: 'Post Description\nWith multiple lines\nAnd potentially rich text.',
              imageUrls: [],
              favorites: 1_000_000,
              comments: 92,
              bookmarks: 1_400,
            ),
          ),
      ],
    ),
  );
}
