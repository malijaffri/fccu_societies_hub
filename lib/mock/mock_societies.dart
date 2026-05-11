import 'package:fccu_societies_hub/models/society.dart';

List<Society> mockSocieties({int count = 10, String? id}) => List.generate(
  count,
  (i) => Society(
    id: id ?? 'society_$i',
    name: 'Society $i',
    imageUrl: null,
    bio: i % 2 == 0 ? null : 'Bio for Society $i\n\nWith newlines. **bold**. _italic_.',
    isFollowed: i % 3 == 0,
    isMember: i % 4 == 0,
  ),
);
