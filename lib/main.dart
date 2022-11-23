import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:imdb_test/api/get_genre_list.dart';
import 'package:imdb_test/api/get_movie_details.dart';
import 'package:imdb_test/api/get_movies_list.dart';
import 'package:imdb_test/database/dao/genre_dao.dart';
import 'package:imdb_test/database/dao/movie_dao.dart';
import 'package:imdb_test/models/movie_model.dart';
import 'package:imdb_test/models/response_model.dart';
import 'package:imdb_test/theme/themes.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: MyThemeData(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<void> _incrementCounter() async {


    List<MovieModel> listMovies = [];
    listMovies = await MovieDao().readData(1);

    listMovies.forEach((movie) {
      print('movie - responseGenre.error_code: ${movie.id}');
      print('movie - responseGenre.error_code: ${movie.listGenres}');
    });

    return;

    /// Todo - baza
    /// Insert radi dobro (Proveri da li je upisao sve redove za vezu)
    /// Proveri da li lepo radi SELECT (vidi kako ce da konvertuje bool???)
    ///

    MyResponseModel responseGenre = await getGenreList();
    if (kDebugMode) {
      print('_incrementCounter - responseGenre.error_code: ${responseGenre.errorCode}');
      print('_incrementCounter - responseGenre.error_text: ${responseGenre.errorText}');
    }
    if (responseGenre.errorCode == 0) {
      for (var data in responseGenre.data) {
        GenreDao().insertData(data);
      }
    }

    MyResponseModel responseMoviesList = await getMoviesList(1);
    if (responseMoviesList.errorCode == 0) {
      for (var data in responseMoviesList.data) {
        if(! await MovieDao().insertData(data)){
          /// todo Prikazi gresku
        }
      }
    }
    if (kDebugMode) {
      print('_incrementCounter - responseMoviesList.error_code: ${responseMoviesList.errorCode}');
      print('_incrementCounter - responseMoviesList.error_text: ${responseMoviesList.errorText}');
    }
    MyResponseModel responseMovieDetails = await getMovieDetails(508947, 1);
    if (kDebugMode) {
      print('_incrementCounter - responseMovieDetails.error_code: ${responseMovieDetails.errorCode}');
      print('_incrementCounter - responseMovieDetails.error_text: ${responseMovieDetails.errorText}');
    }
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [SizedBox(width: 23.2), Image.asset('assets/images/logo.png', height: 28, width: 28, fit: BoxFit.fitWidth)],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
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
