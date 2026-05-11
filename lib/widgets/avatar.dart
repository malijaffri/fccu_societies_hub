import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? avatarUrl;
  final String? name;
  final double radius;
  final TextStyle? textStyle;

  const Avatar({super.key, this.avatarUrl, this.name, this.radius = 18, this.textStyle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.secondaryContainer,
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
      child: avatarUrl == null
          ? name != null
                ? Text(
                    name!.split(' ').where((e) => e.isNotEmpty).map((e) => e[0]).join().toUpperCase(),
                    style: (textStyle ?? theme.textTheme.labelLarge)?.copyWith(
                      fontWeight: .w700,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  )
                : const Icon(Icons.person_rounded)
          : null,
    );
  }
}
