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
      GlobalKey<RefreshIndicatorState>();

  double currentOffset;
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
      weatherKind: weatherNow == null ? WeatherKind.clear : _getWeatherKind(),
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
          child: NotificationListener<ScrollNotification>(
            child: ListView(
              children: _buildWeatherList(),
            ),
            onNotification: (scrollInfo) {
              print(scrollInfo.metrics.pixels);
              print(scrollInfo.metrics.maxScrollExtent);
            },
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
          child: Text(" "),
        ),
      ];
    } else {
      return <Widget>[
        SizedBox(
          height: 660.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "${weatherNow.condTxt}",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "${weatherNow.tmp}℃",
            style: TextStyle(
              fontSize: 64.0,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "${weatherNow.windDir} ${weatherNow.windScDesc}",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      ];
    }
  }

  WeatherKind _getWeatherKind() {
    switch (weatherNow.condCode) {
      case "100":
        return WeatherKind.clear;
      case "101":
      case "102":
      case "103":
        return WeatherKind.cloud;
      case "104":
        return WeatherKind.cloudy;
      case "200":
      case "201":
      case "202":
      case "203":
        return WeatherKind.clear;
      case "204":
      case "205":
      case "206":
      case "207":
      case "208":
      case "209":
      case "210":
      case "211":
      case "212":
      case "213":
        return WeatherKind.wind;
      case "302":
        return WeatherKind.thunder;
      case "303":
        return WeatherKind.thunder_storm;
      case "304":
        return WeatherKind.hail;
      case "300":
      case "301":
      case "305":
      case "306":
      case "307":
      case "308":
      case "309":
      case "310":
      case "311":
      case "312":
      case "313":
        return WeatherKind.rainy;
      case "400":
      case "401":
      case "402":
      case "403":
      case "404":
      case "405":
      case "406":
      case "407":
        return WeatherKind.snow;
      case "500":
      case "501":
        return WeatherKind.fog;
      case "502":
        return WeatherKind.haze;
      case "503":
      case "504":
      case "505":
      case "506":
      case "507":
      case "508":
        return WeatherKind.wind;
      default:
        return WeatherKind.clear;
    }
  }
}
