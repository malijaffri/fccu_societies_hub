import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';

class EventDateTimeSection extends StatelessWidget {
  final DateTime? startsAt;
  final DateTime? endsAt;

  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;

  const EventDateTimeSection({
    super.key,
    required this.startsAt,
    required this.endsAt,
    required this.onPickStart,
    required this.onPickEnd,
  });

  String _format(DateTime? date) {
    if (date == null) {
      return 'Select';
    }

    return DateFormat('EEE, MMM d • h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,

      children: [
        Text('Date & Time', style: Theme.of(context).textTheme.titleMedium),

        const SizedBox(height: AppSpacing.s_16),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onPickStart,

                child: Padding(
                  padding: const .symmetric(vertical: AppSpacing.s_12),

                  child: Column(
                    crossAxisAlignment: .start,

                    children: [const Text('Starts'), const SizedBox(height: 4), Text(_format(startsAt))],
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.s_12),

            Expanded(
              child: OutlinedButton(
                onPressed: onPickEnd,

                child: Padding(
                  padding: const .symmetric(vertical: AppSpacing.s_12),

                  child: Column(
                    crossAxisAlignment: .start,

                    children: [const Text('Ends'), const SizedBox(height: 4), Text(_format(endsAt))],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
