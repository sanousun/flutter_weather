import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'weather_canvas.dart';
import 'weather_bg_widget.dart';

class WeatherWidget extends StatefulWidget {
  WeatherWidget(this.screenSize, this.weatherKind, this.isNight);

  final Size screenSize;
  final WeatherKind weatherKind;
  final bool isNight;

  @override
  State<StatefulWidget> createState() => WeatherState();
}

class WeatherState extends State<WeatherWidget> with TickerProviderStateMixin {
  static const _platform =
      const MethodChannel('com.sanousun.flutterweather/sensor');

  AnimationController _animationController;
  WeatherCanvas _weatherCanvas;

  double rotation2D = 0.0;
  double rotation3D = 0.0;

  @override
  void initState() {
    super.initState();
    _weatherCanvas =
        WeatherCanvas(widget.screenSize, widget.weatherKind, widget.isNight);

    _platform.invokeMethod("registerSensor");
    _animationController = new AnimationController(
      duration: Duration(milliseconds: 32),
      vsync: this,
    )..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
          _getRotation();
          setState(() {
            _weatherCanvas.update(32, rotation2D, rotation3D);
          });
        }
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _platform.invokeMethod("unregisterSensor");
    _animationController.dispose();
  }

  void _getRotation() async {
    List<dynamic> rotation = await _platform.invokeMethod("getRotation");
    rotation2D = rotation[0];
    rotation3D = rotation[1];
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WeatherPainter(_weatherCanvas, rotation2D),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
      ),
    );
  }
}

class _WeatherPainter extends CustomPainter {
  _WeatherPainter(this.weatherCanvas, this.rotation2D);

  WeatherCanvas weatherCanvas;
  double rotation2D;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    weatherCanvas.paint(canvas, paint, rotation2D);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
