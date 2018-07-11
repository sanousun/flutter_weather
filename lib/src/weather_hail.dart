import 'package:flutter/material.dart';
import 'weather_element.dart';

class WeatherHailWidget extends StatefulWidget {
  WeatherHailWidget(this.width, this.height);

  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() => _WeatherHailState();
}

class _WeatherHailState extends State<WeatherHailWidget>
    with TickerProviderStateMixin {
  List<Hail> hails = <Hail>[];
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    List<Color> colors = <Color>[
      Color.fromRGBO(101, 134, 203, 1.0),
      Color.fromRGBO(152, 175, 222, 1.0),
      Color.fromRGBO(255, 255, 255, 1.0)
    ];
    List<double> scales = <double>[0.6, 0.8, 1.0];
    for (int i = 0; i < 51; i++) {
      hails.add(Hail(
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
              for (Hail r in hails) {
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
      painter: _HailPainter(hails),
      child: ConstrainedBox(constraints: BoxConstraints.expand()),
//      child: Center(),
    );
  }
}

class _HailPainter extends CustomPainter {
  _HailPainter(this.hails);

  List<Hail> hails;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    Rect sizeRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    paint.color = Color.fromRGBO(80, 116, 193, 1.0);
    canvas.drawRect(sizeRect, paint);

    Path path = Path();
    for (Hail h in hails) {
      paint.color = h.color;
      path.reset();
      path.moveTo(h.centerX - h.size, h.centerY);
      path.lineTo(h.centerX, h.centerY - h.size);
      path.lineTo(h.centerX + h.size, h.centerY);
      path.lineTo(h.centerX, h.centerY + h.size);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
