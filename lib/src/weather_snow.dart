import 'package:flutter/material.dart';
import 'weather_element.dart';

class WeatherSnowWidget extends StatefulWidget {
  WeatherSnowWidget(this.screenSize, this.isNight);

  final Size screenSize;
  final bool isNight;

  @override
  State<StatefulWidget> createState() => _WeatherSnowState();
}

class _WeatherSnowState extends State<WeatherSnowWidget>
    with TickerProviderStateMixin {
  List<Snow> snows = <Snow>[];
  Color backgroundColor;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    List<Color> colors;
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
    List<double> scales = <double>[0.6, 0.8, 1.0];
    for (int i = 0; i < 51; i++) {
      snows.add(Snow(
        color: colors[i % 3],
        scale: scales[i % 3],
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
            for (Snow s in snows) {
              s.update(32);
            }
          });
        }
      });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SnowPainter(snows, backgroundColor),
      child: ConstrainedBox(constraints: BoxConstraints.expand()),
    );
  }
}

class _SnowPainter extends CustomPainter {
  _SnowPainter(this.snows, this.backgroundColor);

  List<Snow> snows;
  Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    Rect sizeRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    paint.color = backgroundColor;
    canvas.drawRect(sizeRect, paint);

    for (Snow s in snows) {
      paint.color = s.color;
      canvas.drawCircle(s.center, s.radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
