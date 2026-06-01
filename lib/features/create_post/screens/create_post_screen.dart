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
import 'package:fccu_societies_hub/features/media/providers/storage_service_provider.dart';
import 'package:fccu_societies_hub/features/posts/providers/posts_provider.dart';
import 'package:fccu_societies_hub/features/societies/providers/societies_provider.dart';
import 'package:fccu_societies_hub/features/users/providers/current_user_model_provider.dart';
import 'package:fccu_societies_hub/models/media.dart';
import 'package:fccu_societies_hub/models/post.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _contentController = TextEditingController();

  final List<File> _selectedImages = [];

  String? _selectedSocietyId;
  String? _selectedSocietyName;
  String? _selectedSocietyImage;

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

    setState(() => _selectedImages.addAll(limitedImages.map((image) => File(image.path))));
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

    try {
      final storage = ref.read(storageServiceProvider);

      final media = await Future.wait(
        _selectedImages
            .map((image) async => Media(url: await storage.uploadPostImage(image), type: MediaType.image))
            .toList(),
      );

      final user = ref.read(currentUserModelProvider).value;
      // final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Not authenticated');
      }

      final post = Post(
        id: '',
        isFollowed: false, // TODO
        isLiked: false, // TODO
        societyId: _selectedSocietyId!,
        societyName: _selectedSocietyName!,
        societyImage: _selectedSocietyImage!,
        authorId: user.id,
        authorName: user.name,
        authorAvatarUrl: user.avatarUrl,
        content: _contentController.text.trim(),
        media: media,
        likeCount: 0,
        commentCount: 0,
        createdAt: .now(),
      );

      await ref.read(postRepositoryProvider).createPost(post);

      if (!mounted) {
        return;
      }

      Navigator.pop(context);
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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
            padding: const EdgeInsets.only(right: AppSpacing.s_8),

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
            padding: const EdgeInsets.all(AppSpacing.s_16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SocietySelector(
                  societies: societies.where((society) => society.isMember).toList(),

                  value: _selectedSocietyId,

                  onChanged: (value) {
                    if (value == null) return;
                    try {
                      final society = societies.firstWhere((society) => society.id == value);
                      setState(() {
                        _selectedSocietyId = value;
                        _selectedSocietyName = society.name;
                        _selectedSocietyImage = society.imageUrl;
                      });
                    } catch (e) {
                      _showError('Society not found.');
                    }
                  },
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
