import 'package:dio/dio.dart';
import 'package:flutter_application_1/constant/constant.dart';
import 'package:flutter_application_1/model/current.dart';
import 'package:flutter_application_1/search/model/search_results.dart';

class WeatherService {
  Future<CurrentLocation> getForecastData(double lat, double long) async {
    final response = await Dio().get(
        '${Constant.url}forecast.json?key=${Constant.key}&q=${lat.toStringAsFixed(4)},${long.toStringAsFixed(4)}&days=3');
    return CurrentLocation.fromJson(response.data);
  }

  Future<List<SearchResult>> getSearchResults(String searchedText) async {
    final response = await Dio().get('${Constant.url}search.json?key=${Constant.key}&q=$searchedText');
    return searchResultFromJson(response.data);
  }
}
