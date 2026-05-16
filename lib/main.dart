import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:fccu_societies_hub/core/router/app_router.dart';
import 'package:fccu_societies_hub/core/theme/app_theme.dart';
import 'package:fccu_societies_hub/core/timeago_messages/en_messages.dart';
import 'package:fccu_societies_hub/core/timeago_messages/en_short_messages.dart';

void main() {
  timeago.setLocaleMessages('en', EnMessages());
  timeago.setLocaleMessages('en_short', EnShortMessages());

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'FCCU Societies Hub',
    debugShowCheckedModeBanner: false,
    theme: lightTheme,
    darkTheme: darkTheme,
    themeMode: .system,
    routerConfig: appRouter,
  );
}
