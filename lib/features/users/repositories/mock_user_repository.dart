import 'package:fccu_societies_hub/features/users/repositories/user_repository.dart';
import 'package:fccu_societies_hub/mock/mock_users.dart';
import 'package:fccu_societies_hub/models/user_model.dart';

class MockUserRepository implements UserRepository {
  @override
  Future<List<UserModel>> fetchUsers() async {
    await Future.delayed(const Duration(seconds: 1));

    return mockUsers;
  }

  @override
  Future<UserModel?> getUser(String userId) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      return mockUsers.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createUser(UserModel user) async => await Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> updateUser(UserModel user) async => await Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> deleteUser(String userId) async => await Future.delayed(const Duration(seconds: 1));
}
