import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:imdb_test/models/response_model.dart';

Future<MyResponseModel> sendRequest(String url,
    {Map<String, String>? headers}) async {
  try {
  const String baseUrl = 'https://api.themoviedb.org';
  final res = await http.get(Uri.parse(baseUrl + url), headers: headers ?? {});

  if (kDebugMode) {
    print('sendRequest - res: $res');
  }

  if (res.statusCode == 200) {
    return MyResponseModel(data: res.body);
  } else {
    return MyResponseModel(errorCode: 1, errorText: 'Something went wrong!');
  }
  } catch (err) {
    if (kDebugMode) {
      print('Something went wrong! - getMoviesList - err: $err');
    }

    /// todo Check intenet connection
    return MyResponseModel(errorCode: 1, errorText: 'Something went wrong!');
  }
}
