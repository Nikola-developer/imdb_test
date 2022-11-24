import 'package:flutter/material.dart';
import 'package:imdb_test/models/genre_model.dart';
import 'package:imdb_test/models/movie_model.dart';
import 'package:imdb_test/theme/colors.dart';
import 'package:imdb_test/ui/movie_detail_page.dart';

class GenresList extends StatelessWidget {
  GenresList({super.key, required this.listGenres, this.fontSize = 11});

  List<GenreModel> listGenres;
  double fontSize;

  @override
  Widget build(BuildContext context) {
    // print('https://image.tmdb.org/t/p/w500${widget.movie.posterPath}');
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: listGenres.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            const SizedBox(width: 4),
            Container(
                decoration: BoxDecoration(
                  color: PrimaryColor.withOpacity(.2),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                child: Text(
                  listGenres[index].name,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                )),
          ],
        );
      },
    );
  }
}
