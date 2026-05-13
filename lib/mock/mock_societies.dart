import 'package:fccu_societies_hub/models/society.dart';

final mockSocieties = List.generate(
  5,
  (i) => Society(
    id: '$i',
    name: 'Society $i',
    imageUrl: null,
    description: i % 2 == 0 ? null : 'Bio for Society $i\n\nWith newlines. **bold**. _italic_.',
    followerCount: i * 4,
    memberCount: i * 3,
    isFollowed: i % 3 == 0,
    isMember: i % 4 == 0,
  ),
);
