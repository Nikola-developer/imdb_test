import 'package:imdb_test/database/imdb_database.dart';
import 'package:imdb_test/models/genre_model.dart';

class GenreDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> insertData(GenreModel genreModel) async {
    final db = await dbProvider.database;

    print('GenreDao - insertData - genreModel.id: ${genreModel.id}');

    var result = db!.insert(dbProvider.tableGenre, genreModel.toDatabaseJson());
    return result;
  }

  Future<List<GenreModel>> readGenresForMovie(int id_movie) async {
    final db = await dbProvider.database;

    final List<Map<String, dynamic>> maps =
        await db!.rawQuery('SELECT g.* FROM movie_genres mg '
            'LEFT JOIN genre g on g.id = mg.id_genre '
            'WHERE id_movie = $id_movie');

    return List.generate(maps.length, (i) {
      return GenreModel.fromJson(maps[i]);
    });
  }
}
