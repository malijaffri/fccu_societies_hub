import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/session/providers/session_mode_provider.dart';
import 'package:fccu_societies_hub/features/session/utils/session_permissions.dart';

final canCreateContentProvider = Provider<bool>(
  (ref) => ref.watch(sessionModeProvider).maybeWhen(data: (mode) => canCreateContent(mode), orElse: () => false),
);

final canCommentProvider = Provider<bool>(
  (ref) => ref.watch(sessionModeProvider).maybeWhen(data: (mode) => canComment(mode), orElse: () => false),
);

final canReactProvider = Provider<bool>(
  (ref) => ref.watch(sessionModeProvider).maybeWhen(data: (mode) => canReact(mode), orElse: () => false),
);
