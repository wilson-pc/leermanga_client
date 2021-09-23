import 'package:floor/floor.dart';
import 'package:leermanga_client/entity/Chapter.dart';

@dao
abstract class ChapterDao {
  @Query('SELECT * FROM chapter order by datetime(createat) desc')
  Future<List<Chapter>> findAllChapter();

  @Query('SELECT * FROM chapter WHERE id = :id')
  Future<Chapter?> findChapterById(String id);

  @Query('SELECT * FROM Favorites WHERE local = 0')
  Future<List<Chapter?>> findNonLocal();

  @Query('SELECT * FROM chapter WHERE urlmanga = :url')
  Future<List<Chapter>> findChapterByUrlmanga(String url);

  @Query('SELECT * FROM chapter WHERE url = :url')
  Future<Chapter?> findChapterByUrl(String url);

  @insert
  Future<void> insertChapter(Chapter chapter);

  @Query("delete from chapter where id = :id")
  Future<void> deleteChapter(String id);

  @Query("update chapter set local=1")
  Future<void> setLocalChapter();

  @Query("delete from chapter")
  Future<void> deleteAllChapter();
}
