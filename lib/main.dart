import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'src/city/city_page.dart';
import 'src/city/city_search_page.dart';
import 'src/city/city_provider.dart';

import 'src/weather/weather_page.dart';

void main() {
//  debugPaintSizeEnabled=true;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime morning = DateTime(now.year, now.month, now.day, 7);
    DateTime night = DateTime(now.year, now.month, now.day, 19);
    bool isNight = !(now.isAfter(morning) && now.isBefore(night));
    return CityProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: isNight ? Brightness.dark : Brightness.light,
        ),
        routes: {
          '/': (context) => WeatherPage(isNight),
          CityPage.routeName: (context) => CityPage(),
          CitySearchPage.routeName: (context) => CitySearchPage(),
        },
      ),
    );
  }
}
