import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_radius.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';

class PostComposerField extends StatelessWidget {
  final TextEditingController controller;

  const PostComposerField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,

    minLines: 6,
    maxLines: null,

    textCapitalization: .sentences,

    decoration: .new(
      hintText: 'Share updates, announcements, thoughts...',

      alignLabelWithHint: true,

      contentPadding: const .all(AppSpacing.s_16),

      border: OutlineInputBorder(borderRadius: .circular(AppRadius.r_16)),
    ),
  );
}
