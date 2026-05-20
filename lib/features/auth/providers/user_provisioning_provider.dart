import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/auth/services/user_provisioning_service.dart';
import 'package:fccu_societies_hub/features/users/providers/users_provider.dart';

final userProvisioningProvider = Provider<UserProvisioningService>(
  (ref) => UserProvisioningService(userRepository: ref.watch(userRepositoryProvider)),
);
