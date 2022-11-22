class GenreModel {
  int id;
  String name;

  GenreModel({
    required this.id,
    required this.name,
  });

  GenreModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toDatabaseJson() => <String, dynamic>{
        'id': id,
        'name': name,
      };
}
