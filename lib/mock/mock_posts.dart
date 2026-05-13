import 'package:fccu_societies_hub/mock/mock_societies.dart';
import 'package:fccu_societies_hub/models/post.dart';

final mockPosts =
    mockSocieties
        .map(
          (society) => List.generate(
            5,
            (i) => Post(
              id: '${society.id}_$i',
              societyId: society.id,
              societyName: society.name,
              societyImage: i % 2 == 0 ? 'https://placehold.co/600x600.jpg' : null,
              authorId: '$i',
              authorName: 'User $i',
              content: 'Content of Post ${society.id}.$i\n\nWith newlines. **bold**. _italic_.',
              media: .generate(i, (j) => const .new(url: 'https://placehold.co/600x600.jpg', type: .image)),
              likeCount: i * 3,
              commentCount: i,
              isLiked: i % 3 == 0,
              createdAt: .now().subtract(.new(hours: i)),
            ),
          ),
        )
        .expand((i) => i)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
