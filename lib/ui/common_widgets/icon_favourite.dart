import 'package:flutter/material.dart';
import 'package:imdb_test/database/dao/movie_dao.dart';
import 'package:imdb_test/models/movie_model.dart';
import 'package:imdb_test/theme/colors.dart';

class IconFavourite extends StatefulWidget {
  IconFavourite({super.key, required this.movie});

  MovieModel movie;

  @override
  State<IconFavourite> createState() => _IconFavouriteState();
}

class _IconFavouriteState extends State<IconFavourite> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        widget.movie.favourite = !widget.movie.favourite;
        if (!await MovieDao()
            .toggleFavourite(widget.movie.id, widget.movie.favourite ? 1 : 0)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong!'),
            ),
          );
        }
        setState(() {});
      },
      child: widget.movie.favourite
          ? const Icon(Icons.bookmark_added, color: SecondaryColor)
          : const Icon(Icons.bookmark_border),
    );
  }
}
