import 'package:fccu_societies_hub/mock/mock_posts.dart';
import 'package:fccu_societies_hub/models/comment.dart';

final mockComments =
    mockPosts
        .map(
          (post) => List.generate(
            5,
            (i) => Comment(
              id: '${post.id}_$i',
              postId: post.id,
              userId: '$i',
              userName: 'User $i',
              userAvatar: i % 2 == 0 ? 'https://placehold.co/600x600.jpg' : null,
              content: 'Content of Comment ${post.id}.$i\n\nWith newlines. **bold**. _italic_.',
              createdAt: .now().subtract(.new(hours: i * 12)),
            ),
          ),
        )
        .expand((i) => i)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
