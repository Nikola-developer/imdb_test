import 'dart:convert';

import 'package:imdb_test/api/send_request.dart';
import 'package:imdb_test/models/movie_model.dart';
import 'package:imdb_test/models/response_model.dart';

Future<MyResponseModel> getMovieDetails(int id_movie, int page) async {
  MyResponseModel response = await sendRequest('/3/movie/$id_movie?api_key=b8d7f76947904a011286dc732c55234e&language=en_US&page=$page');

  if (response.errorCode == 0) {
    print('sendRequest - json.decode(response.data): ${json.decode(response.data)}');

    /// TODO - Proveri sa njima, ali za sad preuzima samo "overview"
    return MyResponseModel(data: json.decode(response.data)['overview']);
  } else {
    return response;
  }
}
