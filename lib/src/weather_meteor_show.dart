import 'package:flutter/material.dart';
import 'weather_element.dart';
import 'dart:math';

class WeatherMeteorShowWidget extends StatefulWidget {
  WeatherMeteorShowWidget(this.screenSize);

  final Size screenSize;

  @override
  State<StatefulWidget> createState() => _WeatherMeteorShowState();
}

class _WeatherMeteorShowState extends State<WeatherMeteorShowWidget>
    with SingleTickerProviderStateMixin {
  List<Meteor> meteors = <Meteor>[];
  List<Star> stars = <Star>[];
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    double width = widget.screenSize.width;
    double height = widget.screenSize.height;
    List<Color> colors = <Color>[
      Color.fromRGBO(170, 215, 252, 1.0),
      Color.fromRGBO(255, 255, 255, 1.0),
      Color.fromRGBO(255, 255, 255, 1.0)
    ];
    List<double> scales = <double>[0.4, 0.7, 1.0];
    for (int i = 0; i < 15; i++) {
      meteors.add(Meteor(
        color: colors[i % 3],
        scale: scales[i % 3],
        viewHeight: widget.screenSize.width,
        viewWidth: widget.screenSize.height,
      ));
    }

    // star
    Random r = new Random();
    double canvasSize = pow(pow(width, 2) + pow(height, 2), 0.5);
    int w = canvasSize.floor();
    int h = ((canvasSize - height) * 0.5 + width * 1.1111).floor();
    int radius = (0.0028 * width).floor();
    Color color = Color.fromRGBO(255, 255, 255, 1.0);
    for (int i = 0; i < 30; i++) {
      double x = r.nextDouble() * w - 0.5 * (canvasSize - width);
      double y = r.nextDouble() * h - 0.5 * (canvasSize - height);
      int duration = 1500 + r.nextInt(3) * 500;
      stars.add(Star(
          centerX: x,
          centerY: y,
          initRadius: radius,
          baseColor: color,
          initProgress: r.nextInt(duration),
          duration: duration));
    }

    _animationController = AnimationController(
      duration: Duration(milliseconds: 32),
      vsync: this,
    )..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
          setState(() {
            for (Star s in stars) {
              s.update(16);
            }
            for (Meteor m in meteors) {
              m.update(16);
            }
          });
        }
      });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WeatherMeteorShowPainter(meteors, stars),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
      ),
    );
  }
}

class _WeatherMeteorShowPainter extends CustomPainter {
  _WeatherMeteorShowPainter(this.meteors, this.stars);

  List<Meteor> meteors;
  List<Star> stars;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    paint.color = Color.fromRGBO(34, 45, 67, 1.0);
    Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    canvas.drawRect(rect, paint);

    for (Star s in stars) {
      paint.color = s.color;
      canvas.drawCircle(s.center, s.radius, paint);
    }

    for (Meteor m in meteors) {
      paint.color = m.color;
      canvas.drawRect(m.rect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
