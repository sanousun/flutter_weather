import 'package:flutter/material.dart';
import 'weather_clear.dart';
import 'weather_cloud.dart';
import 'weather_rain.dart';
import 'weather_hail.dart';
import 'weather_snow.dart';
import 'weather_meteor_show.dart';
import 'weather_wind.dart';
import 'weather_smog.dart';

class WeatherWidget extends StatelessWidget {
  WeatherWidget({this.child, this.weatherKind, this.isNight});

  final Widget child;
  final WeatherKind weatherKind;
  final bool isNight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildWeatherBg(context),
        child,
      ],
    );
  }

  Widget _buildWeatherBg(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    switch (weatherKind) {
      case WeatherKind.clear:
        if (isNight) {
          return WeatherMeteorShowWidget(screenSize);
        } else {
          return WeatherClearWidget();
        }
        break;
      case WeatherKind.cloud:
      case WeatherKind.cloudy:
      case WeatherKind.thunder:
        return WeatherCloudWidget(screenSize, isNight, weatherKind);
      case WeatherKind.rainy:
      case WeatherKind.thunder_storm:
      case WeatherKind.sleet:
        return WeatherRainWidget(screenSize, isNight, weatherKind);
      case WeatherKind.snow:
        return WeatherSnowWidget(screenSize, isNight);
      case WeatherKind.hail:
        return WeatherHailWidget(screenSize, isNight);
      case WeatherKind.fog:
      case WeatherKind.haze:
        return WeatherSmogWidget(screenSize, weatherKind);
      case WeatherKind.wind:
        return WeatherWindWidget(screenSize);
      case WeatherKind.kind_null:
      default:
        return null;
    }
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
