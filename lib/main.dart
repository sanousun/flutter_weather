import 'package:flutter/material.dart';

import 'src/city/city_page.dart';
import 'src/city/city_search_page.dart';
import 'src/city/city_provider.dart';

import 'src/weather/weather_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CityProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        routes: {
          '/': (context) => WeatherPage(),
          CityPage.routeName: (context) => CityPage(),
          CitySearchPage.routeName: (context) => CitySearchPage(),
        },
      ),
    );
  }
}
