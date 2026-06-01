import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/features/societies/widgets/societies_list.dart';

class SocietyScreen extends StatelessWidget {
  const SocietyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Societies')),
      body: const SocietiesList(),
    );
  }
}
