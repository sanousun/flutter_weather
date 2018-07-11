import 'package:flutter/material.dart';
import 'weather_element.dart';

class WeatherWindWidget extends StatefulWidget {
  WeatherWindWidget(this.screenSize);

  final Size screenSize;

  @override
  State<StatefulWidget> createState() => _WeatherWindState();
}

class _WeatherWindState extends State<WeatherWindWidget>
    with TickerProviderStateMixin {
  List<Wind> winds = <Wind>[];
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    List<Color> colors = <Color>[
      Color.fromRGBO(240, 200, 148, 1.0),
      Color.fromRGBO(237, 178, 100, 1.0),
      Color.fromRGBO(209, 142, 54, 1.0),
    ];
    List<double> scales = <double>[0.6, 0.8, 1.0];
    for (int i = 0; i < 51; i++) {
      winds.add(Wind(
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
            for (Wind r in winds) {
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
      painter: _WindPainter(winds),
      child: ConstrainedBox(constraints: BoxConstraints.expand()),
    );
  }
}

class _WindPainter extends CustomPainter {
  _WindPainter(this.winds);

  List<Wind> winds;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    Rect sizeRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    paint.color = Color.fromRGBO(233, 158, 60, 1.0);
    canvas.drawRect(sizeRect, paint);

    for (Wind w in winds) {
      paint.color = w.color;
      canvas.drawRect(w.rect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
