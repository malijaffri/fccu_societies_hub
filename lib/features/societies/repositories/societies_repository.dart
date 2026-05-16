import 'package:fccu_societies_hub/mock/mock_societies.dart';
import 'package:fccu_societies_hub/models/society.dart';

abstract class SocietiesRepository {
  Future<List<Society>> fetchSocieties();

  Future<Society> fetchSociety(String societyId);
}

class MockSocietiesRepository implements SocietiesRepository {
  @override
  Future<List<Society>> fetchSocieties() async {
    await Future.delayed(const .new(seconds: 1));

    return mockSocieties;
  }

  @override
  Future<Society> fetchSociety(String societyId) async {
    await Future.delayed(const .new(seconds: 1));

    return mockSocieties.firstWhere((society) => society.id == societyId);
  }
}
