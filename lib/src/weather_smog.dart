import 'package:flutter/material.dart';
import 'weather_element.dart';

class WeatherSmogWidget extends StatefulWidget {
  WeatherSmogWidget(this.width, this.height);

  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() => _WeatherSmogState();
}

class _WeatherSmogState extends State<WeatherSmogWidget>
    with SingleTickerProviderStateMixin {
  List<Smog> smogs = <Smog>[];
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    double width = widget.width;
    double height = widget.height;

    double cX = (0.5000 * width);
    double cY = (1.2565 * width);
    Color color = Color.fromRGBO(66, 66, 66, 1.0);
    List<double> scales = <double>[0.4440, 0.5770, 0.7106, 0.8434, 0.9769];

    for (int i = 0; i < scales.length; i++) {
      smogs.add(Smog(
        centerX: cX,
        centerY: cY,
        initRadius: width * scales[i],
        baseColor: color,
        alpha: 0.05,
        initProgress: 0,
        duration: 5000,
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
            for (Smog c in smogs) {
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
      painter: _WeatherSmogPainter(smogs),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
      ),
    );
  }
}

class _WeatherSmogPainter extends CustomPainter {
  _WeatherSmogPainter(this.smogs);

  List<Smog> smogs;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    paint.color = Color.fromRGBO(84, 100, 121, 1.0);
    canvas.drawRect(rect, paint);

    for (Smog c in smogs) {
      paint.color = c.color;
      canvas.drawCircle(c.center, c.radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
