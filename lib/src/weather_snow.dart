import 'package:flutter/material.dart';
import 'weather_element.dart';

class WeatherSnowWidget extends StatefulWidget {
  WeatherSnowWidget(this.width, this.height);

  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() => _WeatherSnowState();
}

class _WeatherSnowState extends State<WeatherSnowWidget>
    with TickerProviderStateMixin {
  List<Snow> snows = <Snow>[];
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    List<Color> colors = <Color>[
      Color.fromRGBO(128, 197, 255, 1.0),
      Color.fromRGBO(185, 222, 255, 1.0),
      Color.fromRGBO(255, 255, 255, 1.0)
    ];
    List<double> scales = <double>[0.6, 0.8, 1.0];
    for (int i = 0; i < 51; i++) {
      snows.add(Snow(
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
              for (Snow s in snows) {
                s.update(32);
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
      painter: _SnowPainter(snows),
      child: ConstrainedBox(constraints: BoxConstraints.expand()),
//      child: Center(),
    );
  }
}

class _SnowPainter extends CustomPainter {
  _SnowPainter(this.snows);

  List<Snow> snows;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    Rect sizeRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    paint.color = Color.fromRGBO(104, 186, 255, 1.0);
    canvas.drawRect(sizeRect, paint);

    for (Snow s in snows) {
      paint.color = s.color;
      canvas.drawCircle(s.center, s.radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
