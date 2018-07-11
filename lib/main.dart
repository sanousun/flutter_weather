import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'src/weather/weather_bg_widget.dart';

void main() {
//  debugPaintSizeEnabled = true;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return WeatherBgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text(
            "Weather Demo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      ),
      weatherKind: WeatherKind.wind,
      isNight: false,
    );
  }
}
