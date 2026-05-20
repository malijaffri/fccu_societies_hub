import 'package:fccu_societies_hub/features/societies/repositories/society_repository.dart';
import 'package:fccu_societies_hub/mock/mock_societies.dart';
import 'package:fccu_societies_hub/models/society.dart';

class MockSocietyRepository implements SocietyRepository {
  @override
  Future<List<Society>> fetchSocieties() async {
    await Future.delayed(const .new(seconds: 1));

    return mockSocieties;
  }

  @override
  Future<Society> getSociety(String societyId) async {
    await Future.delayed(const .new(seconds: 1));

    return mockSocieties.firstWhere((society) => society.id == societyId);
  }

  @override
  Future<void> createSociety(Society society) async => await Future.delayed(const .new(seconds: 1));

  @override
  Future<void> updateSociety(Society society) async => await Future.delayed(const .new(seconds: 1));

  @override
  Future<void> deleteSociety(String societyId) async => await Future.delayed(const .new(seconds: 1));
}
