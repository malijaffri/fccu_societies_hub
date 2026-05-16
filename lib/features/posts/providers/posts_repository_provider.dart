import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/posts/repositories/posts_repository.dart';

final postsRepositoryProvider = Provider<PostsRepository>((ref) => MockPostsRepository());
