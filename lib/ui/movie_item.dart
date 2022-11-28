import 'package:flutter/material.dart';
import 'package:imdb_test/models/movie_model.dart';
import 'package:imdb_test/theme/colors.dart';
import 'package:imdb_test/ui/common_widgets/genres_list.dart';
import 'package:imdb_test/ui/common_widgets/icon_favourite.dart';
import 'package:imdb_test/ui/movie_detail_page.dart';

class MovieListItem extends StatefulWidget {
  MovieListItem({super.key, required this.movie, this.setListState});

  MovieModel movie;
  VoidCallback? setListState;

  @override
  State<MovieListItem> createState() => _MovieListItemState();
}

class _MovieListItemState extends State<MovieListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var res = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MovieDetailPage(movie: widget.movie)),
        );
        if(widget.setListState != null){
          widget.setListState!();
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: '${widget.movie.id}_heroTag',
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/logo.png',
                height: 100,
                width: 100,
              ),
            ),
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
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 27,
                  child: GenresList(listGenres: widget.movie.listGenres!),
                ),
              ],
            ),
          ),
          IconFavourite(movie: widget.movie, setListState: widget.setListState),
        ],
      ),
    );
  }
}
