import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sports_app/News.dart';


Future<List<News>> fetchLink(http.Client client) async {
  final response = await client
      .get('http://newsapi.org/v2/top-headlines?country=tr&category=sports&apiKey=194ac3d346bd45dca4cbe88b9a3351f3');

       var responseJson = json.decode(response.body);
  return (responseJson['articles'] as List)
      .map((p) => News.fromJson(p))
      .toList();
}