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
import 'package:imdb_test/ui/movie_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<void> _incrementCounter() async {
    // List<MovieModel> listMovies = [];
    // listMovies = await MovieDao().readData(1);
    //
    // listMovies.forEach((movie) {
    //   print('movie - responseGenre.error_code: ${movie.id}');
    //   print('movie - responseGenre.error_code: ${movie.listGenres}');
    // });
    //
    // return;

    /// Todo - baza
    /// Insert radi dobro (Proveri da li je upisao sve redove za vezu)
    /// Proveri da li lepo radi SELECT (vidi kako ce da konvertuje bool???)
    ///

    MyResponseModel responseGenre = await getGenreList();
    if (kDebugMode) {
      print(
          '_incrementCounter - responseGenre.error_code: ${responseGenre.errorCode}');
      print(
          '_incrementCounter - responseGenre.error_text: ${responseGenre.errorText}');
    }
    if (responseGenre.errorCode == 0) {
      for (var data in responseGenre.data) {
        GenreDao().insertData(data);
      }
    }

    // MyResponseModel responseMoviesList = await getMoviesList(1);
    // if (responseMoviesList.errorCode == 0) {
    //   for (var data in responseMoviesList.data) {
    //     if (!await MovieDao().insertData(data)) {
    //       /// todo Prikazi gresku
    //     }
    //   }
    // }
    // if (kDebugMode) {
    //   print(
    //       '_incrementCounter - responseMoviesList.error_code: ${responseMoviesList.errorCode}');
    //   print(
    //       '_incrementCounter - responseMoviesList.error_text: ${responseMoviesList.errorText}');
    // }
    // MyResponseModel responseMovieDetails = await getMovieDetails(508947, 1);
    // if (kDebugMode) {
    //   print(
    //       '_incrementCounter - responseMovieDetails.error_code: ${responseMovieDetails.errorCode}');
    //   print(
    //       '_incrementCounter - responseMovieDetails.error_text: ${responseMovieDetails.errorText}');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 23.2),
            Image.asset('assets/images/logo.png',
                height: 28, width: 28, fit: BoxFit.fitWidth)
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(myPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Popular',
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: MovieList(),
            )

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}