class MovieModel {
  int id;
  String posterPath;
  String releaseDate;
  String title;
  bool video;
  double voteAverage;
  List<int> listGenreIds;

  List<int>? listGenres;

  bool favourite;

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

  MovieModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        posterPath = json['poster_path'],
        releaseDate = json['release_date'],
        title = json['title'],
        video = json['video'],
        voteAverage = json['vote_average'].toDouble(),
        listGenreIds = List<int>.from(json['genre_ids'].map((model) => model)),
        favourite = json['favourite'] ?? false;

  Map<String, dynamic> toDatabaseJson() => <String, dynamic>{
        'id': id,
        'poster_path': posterPath,
        'release_date': releaseDate,
        'title': title,
        'video': video,
        'vote_average': voteAverage,
        'genre_ids': listGenreIds,
        'favourite': favourite,
      };
}
