import 'package:flutter/material.dart';

class EventLocationField extends StatelessWidget {
  final TextEditingController controller;

  const EventLocationField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,

      textCapitalization: .words,

      decoration: const .new(
        labelText: 'Location',
        hintText: 'Auditorium Hall A',
        prefixIcon: Icon(Icons.location_on_outlined),
      ),
    );
  }
}
