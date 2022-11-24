import 'package:flutter/material.dart';
import 'package:imdb_test/models/movie_model.dart';
import 'package:imdb_test/theme/colors.dart';

class MovieListItem extends StatefulWidget {
  MovieListItem({super.key, required this.movie});

  MovieModel movie;

  @override
  State<MovieListItem> createState() => _MovieListItemState();
}

class _MovieListItemState extends State<MovieListItem> {
  _listGenres() {
    return SizedBox(
      height: 27,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.movie.listGenres!.length,
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
                    widget.movie.listGenres![index].name,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('https://image.tmdb.org/t/p/w500${widget.movie.posterPath}');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 16),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.movie.page!.toString(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              widget.movie.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: SecondaryColor),
                const SizedBox(width: 5.33),
                Text(
                  '${widget.movie.voteAverage} / 10 IMDb',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _listGenres(),
          ],
        )),
      ],
    );
  }
}
