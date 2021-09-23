import 'package:floor/floor.dart';

@entity
class UserLocal {
  @primaryKey
  final String id;
  final String? email;
  final String? phone;
  final String role;
  final String updatedAt;

  UserLocal({
    required this.id,
    required this.email,
    required this.phone,
    required this.role,
    required this.updatedAt,
  });
}
