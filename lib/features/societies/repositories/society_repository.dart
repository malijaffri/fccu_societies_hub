import 'package:fccu_societies_hub/models/society.dart';

abstract class SocietyRepository {
  Future<List<Society>> fetchSocieties({String? currentUserId});

  Future<Society?> getSociety(String societyId, {String? currentUserId});

  Future<void> createSociety(Society society);

  Future<void> updateSociety(Society society);

  Future<void> deleteSociety(String societyId);

  Future<void> followSociety(String societyId, String userId);

  Future<void> unfollowSociety(String societyId, String userId);

  Future<void> joinSociety(String societyId, String userId);

  Future<void> leaveSociety(String societyId, String userId);
}
