import 'dart:async';

import 'package:flutter/material.dart';

import 'widget/weather_bg_widget.dart';

import '../api/api.dart';
import '../models/weather.dart';
import '../city/city_page.dart';

class WeatherPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  String location = "杭州";
  WeatherNow weatherNow;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return WeatherBgWidget(
      weatherKind: WeatherKind.clear,
      isNight: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text(location),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.location_city),
              onPressed: () {
                Navigator.of(context).pushNamed(CityPage.routeName);
              },
            ),
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {},
            )
          ],
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          child: ListView(
            children: _buildWeatherList(),
          ),
          onRefresh: _handleRefresh,
        ),
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    _refreshIndicatorKey.currentState?.show();
    final wn = await getWeatherNow(location);
    setState(() {
      weatherNow = wn;
    });
  }

  List<Widget> _buildWeatherList() {
    if (weatherNow == null) {
      return <Widget>[
        Center(
          child: Text("null"),
        ),
      ];
    } else {
      return <Widget>[
        Center(
          child: Text(weatherNow.condTxt),
        ),
      ];
    }
  }
}
