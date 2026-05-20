import 'package:fccu_societies_hub/models/user_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> fetchUsers();

  Future<UserModel> getUser(String userId);

  Future<void> createUser(UserModel user);

  Future<void> updateUser(UserModel user);

  Future<void> deleteUser(String userId);
}
