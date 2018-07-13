import 'package:flutter/material.dart';
import 'weather_widget.dart';

class WeatherBgWidget extends StatelessWidget {
  WeatherBgWidget({this.child, this.weatherKind, this.isNight});

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
