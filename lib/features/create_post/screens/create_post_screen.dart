import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/widgets/app_error.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';
import 'package:fccu_societies_hub/features/create_post/widgets/media_picker_section.dart';
import 'package:fccu_societies_hub/features/create_post/widgets/post_composer_field.dart';
import 'package:fccu_societies_hub/features/create_post/widgets/society_selector.dart';
import 'package:fccu_societies_hub/features/societies/providers/societies_provider.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _contentController = TextEditingController();

  final List<File> _selectedImages = [];

  String? _selectedSocietyId;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();

    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_selectedImages.length >= 4) {
      return;
    }

    final images = await ImagePicker().pickMultiImage(imageQuality: 85);

    if (images.isEmpty) {
      return;
    }

    final limitedImages = images.take(4 - _selectedImages.length);

    setState(() => _selectedImages.addAll(limitedImages.map((image) => .new(image.path))));
  }

  void _removeImage(File image) => setState(() => _selectedImages.remove(image));

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_selectedSocietyId == null) {
      _showError('Please select a society.');

      return;
    }

    if (_contentController.text.trim().isEmpty && _selectedImages.isEmpty) {
      _showError('Your post is empty.');

      return;
    }

    setState(() => _isSubmitting = true);

    await Future.delayed(const .new(seconds: 1));

    if (!mounted) {
      return;
    }

    Navigator.pop(context);
  }

  void _showError(String message) => ScaffoldMessenger.of(context).showSnackBar(.new(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final societiesAsync = ref.watch(societiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),

        actions: [
          Padding(
            padding: const .only(right: AppSpacing.s_8),

            child: TextButton(
              onPressed: _isSubmitting ? null : _submit,

              child: _isSubmitting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Post'),
            ),
          ),
        ],
      ),

      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: societiesAsync.when(
          data: (societies) => SingleChildScrollView(
            padding: const .all(AppSpacing.s_16),

            child: Column(
              crossAxisAlignment: .start,

              children: [
                SocietySelector(
                  societies: societies.where((society) => society.isMember).toList(),

                  value: _selectedSocietyId,

                  onChanged: (value) => setState(() => _selectedSocietyId = value),
                ),

                const SizedBox(height: AppSpacing.s_20),

                Text('What\'s happening?', style: Theme.of(context).textTheme.titleMedium),

                const SizedBox(height: AppSpacing.s_12),

                PostComposerField(controller: _contentController),

                const SizedBox(height: AppSpacing.s_20),

                MediaPickerSection(
                  selectedImages: _selectedImages,
                  onAddImages: _pickImages,
                  onRemoveImage: _removeImage,
                ),
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
