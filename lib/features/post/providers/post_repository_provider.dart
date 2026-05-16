import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/post/repositories/post_repository.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) => MockPostRepository());
