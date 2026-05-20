import 'package:fccu_societies_hub/models/society.dart';

abstract class SocietyRepository {
  Future<List<Society>> fetchSocieties();

  // TODO
  // Future<List<Society>> fetchMemberSocieties();

  Future<Society> getSociety(String societyId);

  Future<void> createSociety(Society society);

  Future<void> updateSociety(Society society);

  Future<void> deleteSociety(String societyId);
}
