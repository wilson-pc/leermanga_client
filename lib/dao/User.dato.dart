import 'package:floor/floor.dart';

import 'package:leermanga_client/entity/UserLocal.dart';

@dao
abstract class UserDAO {
  @Query('SELECT * FROM UserLocal LIMIT 1')
  Future<UserLocal?> currentUser();

  @insert
  Future<void> insertUser(UserLocal favorite);

  @Query("delete from UserLocal")
  Future<void> deleteUser();
}
