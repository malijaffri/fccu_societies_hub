import 'package:fccu_societies_hub/features/session/models/session_mode.dart';

bool canCreateContent(SessionMode mode) => mode == SessionMode.authenticated;

bool canComment(SessionMode mode) => mode == SessionMode.authenticated;

bool canReact(SessionMode mode) => mode == SessionMode.authenticated;
