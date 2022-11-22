import 'package:imdb_test/database/imdb_database.dart';
import 'package:imdb_test/models/movie_model.dart';

class MovieDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> insertData(MovieModel movieModel) async {
    final db = await dbProvider.database;

    print('MovieDao - insertData - movieModel.id: ${movieModel.id}');

    var result = db!.insert(dbProvider.tableMovie, movieModel.toDatabaseJson());

    print('MovieDao - insertData - result: ${result}');

    String data = '';

    for (int i = 0; i < movieModel.listGenreIds.length; i++) {
      data += '(${movieModel.id}, ${movieModel.listGenreIds[i]}) ';
      if (i != movieModel.listGenreIds.length-1) data += ', ';
    }

    var resultMoviesGenres =
        db.rawInsert('INSERT INTO ${dbProvider.tableMoviesGenres} '
            '(id_movie, id_genre) '
            'VALUES '
            '$data');

    return result;
  }

  Future<List<MovieModel>> readData(int page,
      {bool favouritesOnly = false}) async {
    final db = await dbProvider.database;

    int limit = 20;

    final List<Map<String, dynamic>> maps = await db!.query(
      dbProvider.tableMovie,
      where: 'id > ? AND id < ? ',
      whereArgs: [page * limit, (page + 1) * limit],
    );

    return List.generate(maps.length, (i) {
      return MovieModel.fromJson(maps[i]);
    });
  }
}
