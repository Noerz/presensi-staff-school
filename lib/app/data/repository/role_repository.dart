import 'package:presensi_school/app/data/models/role_model.dart';

abstract class RoleRepository {
  Future<List<Role>> getRoles();
}