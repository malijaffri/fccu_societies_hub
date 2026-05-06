import 'package:flutter/material.dart';

class NewPostForm extends StatefulWidget {
  const NewPostForm({super.key});

  @override
  State<NewPostForm> createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  final _formKey = GlobalKey<FormState>();

  bool addEvent = false;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: .all(32),
    child: Form(
      key: _formKey,
      child: Column(
        spacing: 16,
        children: [
          TextFormField(
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              labelText: 'Body',
              hintText: 'What\'s on your mind?',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            validator: (value) => value!.trim().isEmpty ? 'Body is required' : null,
          ),
          Row(
            children: [
              Checkbox(value: addEvent, onChanged: (bool? val) => setState(() => addEvent = val!)),
              const Text('Add Event'),
            ],
          ),
          if (addEvent) ...{
            TextFormField(
              decoration: const InputDecoration(labelText: 'Event Title', border: OutlineInputBorder()),
              validator: (value) => value!.trim().isEmpty ? 'Title is required' : null,
            ),
          },
          FilledButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Created Post${addEvent ? ' and Event' : ''}!')));
                _formKey.currentState!.reset();
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    ),
  );
}
