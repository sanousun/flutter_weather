import 'package:flutter/material.dart';
import 'weather_element.dart';
import 'dart:math';

class WeatherCloudyWidget extends StatefulWidget {
  WeatherCloudyWidget(this.width, this.height);

  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() => _WeatherCloudyState();
}

class _WeatherCloudyState extends State<WeatherCloudyWidget>
    with SingleTickerProviderStateMixin {
  List<Cloud> clouds = <Cloud>[];
  List<Star> stars = <Star>[];
  Thunder thunder = Thunder();
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    double width = widget.width;
    double height = widget.height;
    clouds.add(Cloud(
      centerX: width * 0.1529,
      centerY: (width * 0.1529 * 0.5568 + width * 0.050),
      initRadius: width * 0.2649,
      scaleRatio: 1.20,
      baseColor: Color.fromRGBO(151, 168, 202, 1.0),
      alpha: 0.4,
      initProgress: 0,
      duration: 7000,
    ));
    Random r = new Random();
    double canvasSize = pow(pow(width, 2) + pow(height, 2), 0.5);
    int w = canvasSize.floor();
    int h = ((canvasSize - height) * 0.5 + width * 1.1111).floor();
    int radius = (0.0028 * width).floor();
    Color color = Color.fromRGBO(255, 255, 255, 1.0);
    for (int i = 0; i < 30; i++) {
      int x = r.nextInt(w) - (0.5 * (canvasSize - width)).floor();
      int y = r.nextInt(h) - (0.5 * (canvasSize - height)).floor();
      bool newPosition = true;
      for (int j = 0; j < i; j++) {
        if (stars[j].center.dx == x && stars[j].center.dy == y) {
          newPosition = false;
          break;
        }
      }
      if (newPosition) {
        int duration = 1500 + r.nextInt(3) * 500;
        stars.add(Star(
            centerX: x,
            centerY: y,
            initRadius: radius,
            baseColor: color,
            initProgress: r.nextInt(duration),
            duration: duration));
      } else {
        i--;
      }
    }
    _animationController = AnimationController(
      duration: Duration(milliseconds: 32),
      vsync: this,
    )..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
          setState(() {
            thunder.update(16);
            for (Star s in stars) {
              s.update(16);
            }
            for (Cloud c in clouds) {
              c.update(16);
            }
          });
        }
      });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WeatherCloudyPainter(
        clouds,
        stars,
        thunder,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
      ),
    );
  }
}

class _WeatherCloudyPainter extends CustomPainter {
  _WeatherCloudyPainter(this.clouds, this.stars, this.thunder);

  List<Cloud> clouds;
  List<Star> stars;
  Thunder thunder;

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

    for (Cloud c in clouds) {
      paint.color = c.color;
      canvas.drawCircle(c.center, c.radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
