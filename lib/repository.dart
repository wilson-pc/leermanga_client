import 'package:leermanga_client/database.dart';

Future<AppDatabase> dbInstance() async {
  final database = await $FloorAppDatabase.databaseBuilder('dblite.db').build();

  return database;
}
