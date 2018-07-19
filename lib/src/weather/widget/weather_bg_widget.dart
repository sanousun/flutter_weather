import 'package:flutter/material.dart';

import 'weather_widget.dart';

class WeatherBgWidget extends StatelessWidget {
  WeatherBgWidget({
    this.child,
    this.weatherKind = WeatherKind.clear,
    this.isNight = false,
    this.opacity = 1.0,
  });

  final Widget child;
  final WeatherKind weatherKind;
  final bool isNight;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: isNight ? Colors.black : Colors.white,
        ),
        Opacity(
          opacity: opacity,
          child: _buildWeatherBg(context),
        ),
        child,
      ],
    );
  }

  Widget _buildWeatherBg(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return WeatherWidget(screenSize, weatherKind, isNight);
  }
}

enum WeatherKind {
  kind_null,

  /// 晴
  clear,

  /// 多云
  cloud,

  /// 阴
  cloudy,

  /// 雨
  rainy,

  /// 雪
  snow,

  /// 雨夹雪
  sleet,

  /// 冰雹
  hail,

  /// 雾
  fog,

  /// 雾霾
  haze,

  /// 打雷
  thunder,

  /// 雷雨
  thunder_storm,

  /// 风沙
  wind
}

Color getBackgroundColor(WeatherKind weatherKind, bool isNight) {
  Color backgroundColor = Colors.white;
  switch (weatherKind) {
    case WeatherKind.clear:
      if (isNight) {
        backgroundColor = Color.fromRGBO(34, 45, 67, 1.0);
      } else {
        backgroundColor = Color.fromRGBO(253, 188, 76, 1.0);
      }
      break;
    case WeatherKind.cloud:
      if (isNight) {
        backgroundColor = Color.fromRGBO(34, 45, 67, 1.0);
      } else {
        backgroundColor = Color.fromRGBO(0, 165, 217, 1.0);
      }
      break;
    case WeatherKind.cloudy:
      backgroundColor = Color.fromRGBO(96, 121, 136, 1.0);
      break;
    case WeatherKind.thunder:
    case WeatherKind.thunder_storm:
      backgroundColor = Color.fromRGBO(43, 29, 69, 1.0);
      break;
    case WeatherKind.rainy:
      if (isNight) {
        backgroundColor = Color.fromRGBO(38, 78, 143, 1.0);
      } else {
        backgroundColor = Color.fromRGBO(64, 151, 231, 1.0);
      }
      break;
    case WeatherKind.thunder_storm:
      backgroundColor = Color.fromRGBO(43, 29, 69, 1.0);
      break;
    case WeatherKind.sleet:
      if (isNight) {
        backgroundColor = Color.fromRGBO(26, 91, 146, 1.0);
      } else {
        backgroundColor = Color.fromRGBO(104, 186, 255, 1.0);
      }
      break;
    case WeatherKind.wind:
      backgroundColor = Color.fromRGBO(233, 158, 60, 1.0);
      break;
    case WeatherKind.snow:
      if (isNight) {
        backgroundColor = Color.fromRGBO(26, 91, 146, 1.0);
      } else {
        backgroundColor = Color.fromRGBO(104, 186, 255, 1.0);
      }
      break;
    case WeatherKind.hail:
      if (isNight) {
        backgroundColor = Color.fromRGBO(42, 52, 69, 1.0);
      } else {
        backgroundColor = Color.fromRGBO(80, 116, 193, 1.0);
      }
      break;
    case WeatherKind.fog:
      backgroundColor = Color.fromRGBO(84, 100, 121, 1.0);
      break;
    case WeatherKind.haze:
      backgroundColor = Color.fromRGBO(66, 66, 66, 1.0);
      break;
    default:
  }
  return backgroundColor;
}
