import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/features/societies/providers/societies_provider.dart';
import 'package:fccu_societies_hub/features/societies/widgets/society_card.dart';
import 'package:fccu_societies_hub/models/society.dart';
import 'package:fccu_societies_hub/widgets/items_list.dart';

class SocietiesList extends ItemsList<Society> {
  static const noItemsYet = 'No societies yet';
  static const noItemsFound = 'No societies found';
  static const noItemsLong = 'Societies will appear here.';

  const SocietiesList({super.key, super.filter, super.userFilter, super.failMsg});

  @override
  IconData get icon => Icons.group_outlined;

  @override
  Widget itemCard(Society item) => SocietyCard(society: item);

  @override
  FutureProvider<List<Society>> get itemsProvider => societiesProvider;
}
