import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/media/providers/storage_service_provider.dart';
import 'package:fccu_societies_hub/features/users/providers/current_user_model_provider.dart';
import 'package:fccu_societies_hub/features/users/providers/users_provider.dart';
import 'package:fccu_societies_hub/models/user_model.dart';
import 'package:fccu_societies_hub/widgets/avatar.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  File? _newAvatar;
  bool _isLoading = false;
  UserModel? _original;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserModelProvider).value;
    _original = user;
    _nameController.text = user?.name ?? '';
    _bioController.text = user?.description ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    setState(() => _newAvatar = File(picked.path));
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty.')),
      );
      return;
    }

    final user = await ref.read(currentUserModelProvider.future);
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      String? avatarUrl = user.avatarUrl;

      if (_newAvatar != null) {
        final storage = ref.read(storageServiceProvider);
        avatarUrl = await storage.uploadAvatarImage(_newAvatar!);
      }

      final updated = user.copyWith(
        name: name,
        description: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
        avatarUrl: avatarUrl,
      );

      await ref.read(userRepositoryProvider).updateUser(updated);

      ref.invalidate(currentUserModelProvider);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.s_8),
            child: TextButton(
              onPressed: _isLoading ? null : _save,
              child: _isLoading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Save'),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s_24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
                children: [
                  _newAvatar != null
                      ? CircleAvatar(
                          radius: 48,
                          backgroundImage: FileImage(_newAvatar!),
                        )
                      : Avatar(
                          avatarUrl: _original?.avatarUrl,
                          name: _original?.name ?? '',
                          radius: 48,
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.s_8),
            Text(
              'Tap to change photo',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: AppSpacing.s_32),

            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),

            const SizedBox(height: AppSpacing.s_16),

            TextField(
              controller: _bioController,
              minLines: 3,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Bio',
                hintText: 'Tell people a bit about yourself…',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
