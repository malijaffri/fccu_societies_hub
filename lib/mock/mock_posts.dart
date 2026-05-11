import 'package:fccu_societies_hub/models/media.dart';
import 'package:fccu_societies_hub/models/post.dart';

List<Post> mockPosts({int count = 10}) => List.generate(
  count,
  (i) => Post(
    id: 'post_$i',
    societyId: 'soc_1',
    societyName: 'CS Society',
    societyImage: null,
    authorId: 'user_1',
    authorName: 'Ali',
    content: 'This is a sample post #$i',
    media: .generate(i, (j) => const Media(url: 'https://placehold.co/600x600.jpg', type: .image)),
    likeCount: i * 3,
    commentCount: i,
    isLiked: i % 2 == 0,
    createdAt: DateTime.now().subtract(Duration(hours: i)),
  ),
);
