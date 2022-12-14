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
import 'package:imdb_test/ui/movie_item.dart';

class MovieList extends StatefulWidget {
  bool favouritesOnly = false;

  MovieList({this.favouritesOnly = false});

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

    await _checkGenres();

    listMovies = await getDataList();
    setState(() {});

    _isFirstLoadRunning = false;
    setState(() {});
  }

  Future<List<MovieModel>> getDataList() async {
    late List<MovieModel> fechedMovies;
    fechedMovies =
        await MovieDao().readData(_page, favouritesOnly: widget.favouritesOnly);
    _page += 2; // Increase _page by 2

    /// Fetch new data only when not on favourites page
    if (!widget.favouritesOnly && fechedMovies.isEmpty) {
      MyResponseModel response = await getMoviesList(_page);
      if (response.errorCode == 0) {
        fechedMovies = response.data;

        for (var movie in fechedMovies) {
          if (!await MovieDao().insertData(movie)) {
            /// todo Prikazi gresku
          }
        }

        /// todo Cita iz baze da bi vezao 'genres'
        fechedMovies = [];
        fechedMovies = await MovieDao().readData(_page - 2);
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

  setListState() async {
    if(widget.favouritesOnly){
      listMovies.removeWhere((movie) => !movie.favourite);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _isFirstLoadRunning
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              const SizedBox(height: myPadding),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: listMovies.length,
                  controller: _controller,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        if (index > 0) const SizedBox(height: myPadding),
                        MovieListItem(
                            movie: listMovies[index],
                            setListState:
                                // widget.favouritesOnly ? setListState : null)
                                setListState)
                      ],
                    );
                  },
                ),
              ),
              if (!widget.favouritesOnly && !_hasNextPage)
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

  Future<void> _checkGenres() async {
    if (!await GenreDao().checkHasData()) {
      MyResponseModel response = await getGenreList();
      if (response.errorCode == 0) {
        for (var data in response.data) {
          GenreDao().insertData(data);
        }
      }
    }
  }
}
