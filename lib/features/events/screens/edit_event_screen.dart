import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/widgets/app_error.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';
import 'package:fccu_societies_hub/features/create_event/widgets/event_datetime_section.dart';
import 'package:fccu_societies_hub/features/create_event/widgets/event_location_field.dart';
import 'package:fccu_societies_hub/features/events/providers/events_provider.dart';
import 'package:fccu_societies_hub/models/event.dart';

class EditEventScreen extends ConsumerStatefulWidget {
  final String eventId;
  const EditEventScreen({super.key, required this.eventId});

  @override
  ConsumerState<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends ConsumerState<EditEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime? _startsAt;
  DateTime? _endsAt;

  bool _isSubmitting = false;
  bool _initialised = false;
  Event? _original;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _seed(Event event) {
    if (_initialised) return;
    _titleController.text = event.title;
    _descriptionController.text = event.description;
    _locationController.text = event.location ?? '';
    _startsAt = event.start;
    _endsAt = event.end;
    _original = event;
    _initialised = true;
  }

  Future<DateTime?> _pickDateTime({required DateTime? initial}) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: DateTime(now.year + 5),
    );
    if (pickedDate == null || !mounted) return null;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initial != null ? TimeOfDay.fromDateTime(initial) : TimeOfDay.now(),
    );
    if (pickedTime == null) return null;
    return DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title cannot be empty.')));
      return;
    }
    if (_startsAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please set a start time.')));
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final updated = _original!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
        start: _startsAt,
        end: _endsAt,
      );
      await ref.read(eventRepositoryProvider).updateEvent(updated);
      ref.invalidate(eventProvider(widget.eventId));
      ref.invalidate(eventsProvider);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventProvider(widget.eventId));

    return eventAsync.when(
      loading: () => const Scaffold(body: AppLoading()),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Edit Event')),
        body: AppError(error: e, onRetry: () => ref.invalidate(eventProvider(widget.eventId))),
      ),
      data: (event) {
        if (event == null) return Scaffold(appBar: AppBar(), body: const Center(child: Text('Event not found')));
        _seed(event);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Event'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.s_8),
                child: TextButton(
                  onPressed: _isSubmitting ? null : _save,
                  child: _isSubmitting
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Save'),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s_16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Event Title'),
                ),
                const SizedBox(height: AppSpacing.s_16),
                TextField(
                  controller: _descriptionController,
                  minLines: 4,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(labelText: 'Description', alignLabelWithHint: true),
                ),
                const SizedBox(height: AppSpacing.s_20),
                EventDateTimeSection(
                  startsAt: _startsAt,
                  endsAt: _endsAt,
                  onPickStart: () async {
                    final v = await _pickDateTime(initial: _startsAt);
                    if (v != null) setState(() { _startsAt = v; if (_endsAt != null && _endsAt!.isBefore(v)) _endsAt = v.add(const Duration(hours: 2)); });
                  },
                  onPickEnd: () async {
                    final v = await _pickDateTime(initial: _endsAt ?? _startsAt?.add(const Duration(hours: 2)));
                    if (v != null) setState(() => _endsAt = v);
                  },
                ),
                const SizedBox(height: AppSpacing.s_20),
                EventLocationField(controller: _locationController),
                const SizedBox(height: AppSpacing.s_24),
              ],
            ),
          ),
        );
      },
    );
  }
}
