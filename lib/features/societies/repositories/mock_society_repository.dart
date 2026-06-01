import 'package:fccu_societies_hub/features/societies/repositories/society_repository.dart';
import 'package:fccu_societies_hub/mock/mock_societies.dart';
import 'package:fccu_societies_hub/models/society.dart';

class MockSocietyRepository implements SocietyRepository {
  @override
  Future<List<Society>> fetchSocieties({String? currentUserId}) async {
    await Future.delayed(const Duration(seconds: 1));

    return mockSocieties;
  }

  @override
  Future<Society?> getSociety(String societyId, {String? currentUserId}) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      return mockSocieties.firstWhere((society) => society.id == societyId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createSociety(Society society) async => await Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> updateSociety(Society society) async => await Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> deleteSociety(String societyId) async => await Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> followSociety(String societyId, String userId) {
    // TODO: implement followSociety
    throw UnimplementedError();
  }

  @override
  Future<void> joinSociety(String societyId, String userId) {
    // TODO: implement joinSociety
    throw UnimplementedError();
  }

  @override
  Future<void> leaveSociety(String societyId, String userId) {
    // TODO: implement leaveSociety
    throw UnimplementedError();
  }

  @override
  Future<void> unfollowSociety(String societyId, String userId) {
    // TODO: implement unfollowSociety
    throw UnimplementedError();
  }
}
