import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/societies/widgets/society_card.dart';
import 'package:fccu_societies_hub/models/society.dart';

class SocietyListSection extends StatelessWidget {
  final String title;

  final List<Society> societies;

  const SocietyListSection({super.key, required this.title, required this.societies});

  @override
  Widget build(BuildContext context) {
    if (societies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: .start,

      children: [
        Padding(
          padding: const .fromLTRB(AppSpacing.s_16, 0, AppSpacing.s_16, AppSpacing.s_8),

          child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: .w700)),
        ),

        ...societies.map((society) => SocietyCard(society: society)),

        const SizedBox(height: AppSpacing.s_20),
      ],
    );
  }
}
