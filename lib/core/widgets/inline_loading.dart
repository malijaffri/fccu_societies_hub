import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';

class InlineLoading extends StatelessWidget {
  const InlineLoading({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: .symmetric(vertical: AppSpacing.s_32),
    child: AppLoading(),
  );
}
