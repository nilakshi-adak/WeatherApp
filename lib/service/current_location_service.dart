import 'package:dio/dio.dart';
import 'package:flutter_application_1/constant/constant.dart';
import 'package:flutter_application_1/model/current.dart';

class CurrentLocationService {
  Future<CurrentLocation> getForecastData() async {
    final response = await Dio().get('${Constant.url}forecast.json?key=${Constant.key}&q=Tamluk&days=3');
    return CurrentLocation.fromJson(response.data);
  }
}
