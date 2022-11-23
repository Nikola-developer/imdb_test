import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imdb_test/api/get_genre_list.dart';
import 'package:imdb_test/api/get_movie_details.dart';
import 'package:imdb_test/api/get_movies_list.dart';
import 'package:imdb_test/database/dao/genre_dao.dart';
import 'package:imdb_test/database/dao/movie_dao.dart';
import 'package:imdb_test/main.dart';
import 'package:imdb_test/models/movie_model.dart';
import 'package:imdb_test/models/response_model.dart';
import 'package:imdb_test/theme/colors.dart';

class MovieList extends StatefulWidget {
  MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  int _page = 0;
  late List<MovieModel> listMovies;

  late ScrollController _controller;
  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  void _loadMore() async {
    if (_hasNextPage &&
        !_isFirstLoadRunning &&
        !_isLoadMoreRunning &&
        _controller.position.extentAfter < 500) {
      _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      setState(() {});

      List<MovieModel> fetchedMovies = await getDataList();
      setState(() {});

      if (fetchedMovies.isNotEmpty) {
        listMovies.addAll(fetchedMovies);
        setState(() {});
      } else {
        _hasNextPage = false;
        setState(() {});
      }

      _isLoadMoreRunning = false;
      setState(() {});
    }
  }

  void _firstLoad() async {
    _isFirstLoadRunning = true;
    setState(() {});

    listMovies = await getDataList();
    setState(() {});

    _isFirstLoadRunning = false;
    setState(() {});
  }

  Future<List<MovieModel>> getDataList() async {
    late List<MovieModel> fechedMovies;
    fechedMovies = await MovieDao().readData(_page);
    _page += 2; // Increase _page by 2
    print('fechedMovies : $fechedMovies');

    /// Fetch new data only when not on favourites page
    // if (!widget.favouritesOnly && fechedMovies.isEmpty) {
    if (fechedMovies.isEmpty) {
      MyResponseModel response = await getMoviesList(_page);
      if (response.errorCode == 0) {
        fechedMovies = response.data;
        setState(() {});

        for (var movie in fechedMovies) {
          if (!await MovieDao().insertData(movie)) {
            /// todo Prikazi gresku
          }
        }

        /// todo Cita iz baze da bi vezao 'genres'
        print('Cita iz baze da bi vezao genres');
        fechedMovies = [];
        fechedMovies = await MovieDao().readData(_page-2);
        print('fechedMovies : $fechedMovies');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.errorText),
          ),
        );
      }
    }

    return fechedMovies;
  }

  @override
  Widget build(BuildContext context) {
    return _isFirstLoadRunning
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [ Expanded(
                child:
                ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: listMovies.length,
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  return MovieListItem(movie: listMovies[index]);
                },
              ),
              ),
              // if (!favouritesOnly && !_hasNextPage)
              if (!_hasNextPage)
                Container(
                  padding: const EdgeInsets.only(top: 30, bottom: 40),
                  color: Colors.amber,
                  child: const Center(
                    child: Text('You have fetched all of the content'),
                  ),
                ),
            ],
          );
  }
}

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
    print('https://image.tmdb.org/t/p/w500${widget.movie.posterPath}');
    return Column(
      children: [
        const SizedBox(height: myPadding),
        Row(
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
        )
      ],
    );
  }
}
