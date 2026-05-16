import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? avatarUrl;
  final String? name;
  final double radius;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const Avatar({super.key, this.avatarUrl, this.name, this.radius = 18, this.backgroundColor, this.textStyle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String? nameAcronym;
    if (name != null) {
      final nameAcronymChars = name!.split(' ').where((w) => w.isNotEmpty).map((w) => w[0]).toList();
      final nameUpperAcronym = nameAcronymChars.where((c) => c == c.toUpperCase()).join();
      nameAcronym = nameUpperAcronym.isNotEmpty ? nameUpperAcronym : nameAcronymChars.join().toUpperCase();
    } else {
      nameAcronym = null;
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? colorScheme.secondaryContainer,
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
      child: avatarUrl == null
          ? nameAcronym != null
                ? Text(
                    nameAcronym,
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
