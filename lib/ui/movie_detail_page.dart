import 'package:flutter/material.dart';
import 'package:imdb_test/api/get_movie_details.dart';
import 'package:imdb_test/models/movie_model.dart';
import 'package:imdb_test/models/response_model.dart';
import 'package:imdb_test/theme/colors.dart';
import 'package:imdb_test/ui/common_widgets/genres_list.dart';
import 'package:imdb_test/ui/common_widgets/icon_favourite.dart';

class MovieDetailPage extends StatefulWidget {
  MovieDetailPage({super.key, required this.movie});

  MovieModel movie;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  double imageHeight = 314;

  @override
  void initState() {
    super.initState();
    _loadMovieDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              child: Hero(
                tag: '${widget.movie.id}_heroTag',
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 36,
              left: 24,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Image.asset('assets/images/arrow_back.png'),
                ),
              ),
            ),
            Positioned(
              top: imageHeight,
              child: Container(
                height: MediaQuery.of(context).size.height - imageHeight,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: BackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                padding: EdgeInsets.fromLTRB(20, 28, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.movie.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconFavourite(movie: widget.movie),
                      ],
                    ),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 27,
                      child: GenresList(
                          listGenres: widget.movie.listGenres!, fontSize: 12),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Description',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _movieDetails(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadMovieDetails() async {
    MyResponseModel responseMovieDetails =
        await getMovieDetails(widget.movie.id, widget.movie.page!);
    if (responseMovieDetails.errorCode == 0) {
      widget.movie.overview = responseMovieDetails.data;
    } else {
      widget.movie.overview = responseMovieDetails.errorText;
    }
    setState(() {});
  }

  _movieDetails() {
    return widget.movie.overview == null
        ? const Center(child: CircularProgressIndicator(color: PrimaryColor))
        : Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    widget.movie.overview!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
