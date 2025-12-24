import 'package:dio/dio.dart';
import 'package:weatherapp/constant/constant.dart';
import 'package:weatherapp/model/current.dart';
import 'package:weatherapp/search/model/search_results.dart';

class WeatherService {
  Future<CurrentLocation> getForecastData(double lat, double long) async {
    final response = await Dio().get(
        '${StringConstant.url}forecast.json?key=${StringConstant.key}&q=${lat.toStringAsFixed(4)},${long.toStringAsFixed(4)}&days=3');
    return CurrentLocation.fromJson(response.data);
  }

  Future<List<SearchResult>> getSearchResults(String searchedText) async {
    final response = await Dio().get('${StringConstant.url}search.json?key=${StringConstant.key}&q=$searchedText');
    return searchResultFromJson(response.data);
  }
}
