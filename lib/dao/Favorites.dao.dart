import 'package:floor/floor.dart';
import 'package:leermanga_client/entity/Favorites.dart';

@dao
abstract class FavoritesDao {
  @Query('SELECT * FROM Favorites order by datetime(createat) desc')
  Future<List<Favorites>> findAllFavorites();

  @Query('SELECT * FROM Favorites WHERE id = :id')
  Future<Favorites?> findFavoriteById(String id);

  @Query('SELECT * FROM Favorites WHERE local = 1')
  Future<List<Favorites?>> findLocal();

  @Query('SELECT * FROM Favorites WHERE url = :url')
  Future<Favorites?> findFavoriteByUrl(String url);

  @insert
  Future<void> insertFavorite(Favorites favorite);

  @Query("delete from Favorites where id = :id")
  Future<void> deleteFavorite(String id);

  @Query("update Favorites set local=1")
  Future<void> setLocalFavorite();

  @Query("delete from Favorites")
  Future<void> deleteAllFavorites();
}
