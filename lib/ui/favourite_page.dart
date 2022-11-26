import 'package:flutter/material.dart';
import 'package:imdb_test/ui/movie_list.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Favourites',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: MovieList(favouritesOnly: true),
        )
      ],
    );
  }
}
