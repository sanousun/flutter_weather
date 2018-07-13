import 'dart:async';

import 'package:flutter/material.dart';

import 'widget/weather_bg_widget.dart';

import '../api/api.dart';
import '../models/weather.dart';
import '../models/life_style.dart';
import '../city/city_page.dart';

class WeatherPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _ScaffoldKey = GlobalKey<ScaffoldState>();

  double currentOffset;
  String location = "杭州";
  Weather weather;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return WeatherBgWidget(
      weatherKind: weather?.weatherNow?.getWeatherKind() ?? WeatherKind.clear,
      isNight: false,
      child: Scaffold(
        key: _ScaffoldKey,
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
    getWeatherNow(location).then(
        (weather) => setState(() {
              this.weather = weather;
            }), onError: (e) {
      _ScaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    });
  }

  List<Widget> _buildWeatherList() {
    if (weather == null) {
      return <Widget>[
        Center(
          child: Text(" "),
        ),
      ];
    } else {
      return <Widget>[
        SizedBox(
          height: 320.0,
        ),
        _buildWeatherNow(weather.weatherNow),
        const SizedBox(
          height: 56.0,
        ),
        Container(
          height: 160.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: weather.weatherHourlys
                .map((weatherHourly) => _buildHourly(weatherHourly))
                .toList(),
          ),
        ),
        const SizedBox(
          height: 32.0,
        ),
        Column(
          children: weather.weatherForecasts
              .map((weatherForecast) => _buildWeatherForecast(weatherForecast))
              .toList(),
        ),
        const SizedBox(
          height: 16.0,
        ),
        Column(
          children: weather.lifeStyles
              .map((lifeStyle) => _buildLifeStyle(lifeStyle))
              .toList(),
        )
      ];
    }
  }

  Widget _buildWeatherNow(WeatherNow weatherNow) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "${weather.weatherNow.condTxt}",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        Text(
          "${weather.weatherNow.tmp}℃",
          style: TextStyle(
            fontSize: 64.0,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        Text(
          "${weather.weatherNow.windDir} ${weather.weatherNow.windScDesc}",
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.white.withOpacity(0.8),
          ),
        )
      ],
    );
  }

  Widget _buildHourly(WeatherHourly weatherHourly) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            weatherHourly.time.substring(10),
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          SizedBox(
            width: 32.0,
            height: 32.0,
            child: Image.asset('icons/${weatherHourly.condCode}.png'),
          ),
          SizedBox(
            height: 2.0,
          ),
          Text(
            "${weatherHourly.tmp}℃",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherForecast(WeatherForecast weatherForecast) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            weatherForecast.date,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Container(
                height: 48.0,
                width: 48.0,
                padding: EdgeInsets.all(8.0),
                child: Image.asset('icons/${weatherForecast.condCodeD}.png')),
          ),
          Text(
            "${weatherForecast.tmpMax}℃/${weatherForecast.tmpMin}℃",
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLifeStyle(LifeStyle lifeStyle) {
    return ListTile(
      title: Text(lifeStyle.brf),
      subtitle: Text(lifeStyle.txt),
    );
  }
}
