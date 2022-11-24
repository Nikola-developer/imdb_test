import 'dart:convert';

import 'package:imdb_test/models/genre_model.dart';

class MovieModel {
  int? page;
  int id;
  String posterPath;
  String releaseDate;
  String title;
  bool video;
  double voteAverage;
  List<int> listGenreIds;
  List<GenreModel>? listGenres;
  bool favourite;

  String? overview;

  MovieModel({
    required this.id,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.listGenreIds,
    required this.favourite,
  });

  MovieModel.fromDatabase({
    required this.page,
    required this.id,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.listGenreIds,
    required this.favourite,
    required this.listGenres,
  });

  MovieModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        posterPath = json['poster_path'],
        releaseDate = json['release_date'],
        title = json['title'],
        video = json['video'] == 1 ? true : false,
        voteAverage = json['vote_average'].toDouble(),
        listGenreIds = List<int>.from(json['genre_ids'].map((model) => model)),
        favourite = json['favourite'] ?? false;

  MovieModel.fromDatabaseJson(Map<String, dynamic> jsonData)
      : page = jsonData['page'],
        id = jsonData['id'],
        posterPath = jsonData['poster_path'],
        releaseDate = jsonData['release_date'],
        title = jsonData['title'],
        voteAverage = jsonData['vote_average'].toDouble(),
        video = jsonData['video'] == 1 ? true : false,
        listGenreIds = List<int>.from(
            json.decode(jsonData['genre_ids']).map((model) => model)),
        listGenres = List<GenreModel>.from(json
            .decode(jsonData['genres'])
            .map((model) => GenreModel.fromJson(model))),
        favourite = jsonData['favourite'] == 1 ? true : false;

  Map<String, dynamic> toDatabaseJson() => <String, dynamic>{
        'id': id,
        'poster_path': posterPath,
        'release_date': releaseDate,
        'title': title,
        'video': video ? 1 : 0,
        'vote_average': voteAverage,
        'favourite': favourite ? 1 : 0,
      };
}
