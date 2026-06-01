import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fccu_societies_hub/core/router/app_router.dart';

Future<void> showAuthRequiredSheet(BuildContext context) => showModalBottomSheet(
  context: context,

  showDragHandle: true,

  builder: (context) => SafeArea(
    child: Padding(
      padding: const .all(24),

      child: Column(
        mainAxisSize: .min,

        children: [
          const Icon(Icons.lock_rounded, size: 40),

          const SizedBox(height: 16),

          Text('Login Required', style: Theme.of(context).textTheme.titleLarge),

          const SizedBox(height: 8),

          Text('Create an account or login to interact with societies.', textAlign: TextAlign.center),

          const SizedBox(height: 24),

          FilledButton(
            onPressed: () {
              Navigator.pop(context);

              context.push(AppRoutes.register);
            },

            child: const Text('Continue'),
          ),
        ],
      ),
    ),
  ),
);
