import 'package:flutter/material.dart';
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
  AnimationController _animationController;
  WeatherCanvas _weatherCanvas;

  @override
  void initState() {
    super.initState();
    _weatherCanvas =
        WeatherCanvas(widget.screenSize, widget.weatherKind, widget.isNight);
    _animationController = new AnimationController(
      duration: Duration(milliseconds: 32),
      vsync: this,
    )..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
          setState(() {
            _weatherCanvas.update();
          });
        }
      });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WeatherPainter(_weatherCanvas),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
      ),
    );
  }
}

class _WeatherPainter extends CustomPainter {
  _WeatherPainter(this.weatherCanvas);

  WeatherCanvas weatherCanvas;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    weatherCanvas.paint(canvas, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
