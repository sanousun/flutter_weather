import 'package:flutter/material.dart';
import 'dart:math' show Random, pow;

class WeatherCloudyWidget extends StatefulWidget {
  WeatherCloudyWidget({@required this.width, @required this.height});

  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() => WeatherCloudyState();
}

class WeatherCloudyState extends State<WeatherCloudyWidget>
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
    clouds = List();
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
    stars = List();
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
      painter: WeatherCloudyPainter(
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

class WeatherCloudyPainter extends CustomPainter {
  WeatherCloudyPainter(this.clouds, this.stars, this.thunder);

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

class Cloud {
  Cloud(
      {double centerX,
      double centerY,
      this.initRadius,
      this.scaleRatio,
      this.baseColor,
      this.alpha,
      int initProgress,
      this.duration})
      : this.center = Offset(centerX, centerY),
        this.progress = initProgress % duration;

  /// 初始化中心点
  Offset center;
  double initCX;
  double initCY;

  /// 初始化半径
  double initRadius;

  /// 半径最大的缩放比例
  double scaleRatio;

  double get radius {
    if (progress < 0.5 * duration) {
      return initRadius * (1 + (scaleRatio - 1) * progress / 0.5 / duration);
    } else {
      return initRadius *
          (scaleRatio -
              (scaleRatio - 1) * (progress - 0.5 * duration) / 0.5 / duration);
    }
  }

  /// 颜色及透明度
  Color baseColor;
  double alpha;

  Color get color => baseColor.withOpacity(alpha);

  /// 初始化进度
  int progress;
  int duration;

  void update(int interval) {
    progress = (progress + interval) % duration;
  }
}

class Star {
  Star({
    int centerX,
    int centerY,
    int initRadius,
    this.baseColor,
    int initProgress,
    this.duration,
  })  : this.center = Offset(centerX.ceilToDouble(), centerY.ceilToDouble()),
        this.radius = initRadius * (0.7 + (0.3 * Random().nextDouble())),
        this.progress = initProgress % duration;

  /// 中心点
  Offset center;

  /// 半径
  double radius;

  Color baseColor;

  Color get color {
    double alpha;
    if (progress < 0.5 * duration) {
      alpha = progress / 0.5 / duration;
    } else {
      alpha = 1 - (progress - 0.5 * duration) / 0.5 / duration;
    }
    return baseColor.withOpacity(alpha);
  }

  int progress;
  int duration;

  void update(int interval) {
    progress = (progress + interval) % duration;
  }
}

class Thunder {
  Thunder() {
    r = g = b = 255;
    _initProgress();
  }

  int r;
  int g;
  int b;

  int progress;
  int duration;
  int delay;

  Color get color {
    double alpha;
    if (progress < duration) {
      if (progress < 0.25 * duration) {
        alpha = (progress / 0.25 / duration);
      } else if (progress < 0.5 * duration) {
        alpha = (1 - (progress - 0.25 * duration) / 0.25 / duration);
      } else if (progress < 0.75 * duration) {
        alpha = ((progress - 0.5 * duration) / 0.25 / duration);
      } else {
        alpha = (1 - (progress - 0.75 * duration) / 0.25 / duration);
      }
    } else {
      alpha = 0.0;
    }
    return Color.fromRGBO(r, g, b, alpha);
  }

  void _initProgress() {
    progress = 0;
    duration = 300;
    delay = Random().nextInt(1000) + 2000;
  }

  void update(int interval) {
    progress = (progress + interval) % duration;
    _initProgress();
  }
}
