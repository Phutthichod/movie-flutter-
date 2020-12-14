import 'package:api_test/movie.dart';

import 'package:http/http.dart' as Http;
import 'dart:convert';

class MovieService {
  static Future<List<dynamic>> fetchMovie() async {
    var url = "http://localhost:3000/api/movies";
    var response = await Http.get(url);

    // print(json.decode(response.body));
    List list = json.decode(response.body);

    return list;
  }

  static List<dynamic> convertJsonToMovie(dynamic list) {
    // print(data);
    // List list = json.decode(data);
    list = list.map((m) {
      dynamic mm = Movie.fromJson(m);
      print(mm);
      if (mm != null) return mm;
    }).toList();
    return list;
  }

  static Future<List<dynamic>> deleteMovie({int id}) async {
    var url = "http://localhost:3000/api/movies/${id}";

    var response = await Http.delete(url);

    // print(json.decode(response.body));
    List list = json.decode(response.body);

    return list;
  }

  static Future<List<dynamic>> addMovie({String name, String type}) async {
    var url = "http://localhost:3000/api/movies";
    print("${name} ${type}");
    // var client = Http.Client();
    var response = await Http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'name': name, 'type': type}),
    );

    List list = json.decode(response.body);

    return list;
  }
}
