import 'dart:async';
import 'package:floor/floor.dart';
import 'package:leermanga_client/dao/Chapter.dao.dart';
import 'package:leermanga_client/dao/Favorites.dao.dart';
import 'package:leermanga_client/dao/User.dato.dart';
import 'package:leermanga_client/entity/Chapter.dart';
import 'package:leermanga_client/entity/Favorites.dart';
import 'package:leermanga_client/entity/UserLocal.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Chapter, Favorites, UserLocal])
abstract class AppDatabase extends FloorDatabase {
  ChapterDao get chapterDao;
  FavoritesDao get favoriteDao;
  UserDAO get userDao;
}
