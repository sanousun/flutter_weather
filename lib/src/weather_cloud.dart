import 'package:flutter/material.dart';
import 'weather_element.dart';
import 'dart:math';
import 'weather_widget.dart';

class WeatherCloudWidget extends StatefulWidget {
  WeatherCloudWidget(this.screenSize, this.isNight, this.weatherKind);

  final Size screenSize;
  final bool isNight;
  final WeatherKind weatherKind;

  @override
  State<StatefulWidget> createState() => _WeatherCloudState();
}

class _WeatherCloudState extends State<WeatherCloudWidget>
    with SingleTickerProviderStateMixin {
  List<Cloud> clouds = <Cloud>[];
  List<Star> stars = <Star>[];
  Thunder thunder;
  Color backgroundColor;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    double width = widget.screenSize.width;
    double height = widget.screenSize.height;

    List<double> widthRate;
    List<double> heightRate;
    List<double> radiusRate;
    Color cloudColor;
    List<double> cloudAlpha;
    List<double> cloudScale;
    List<int> initProgress = <int>[0, 1500, 0, 2000, 3500, 2000];

    switch (widget.weatherKind) {
      case WeatherKind.cloud:
        widthRate = <double>[0.1529, 0.4793, 0.8531, 0.0551, 0.4928, 1.0499];
        heightRate = <double>[
          0.1529 * 0.5568 + 0.05,
          0.4793 * 0.2185 + 0.05,
          0.8531 * 0.1286 + 0.05,
          0.0551 * 2.8600 + 0.05,
          0.4928 * 0.3897 + 0.05,
          1.0499 * 0.1875 + 0.05
        ];
        radiusRate = <double>[0.2649, 0.2426, 0.2970, 0.4125, 0.3521, 0.4186];
        cloudScale = <double>[1.2, 1.15];
        cloudAlpha = <double>[0.4, 0.1];
        if (widget.isNight) {
          cloudColor = Color.fromRGBO(151, 168, 202, 1.0);
          backgroundColor = Color.fromRGBO(34, 45, 67, 1.0);
        } else {
          cloudColor = Color.fromRGBO(203, 245, 255, 1.0);
          backgroundColor = Color.fromRGBO(0, 165, 217, 1.0);
        }
        break;
      case WeatherKind.cloudy:
      case WeatherKind.thunder:
      default:
        widthRate = <double>[-0.0234, 0.4663, 1.0270, -0.1701, 0.4866, 1.3223];
        heightRate = <double>[
          0.0234 * 5.7648 + 0.05,
          0.4663 * 0.3520 + 0.05,
          1.0270 * 0.1671 + 0.05,
          0.1701 * 1.4327 + 0.05,
          0.4866 * 0.6064 + 0.05,
          1.3223 * 0.2286 + 0.05,
        ];
        radiusRate = <double>[0.3975, 0.3886, 0.4330, 0.6188, 0.5277, 0.6277];
        cloudScale = <double>[1.15, 1.1];
        if (widget.weatherKind == WeatherKind.cloudy) {
          cloudAlpha = <double>[0.2, 0.1];
          cloudColor = Color.fromRGBO(171, 171, 171, 1.0);
          backgroundColor = Color.fromRGBO(96, 121, 136, 1.0);
        } else {
          thunder = Thunder();
          cloudAlpha = <double>[0.1, 0.1];
          cloudColor = Color.fromRGBO(0, 0, 0, 1.0);
          backgroundColor = Color.fromRGBO(43, 29, 69, 1.0);
        }
        break;
    }
    Random r = new Random();
    for (int i = 0; i < 6; i++) {
      clouds.add(Cloud(
        centerX: width * widthRate[i],
        centerY: width * heightRate[i],
        initRadius: width * radiusRate[i],
        baseColor: cloudColor,
        scale: i > 2 ? cloudScale[1] : cloudScale[0],
        alpha: i > 2 ? cloudAlpha[1] : cloudAlpha[0],
        initProgress: r.nextInt(7000),
        duration: 7000,
      ));
    }

    if (widget.weatherKind == WeatherKind.cloud && widget.isNight) {
      // star
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
    }
    _animationController = AnimationController(
      duration: Duration(milliseconds: 32),
      vsync: this,
    )..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
          setState(() {
            thunder?.update(16);
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
      painter: _WeatherCloudyPainter(clouds, stars, thunder, backgroundColor),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
      ),
    );
  }
}

class _WeatherCloudyPainter extends CustomPainter {
  _WeatherCloudyPainter(
      this.clouds, this.stars, this.thunder, this.backgroundColor);

  List<Cloud> clouds;
  List<Star> stars;
  Thunder thunder;
  Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    Rect sizeRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    paint.color = backgroundColor;
    canvas.drawRect(sizeRect, paint);

    for (Star s in stars) {
      paint.color = s.color;
      canvas.drawCircle(s.center, s.radius, paint);
    }

    for (Cloud c in clouds) {
      paint.color = c.color;
      canvas.drawCircle(c.center, c.radius, paint);
    }

    if (thunder != null) {
      paint.color = thunder.color;
      canvas.drawRect(sizeRect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
