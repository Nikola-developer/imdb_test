import 'package:imdb_test/database/imdb_database.dart';
import 'package:imdb_test/models/movie_model.dart';

class MovieDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<bool> insertData(MovieModel movieModel) async {
    final db = await dbProvider.database;

    print('MovieDao - insertData - movieModel.id: ${movieModel.id}');

    try {
      String data = '';

      for (int i = 0; i < movieModel.listGenreIds.length; i++) {
        data += '(${movieModel.id}, ${movieModel.listGenreIds[i]}) ';
        if (i != movieModel.listGenreIds.length - 1) data += ', ';
      }

      var batch = db!.batch();
      batch.insert(dbProvider.tableMovies, movieModel.toDatabaseJson());
      batch.rawInsert('INSERT INTO ${dbProvider.tableMoviesGenres} '
          '(id_movie, id_genre) '
          'VALUES '
          '$data');
      await batch.commit(continueOnError: false);
      return true;
    } catch (e) {
      print('e: $e');
      return false;
    }
  }

  Future<List<MovieModel>> readData(int page,
      {bool favouritesOnly = false}) async {
    final db = await dbProvider.database;

    int limit = 20;

    // final List<Map<String, dynamic>> maps = await db!.query(
    //   dbProvider.tableMovies,
    //   where: 'id > ? AND id < ? ',
    //   whereArgs: [page * limit, (page + 1) * limit],
    // );

    if (page > 0) {
      page = page * 10;
    }

      String sql = ''
          "SELECT m.*, mg.genres, mg.genre_ids "
          "FROM movies m "
          "LEFT JOIN ( "
          "    SELECT mg.id_movie, "
          " '[' || GROUP_CONCAT('{\"id\":' || g.id || ', "
          " \"name\":\"' || g.name || '\"}' ) || ']' as genres, "
          " '[' ||GROUP_CONCAT(g.id) || ']' as genre_ids "
          "    FROM movies_genres mg "
          "    LEFT JOIN genres g on g.id = mg.id_genre "
          "    GROUP BY mg.id_movie "
          ") mg on mg.id_movie = m.id "
          "WHERE m.page > ${page} AND m.page <= ${(page + limit)}  ";

      print('sql: ${sql}');
      final List<Map<String, dynamic>> maps = await db!.rawQuery(sql);

      return List.generate(maps.length, (i) {
        print('maps[i]: ${maps[i]}');
        return MovieModel.fromDatabaseJson(maps[i]);
      });
    }
}
