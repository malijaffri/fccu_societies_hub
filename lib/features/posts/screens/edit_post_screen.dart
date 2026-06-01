import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/widgets/app_error.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';
import 'package:fccu_societies_hub/features/posts/providers/posts_provider.dart';
import 'package:fccu_societies_hub/features/create_post/widgets/post_composer_field.dart';

class EditPostScreen extends ConsumerStatefulWidget {
  final String postId;
  const EditPostScreen({super.key, required this.postId});

  @override
  ConsumerState<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends ConsumerState<EditPostScreen> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;
  bool _initialised = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post cannot be empty.')),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final post = await ref.read(postProvider(widget.postId).future);
      if (post == null) throw Exception('Post not found');
      await ref.read(postRepositoryProvider).updatePost(post.copyWith(content: text));
      ref.invalidate(postProvider(widget.postId));
      ref.invalidate(postsProvider);
      ref.invalidate(feedProvider);
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
    final postAsync = ref.watch(postProvider(widget.postId));

    return postAsync.when(
      loading: () => const Scaffold(body: AppLoading()),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Edit Post')),
        body: AppError(error: e, onRetry: () => ref.invalidate(postProvider(widget.postId))),
      ),
      data: (post) {
        if (post == null) {
          return Scaffold(appBar: AppBar(), body: const Center(child: Text('Post not found')));
        }
        // Seed the controller once
        if (!_initialised) {
          _controller.text = post.content;
          _initialised = true;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Post'),
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
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.s_16),
            child: PostComposerField(controller: _controller),
          ),
        );
      },
    );
  }
}
