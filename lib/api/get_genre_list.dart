import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:imdb_test/api/send_request.dart';
import 'package:imdb_test/models/genre_model.dart';
import 'package:imdb_test/models/movie_model.dart';
import 'package:imdb_test/models/response_model.dart';

Future<MyResponseModel> getGenreList() async {
  MyResponseModel response = await sendRequest(
    '/3/genre/movie/list',
    headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiOGQ3Zjc2OTQ3OTA0YTAxMTI4NmRjNzMyYzU1MjM0ZSIsInN1YiI6IjYwMzM3ODBiMTEzODZjMDAzZjk0ZmM2YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XYuIrLxvowrkevwKx-KhOiOGZ2Tn-R8tEksXq842kX4'
    },
  );

  if (response.errorCode == 0) {
    List<GenreModel> list = List<GenreModel>.from(json.decode(response.data)['genres'].map((model) => GenreModel.fromJson(model)));

    return MyResponseModel(data: list);
  } else {
    return response;
  }
}
