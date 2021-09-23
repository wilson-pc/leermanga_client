// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ChapterDao? _chapterDaoInstance;

  FavoritesDao? _favoriteDaoInstance;

  UserDAO? _userDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Chapter` (`id` TEXT NOT NULL, `local` INTEGER NOT NULL, `name` TEXT NOT NULL, `url` TEXT NOT NULL, `urlmanga` TEXT NOT NULL, `manga` TEXT NOT NULL, `createat` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Favorites` (`id` TEXT NOT NULL, `title` TEXT NOT NULL, `local` INTEGER NOT NULL, `cover` TEXT NOT NULL, `type` TEXT NOT NULL, `url` TEXT NOT NULL, `color` TEXT NOT NULL, `next` TEXT, `createat` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserLocal` (`id` TEXT NOT NULL, `email` TEXT, `phone` TEXT, `role` TEXT NOT NULL, `updatedAt` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ChapterDao get chapterDao {
    return _chapterDaoInstance ??= _$ChapterDao(database, changeListener);
  }

  @override
  FavoritesDao get favoriteDao {
    return _favoriteDaoInstance ??= _$FavoritesDao(database, changeListener);
  }

  @override
  UserDAO get userDao {
    return _userDaoInstance ??= _$UserDAO(database, changeListener);
  }
}

class _$ChapterDao extends ChapterDao {
  _$ChapterDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _chapterInsertionAdapter = InsertionAdapter(
            database,
            'Chapter',
            (Chapter item) => <String, Object?>{
                  'id': item.id,
                  'local': item.local ? 1 : 0,
                  'name': item.name,
                  'url': item.url,
                  'urlmanga': item.urlmanga,
                  'manga': item.manga,
                  'createat': item.createat
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Chapter> _chapterInsertionAdapter;

  @override
  Future<List<Chapter>> findAllChapter() async {
    return _queryAdapter.queryList(
        'SELECT * FROM chapter order by datetime(createat) desc',
        mapper: (Map<String, Object?> row) => Chapter(
            id: row['id'] as String,
            local: (row['local'] as int) != 0,
            createat: row['createat'] as String,
            name: row['name'] as String,
            url: row['url'] as String,
            urlmanga: row['urlmanga'] as String,
            manga: row['manga'] as String));
  }

  @override
  Future<Chapter?> findChapterById(String id) async {
    return _queryAdapter.query('SELECT * FROM chapter WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Chapter(
            id: row['id'] as String,
            local: (row['local'] as int) != 0,
            createat: row['createat'] as String,
            name: row['name'] as String,
            url: row['url'] as String,
            urlmanga: row['urlmanga'] as String,
            manga: row['manga'] as String),
        arguments: [id]);
  }

  @override
  Future<List<Chapter?>> findNonLocal() async {
    return _queryAdapter.queryList('SELECT * FROM Favorites WHERE local = 0',
        mapper: (Map<String, Object?> row) => Chapter(
            id: row['id'] as String,
            local: (row['local'] as int) != 0,
            createat: row['createat'] as String,
            name: row['name'] as String,
            url: row['url'] as String,
            urlmanga: row['urlmanga'] as String,
            manga: row['manga'] as String));
  }

  @override
  Future<List<Chapter>> findChapterByUrlmanga(String url) async {
    return _queryAdapter.queryList('SELECT * FROM chapter WHERE urlmanga = ?1',
        mapper: (Map<String, Object?> row) => Chapter(
            id: row['id'] as String,
            local: (row['local'] as int) != 0,
            createat: row['createat'] as String,
            name: row['name'] as String,
            url: row['url'] as String,
            urlmanga: row['urlmanga'] as String,
            manga: row['manga'] as String),
        arguments: [url]);
  }

  @override
  Future<Chapter?> findChapterByUrl(String url) async {
    return _queryAdapter.query('SELECT * FROM chapter WHERE url = ?1',
        mapper: (Map<String, Object?> row) => Chapter(
            id: row['id'] as String,
            local: (row['local'] as int) != 0,
            createat: row['createat'] as String,
            name: row['name'] as String,
            url: row['url'] as String,
            urlmanga: row['urlmanga'] as String,
            manga: row['manga'] as String),
        arguments: [url]);
  }

  @override
  Future<void> deleteChapter(String id) async {
    await _queryAdapter
        .queryNoReturn('delete from chapter where id = ?1', arguments: [id]);
  }

  @override
  Future<void> setLocalChapter() async {
    await _queryAdapter.queryNoReturn('update chapter set local=1');
  }

  @override
  Future<void> deleteAllChapter() async {
    await _queryAdapter.queryNoReturn('delete from chapter');
  }

  @override
  Future<void> insertChapter(Chapter chapter) async {
    await _chapterInsertionAdapter.insert(chapter, OnConflictStrategy.abort);
  }
}

class _$FavoritesDao extends FavoritesDao {
  _$FavoritesDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _favoritesInsertionAdapter = InsertionAdapter(
            database,
            'Favorites',
            (Favorites item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'local': item.local ? 1 : 0,
                  'cover': item.cover,
                  'type': item.type,
                  'url': item.url,
                  'color': item.color,
                  'next': item.next,
                  'createat': item.createat
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Favorites> _favoritesInsertionAdapter;

  @override
  Future<List<Favorites>> findAllFavorites() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Favorites order by datetime(createat) desc',
        mapper: (Map<String, Object?> row) => Favorites(
            id: row['id'] as String,
            title: row['title'] as String,
            cover: row['cover'] as String,
            type: row['type'] as String,
            local: (row['local'] as int) != 0,
            url: row['url'] as String,
            color: row['color'] as String,
            createat: row['createat'] as String,
            next: row['next'] as String?));
  }

  @override
  Future<Favorites?> findFavoriteById(String id) async {
    return _queryAdapter.query('SELECT * FROM Favorites WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Favorites(
            id: row['id'] as String,
            title: row['title'] as String,
            cover: row['cover'] as String,
            type: row['type'] as String,
            local: (row['local'] as int) != 0,
            url: row['url'] as String,
            color: row['color'] as String,
            createat: row['createat'] as String,
            next: row['next'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<Favorites?>> findLocal() async {
    return _queryAdapter.queryList('SELECT * FROM Favorites WHERE local = 1',
        mapper: (Map<String, Object?> row) => Favorites(
            id: row['id'] as String,
            title: row['title'] as String,
            cover: row['cover'] as String,
            type: row['type'] as String,
            local: (row['local'] as int) != 0,
            url: row['url'] as String,
            color: row['color'] as String,
            createat: row['createat'] as String,
            next: row['next'] as String?));
  }

  @override
  Future<Favorites?> findFavoriteByUrl(String url) async {
    return _queryAdapter.query('SELECT * FROM Favorites WHERE url = ?1',
        mapper: (Map<String, Object?> row) => Favorites(
            id: row['id'] as String,
            title: row['title'] as String,
            cover: row['cover'] as String,
            type: row['type'] as String,
            local: (row['local'] as int) != 0,
            url: row['url'] as String,
            color: row['color'] as String,
            createat: row['createat'] as String,
            next: row['next'] as String?),
        arguments: [url]);
  }

  @override
  Future<void> deleteFavorite(String id) async {
    await _queryAdapter
        .queryNoReturn('delete from Favorites where id = ?1', arguments: [id]);
  }

  @override
  Future<void> setLocalFavorite() async {
    await _queryAdapter.queryNoReturn('update Favorites set local=1');
  }

  @override
  Future<void> deleteAllFavorites() async {
    await _queryAdapter.queryNoReturn('delete from Favorites');
  }

  @override
  Future<void> insertFavorite(Favorites favorite) async {
    await _favoritesInsertionAdapter.insert(favorite, OnConflictStrategy.abort);
  }
}

class _$UserDAO extends UserDAO {
  _$UserDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userLocalInsertionAdapter = InsertionAdapter(
            database,
            'UserLocal',
            (UserLocal item) => <String, Object?>{
                  'id': item.id,
                  'email': item.email,
                  'phone': item.phone,
                  'role': item.role,
                  'updatedAt': item.updatedAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserLocal> _userLocalInsertionAdapter;

  @override
  Future<UserLocal?> currentUser() async {
    return _queryAdapter.query('SELECT * FROM UserLocal LIMIT 1',
        mapper: (Map<String, Object?> row) => UserLocal(
            id: row['id'] as String,
            email: row['email'] as String?,
            phone: row['phone'] as String?,
            role: row['role'] as String,
            updatedAt: row['updatedAt'] as String));
  }

  @override
  Future<void> deleteUser() async {
    await _queryAdapter.queryNoReturn('delete from UserLocal');
  }

  @override
  Future<void> insertUser(UserLocal favorite) async {
    await _userLocalInsertionAdapter.insert(favorite, OnConflictStrategy.abort);
  }
}
