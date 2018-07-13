import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/city.dart';
import '../models/weather.dart';

Future<List<City>> areaSearch(String location) async {
  final uri = Uri.https('search.heweather.com', '/find', {
    'key': '255bfaa117cd42799e185957e9714916',
    'location': location,
  });
  print(uri.toString());
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    final res = json.decode(response.body);
    final data = res['HeWeather6'][0];
    String status = data['status'];
    if (status == 'ok') {
      return (data['basic'] as List)
          .map((basic) => City.fromJson(basic))
          .toList();
    } else {
      throw Exception((data['status'] as String));
    }
  } else {
    throw Exception(response.statusCode);
  }
}

Future<WeatherNow> getWeatherNow(String location) async {
  final uri = Uri.https('free-api.heweather.com', '/s6/weather/now', {
    'key': '255bfaa117cd42799e185957e9714916',
    'location': location,
  });
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    final res = json.decode(response.body);
    final data = res['HeWeather6'][0];
    String status = data['status'];
    if (status == 'ok') {
      return WeatherNow.fromJson(data['now']);
    } else {
      throw Exception((data['status'] as String));
    }
  } else {
    throw Exception(response.statusCode);
  }
}
