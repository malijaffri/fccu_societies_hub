import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/widgets/app_error.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';
import 'package:fccu_societies_hub/features/create_event/widgets/event_datetime_section.dart';
import 'package:fccu_societies_hub/features/create_event/widgets/event_location_field.dart';
import 'package:fccu_societies_hub/features/create_event/widgets/linked_post_toggle.dart';
import 'package:fccu_societies_hub/features/create_post/widgets/post_composer_field.dart';
import 'package:fccu_societies_hub/features/create_post/widgets/society_selector.dart';
import 'package:fccu_societies_hub/features/societies/providers/societies_provider.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _titleController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _locationController = TextEditingController();

  final _linkedPostController = TextEditingController();

  String? _selectedSocietyId;

  DateTime? _startsAt;
  DateTime? _endsAt;

  bool _alsoCreatePost = true;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _linkedPostController.dispose();

    super.dispose();
  }

  Future<DateTime?> _pickDateTime({required DateTime? initial}) async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,

      initialDate: initial ?? now,

      firstDate: now.subtract(const Duration(days: 30)),

      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate == null || !mounted) {
      return null;
    }

    final pickedTime = await showTimePicker(
      context: context,

      initialTime: initial != null ? TimeOfDay.fromDateTime(initial) : TimeOfDay.now(),
    );

    if (pickedTime == null) {
      return null;
    }

    return DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
  }

  Future<void> _pickStartDateTime() async {
    final picked = await _pickDateTime(initial: _startsAt);

    if (picked == null) {
      return;
    }

    setState(() {
      _startsAt = picked;

      if (_endsAt != null && _endsAt!.isBefore(picked)) {
        _endsAt = picked.add(const Duration(hours: 2));
      }
    });
  }

  Future<void> _pickEndDateTime() async {
    final initial = _endsAt ?? _startsAt?.add(const Duration(hours: 2));
    final picked = await _pickDateTime(initial: initial);

    if (picked == null) {
      return;
    }

    setState(() => _endsAt = picked);
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_selectedSocietyId == null) {
      _showError('Please select a society.');

      return;
    }

    if (_titleController.text.trim().isEmpty) {
      _showError('Please enter an event title.');

      return;
    }

    if (_startsAt == null || _endsAt == null) {
      _showError('Please select start and end times.');

      return;
    }

    if (_startsAt!.isAfter(_endsAt!)) {
      _showError('Event cannot end before it starts.');

      return;
    }

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) {
      return;
    }

    Navigator.pop(context);
  }

  void _showError(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final societiesAsync = ref.watch(societiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.s_8),

            child: TextButton(
              onPressed: _isSubmitting ? null : _submit,

              child: _isSubmitting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Create'),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: societiesAsync.when(
          data: (societies) => SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s_16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text('Event Details', style: Theme.of(context).textTheme.titleLarge),

                const SizedBox(height: AppSpacing.s_16),

                SocietySelector(
                  societies: societies.where((society) => society.isMember).toList(),

                  value: _selectedSocietyId,

                  onChanged: (value) => setState(() => _selectedSocietyId = value),
                ),

                const SizedBox(height: AppSpacing.s_16),

                TextField(
                  controller: _titleController,

                  textCapitalization: TextCapitalization.words,

                  decoration: const InputDecoration(labelText: 'Event Title', hintText: 'Flutter Workshop 2026'),
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

                  onPickStart: _pickStartDateTime,

                  onPickEnd: _pickEndDateTime,
                ),

                const SizedBox(height: AppSpacing.s_20),

                EventLocationField(controller: _locationController),

                const SizedBox(height: AppSpacing.s_20),

                LinkedPostToggle(value: _alsoCreatePost, onChanged: (value) => setState(() => _alsoCreatePost = value)),

                if (_alsoCreatePost) ...[
                  const SizedBox(height: AppSpacing.s_16),

                  PostComposerField(controller: _linkedPostController),
                ],

                const SizedBox(height: AppSpacing.s_24),
              ],
            ),
          ),

          loading: () => const AppLoading(),

          error: (error, _) => AppError(error: error, onRetry: () => ref.invalidate(societiesProvider)),
        ),
      ),
    );
  }
}
