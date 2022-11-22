import 'dart:convert';

import 'package:imdb_test/api/send_request.dart';
import 'package:imdb_test/models/movie_model.dart';
import 'package:imdb_test/models/response_model.dart';

Future<MyResponseModel> getMoviesList(int page) async {
  MyResponseModel response = await sendRequest('/3/movie/popular?api_key=b8d7f76947904a011286dc732c55234e&language=en_US&page=$page');

  if (response.errorCode == 0) {
    List<MovieModel> list = List<MovieModel>.from(json.decode(response.data)['results'].map((model) => MovieModel.fromJson(model)));

    return MyResponseModel(data: list);
  } else {
    return response;
  }
}
