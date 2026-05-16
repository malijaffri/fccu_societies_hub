import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/posts/providers/posts_repository_provider.dart';

final postsProvider = FutureProvider((ref) async => ref.watch(postsRepositoryProvider).fetchPosts());
