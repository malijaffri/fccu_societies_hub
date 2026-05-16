import 'package:fccu_societies_hub/features/comments/repositories/comments_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commentsRepositoryProvider = Provider<CommentsRepository>((ref) => MockCommentsRepository());
