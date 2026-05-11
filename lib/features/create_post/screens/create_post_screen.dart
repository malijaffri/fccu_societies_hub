import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/create_post/widgets/media_picker_section.dart';
import 'package:fccu_societies_hub/features/create_post/widgets/post_composer_field.dart';
import 'package:fccu_societies_hub/features/create_post/widgets/society_selector.dart';
import 'package:fccu_societies_hub/mock/mock_societies.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
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

    final picker = ImagePicker();

    final images = await picker.pickMultiImage(imageQuality: 85);

    if (images.isEmpty) {
      return;
    }

    final remainingSlots = 4 - _selectedImages.length;

    final limitedImages = images.take(remainingSlots);

    setState(() => _selectedImages.addAll(limitedImages.map((image) => File(image.path))));
  }

  void _removeImage(File image) {
    setState(() => _selectedImages.remove(image));
  }

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

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) {
      return;
    }

    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        child: SingleChildScrollView(
          padding: const .all(AppSpacing.s_16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SocietySelector(
                societies: mockSocieties(),

                value: _selectedSocietyId,

                onChanged: (value) {
                  setState(() => _selectedSocietyId = value);
                },
              ),

              const SizedBox(height: AppSpacing.s_20),

              ///
              /// COMPOSER
              ///
              Text('What\'s happening?', style: theme.textTheme.titleMedium),

              const SizedBox(height: AppSpacing.s_12),

              PostComposerField(controller: _contentController),

              const SizedBox(height: AppSpacing.s_20),

              ///
              /// MEDIA
              ///
              MediaPickerSection(
                selectedImages: _selectedImages,

                onAddImages: _pickImages,

                onRemoveImage: _removeImage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
