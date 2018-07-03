import 'package:flutter/material.dart';

class WeatherSunnyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WeatherSunnyState();
}

class WeatherSunnyState extends State<WeatherSunnyWidget>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: WeatherSunnyPainter(count),
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
        ));
  }

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
      duration: Duration(milliseconds: 32),
      vsync: this,
    )..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
          setState(() {
            count++;
          });
        }
      });
    _animationController.forward();
  }
}

class WeatherSunnyPainter extends CustomPainter {
  WeatherSunnyPainter(this.count);

  static const REFRESH_INTERVAL = 8;

  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    paint.color = Color.fromARGB(255, 253, 188, 76);
    Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    canvas.drawRect(rect, paint);

    Color color = Color.fromRGBO(253, 84, 17, 1.0);
    List<double> angles = List();
    angles.add((90.0 * count / 30000 * REFRESH_INTERVAL) % 90);
    angles.add((90.0 * count / 40000 * REFRESH_INTERVAL) % 90);
    angles.add((90.0 * count / 50000 * REFRESH_INTERVAL) % 90);

    List<double> unitSizes = List();
    unitSizes.add(0.5 * 0.47 * size.width);
    unitSizes.add(1.7794 * unitSizes[0]);
    unitSizes.add(3.0594 * unitSizes[0]);

    canvas.translate(size.width, 0.0333 * size.width);
    paint.color = color.withOpacity(0.4);
    canvas.rotate(angles[0]);
    Rect rect0 =
        Rect.fromLTRB(-unitSizes[0], -unitSizes[0], unitSizes[0], unitSizes[0]);
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(rect0, paint);
      canvas.rotate(22.5);
    }
    canvas.rotate(-90 - angles[0]);

    paint.color = color.withOpacity(0.16);
    canvas.rotate(angles[1]);
    Rect rect1 =
        Rect.fromLTRB(-unitSizes[1], -unitSizes[1], unitSizes[1], unitSizes[1]);
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(rect1, paint);
      canvas.rotate(22.5);
    }
    canvas.rotate(-90 - angles[1]);

    Rect rect2 =
        Rect.fromLTRB(-unitSizes[2], -unitSizes[2], unitSizes[2], unitSizes[2]);
    paint.color = color.withOpacity(0.08);
    canvas.rotate(angles[2]);
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(rect2, paint);
      canvas.rotate(22.5);
    }
    canvas.rotate(-90 - angles[2]);
  }

  @override
  bool shouldRepaint(WeatherSunnyPainter old) => count != old.count;
}
