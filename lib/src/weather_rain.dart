import 'package:flutter/material.dart';
import 'weather_element.dart';
import 'weather_widget.dart';

class WeatherRainWidget extends StatefulWidget {
  WeatherRainWidget(this.screenSize, this.isNight, this.weatherKind);

  final Size screenSize;
  final bool isNight;
  final WeatherKind weatherKind;

  @override
  State<StatefulWidget> createState() => _WeatherRainState();
}

class _WeatherRainState extends State<WeatherRainWidget>
    with TickerProviderStateMixin {
  List<Rain> rains = <Rain>[];
  Thunder thunder;
  Color backgroundColor;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    List<Color> colors;
    int rainSize;
    switch (widget.weatherKind) {
      case WeatherKind.rainy:
        rainSize = 51;
        if (widget.isNight) {
          colors = <Color>[
            Color.fromRGBO(182, 142, 82, 1.0),
            Color.fromRGBO(88, 92, 113, 1.0),
            Color.fromRGBO(255, 255, 255, 1.0)
          ];
          backgroundColor = Color.fromRGBO(38, 78, 143, 1.0);
        } else {
          colors = <Color>[
            Color.fromRGBO(223, 179, 114, 1.0),
            Color.fromRGBO(152, 175, 222, 1.0),
            Color.fromRGBO(255, 255, 255, 1.0)
          ];
          backgroundColor = Color.fromRGBO(64, 151, 231, 1.0);
        }
        break;
      case WeatherKind.thunder_storm:
        rainSize = 45;
        thunder = Thunder();
        colors = <Color>[
          Color.fromRGBO(182, 142, 82, 1.0),
          Color.fromRGBO(88, 92, 113, 1.0),
          Color.fromRGBO(255, 255, 255, 1.0),
        ];
        backgroundColor = Color.fromRGBO(43, 29, 69, 1.0);
        break;
      case WeatherKind.sleet:
        rainSize = 45;
        if (widget.isNight) {
          colors = <Color>[
            Color.fromRGBO(40, 102, 155, 1.0),
            Color.fromRGBO(99, 144, 182, 1.0),
            Color.fromRGBO(255, 255, 255, 1.0)
          ];
          backgroundColor = Color.fromRGBO(26, 91, 146, 1.0);
        } else {
          colors = <Color>[
            Color.fromRGBO(128, 197, 255, 1.0),
            Color.fromRGBO(185, 222, 255, 1.0),
            Color.fromRGBO(255, 255, 255, 1.0)
          ];
          backgroundColor = Color.fromRGBO(104, 186, 255, 1.0);
        }
        break;
      default:
    }
    List<double> scales = <double>[0.6, 0.8, 1.0];
    for (int i = 0; i < rainSize; i++) {
      rains.add(Rain(
        color: colors[i % colors.length],
        scale: scales[i % scales.length],
        viewHeight: widget.screenSize.width,
        viewWidth: widget.screenSize.height,
      ));
    }

    _animationController = AnimationController(
      duration: Duration(milliseconds: 32),
      vsync: this,
    )..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
          setState(() {
            thunder?.update(32);
            for (Rain r in rains) {
              r.update(32);
            }
          });
        }
      });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RainPainter(backgroundColor, rains, thunder),
      child: ConstrainedBox(constraints: BoxConstraints.expand()),
    );
  }
}

class _RainPainter extends CustomPainter {
  _RainPainter(this.backgroundColor, this.rains, this.thunder);

  Color backgroundColor;
  List<Rain> rains;
  Thunder thunder;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    Rect sizeRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    paint.color = backgroundColor;
    canvas.drawRect(sizeRect, paint);

    for (Rain r in rains) {
      paint.color = r.color;
      canvas.drawRect(r.rect, paint);
    }
    if (thunder != null) {
      paint.color = thunder.color;
      canvas.drawRect(sizeRect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
