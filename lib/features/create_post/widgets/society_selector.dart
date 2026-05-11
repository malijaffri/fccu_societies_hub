import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/models/society.dart';

class SocietySelector extends StatelessWidget {
  final List<Society> societies;

  final String? value;

  final ValueChanged<String?> onChanged;

  const SocietySelector({super.key, required this.societies, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
    initialValue: value,

    decoration: const .new(labelText: 'Post as', prefixIcon: Icon(Icons.groups_rounded)),

    items: societies.map((society) => DropdownMenuItem(value: society.id, child: Text(society.name))).toList(),

    onChanged: onChanged,
  );
}
