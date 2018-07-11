import 'package:flutter/material.dart';
import 'weather_element.dart';

class WeatherRainWidget extends StatefulWidget {
  WeatherRainWidget(this.width, this.height);

  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() => _WeatherRainState();
}

class _WeatherRainState extends State<WeatherRainWidget>
    with TickerProviderStateMixin {
  List<Rain> rains = <Rain>[];
  Thunder thunder = Thunder();
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    List<Color> colors = <Color>[
      Color.fromRGBO(223, 179, 114, 1.0),
      Color.fromRGBO(152, 175, 222, 1.0),
      Color.fromRGBO(255, 255, 255, 1.0)
    ];
    List<double> scales = <double>[0.6, 0.8, 1.0];
    for (int i = 0; i < 51; i++) {
      rains.add(Rain(
        color: colors[i % 3],
        scale: scales[i % 3],
        viewHeight: widget.width,
        viewWidth: widget.height,
      ));

      _animationController = AnimationController(
        duration: Duration(milliseconds: 32),
        vsync: this,
      )..addStatusListener((state) {
          if (state == AnimationStatus.completed) {
            _animationController.reset();
            _animationController.forward();
            setState(() {
              for (Rain r in rains) {
                r.update(32);
              }
            });
          }
        });
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RainPainter(rains, thunder),
      child: ConstrainedBox(constraints: BoxConstraints.expand()),
//      child: Center(),
    );
  }
}

class _RainPainter extends CustomPainter {
  _RainPainter(this.rains, this.thunder);

  List<Rain> rains;
  Thunder thunder;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    Rect sizeRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    paint.color = Color.fromRGBO(64, 151, 231, 1.0);
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
