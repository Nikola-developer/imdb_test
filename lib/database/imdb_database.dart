import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  final String databaseName = 'imdb_database.db';
  final String tableMovies = 'movies';
  final String tableGenres = 'genres';
  final String tableMoviesGenres = 'movies_genres';
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: initDB,
      onUpgrade: onUpgrade,
    );
    return database;
  }

  void onUpgrade(
    Database database,
    int oldVersion,
    int newVersion,
  ) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute(
      'CREATE TABLE `$tableGenres` ( '
      'id INTEGER PRIMARY KEY, '
      'name VARCHAR DEFAULT NULL '
      ')',
    );

    await database.execute(
      'CREATE TABLE `$tableMovies` ( '
      'id INTEGER PRIMARY KEY NOT NULL, '
      'poster_path VARCHAR NOT NULL, '
      'release_date DATE NOT NULL, '
      'title VARCHAR NOT NULL, '
      'video BOOLEAN DEFAULT false, '
      'vote_average DECIMAL(1,1) NOT NULL, '
      'favourite BOOLEAN DEFAULT false '
      ')',
    );

    await database.execute(
      'CREATE TABLE `$tableMoviesGenres` ( '
      'id_movie INTEGER NOT NULL, '
      'id_genre INTEGER NOT NULL, '
      'UNIQUE(id_movie,id_genre), '
      ' FOREIGN KEY (id_genre) '
      '    REFERENCES genre (id), '
      ' FOREIGN KEY (id_movie) '
      '    REFERENCES movie (id) '
      ')'
    );
  }
}
