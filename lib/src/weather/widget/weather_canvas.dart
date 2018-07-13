import 'package:flutter/material.dart';
import 'weather_bg_widget.dart';
import 'weather_element.dart';
import 'dart:math';

class WeatherCanvas {
  WeatherCanvas(Size screenSize, this.weatherKind, this.isNight)
      : this.width = screenSize.width,
        this.height = screenSize.height {
    init();
  }

  final double width;
  final double height;
  final WeatherKind weatherKind;
  final bool isNight;

  Random random = Random();
  List<WeatherElement> weatherElements = <WeatherElement>[];
  Color backgroundColor;

  void init() {
    _buildBackground();
    _buildSun();
    _buildStars();
    _buildMeteors();
    _buildCloud();
    _buildThunder();
    _buildRain();
    _buildWind();
    _buildSnow();
    _buildHail();
    _buildSmog();
  }

  void _buildBackground() {
    switch (weatherKind) {
      case WeatherKind.clear:
        if (isNight) {
          backgroundColor = Color.fromRGBO(34, 45, 67, 1.0);
        } else {
          backgroundColor = Color.fromRGBO(253, 188, 76, 1.0);
        }
        break;
      case WeatherKind.cloud:
        if (isNight) {
          backgroundColor = Color.fromRGBO(34, 45, 67, 1.0);
        } else {
          backgroundColor = Color.fromRGBO(0, 165, 217, 1.0);
        }
        break;
      case WeatherKind.cloudy:
        backgroundColor = Color.fromRGBO(96, 121, 136, 1.0);
        break;
      case WeatherKind.thunder:
      case WeatherKind.thunder_storm:
        backgroundColor = Color.fromRGBO(43, 29, 69, 1.0);
        break;
      case WeatherKind.rainy:
        if (isNight) {
          backgroundColor = Color.fromRGBO(38, 78, 143, 1.0);
        } else {
          backgroundColor = Color.fromRGBO(64, 151, 231, 1.0);
        }
        break;
      case WeatherKind.thunder_storm:
        backgroundColor = Color.fromRGBO(43, 29, 69, 1.0);
        break;
      case WeatherKind.sleet:
        if (isNight) {
          backgroundColor = Color.fromRGBO(26, 91, 146, 1.0);
        } else {
          backgroundColor = Color.fromRGBO(104, 186, 255, 1.0);
        }
        break;
      case WeatherKind.wind:
        backgroundColor = Color.fromRGBO(233, 158, 60, 1.0);
        break;
      case WeatherKind.snow:
        if (isNight) {
          backgroundColor = Color.fromRGBO(26, 91, 146, 1.0);
        } else {
          backgroundColor = Color.fromRGBO(104, 186, 255, 1.0);
        }
        break;
      case WeatherKind.hail:
        if (isNight) {
          backgroundColor = Color.fromRGBO(42, 52, 69, 1.0);
        } else {
          backgroundColor = Color.fromRGBO(80, 116, 193, 1.0);
        }
        break;
      case WeatherKind.fog:
        backgroundColor = Color.fromRGBO(84, 100, 121, 1.0);
        break;
      case WeatherKind.haze:
        backgroundColor = Color.fromRGBO(66, 66, 66, 1.0);
        break;
      default:
    }
  }

  _buildSun() {
    if (!isNight && weatherKind == WeatherKind.clear) {
      Color color = Color.fromRGBO(253, 84, 17, 1.0);
      List<double> speeds = <double>[
        pi / 3000,
        pi / 4000,
        pi / 5000,
      ];
      List<double> sizes = <double>[
        0.5 * 0.47 * width,
        1.7794 * 0.5 * 0.47 * width,
        3.0594 * 0.5 * 0.47 * width,
      ];
      List<double> alphas = <double>[0.4, 0.16, 0.08];
      for (int i = 0; i < 3; i++) {
        weatherElements.add(Sun(
          speed: speeds[i],
          size: sizes[i],
          color: color,
          alpha: alphas[i],
          viewWidth: width,
          viewHeight: height,
        ));
      }
    }
  }

  _buildStars() {
    if (isNight &&
        (weatherKind == WeatherKind.clear ||
            weatherKind == WeatherKind.cloud)) {
      double canvasSize = pow(pow(width, 2) + pow(height, 2), 0.5);
      double w = canvasSize;
      double h = (canvasSize - height) * 0.5 + width * 1.1111;
      double radius = 0.0028 * width;
      Color color = Color.fromRGBO(255, 255, 255, 1.0);
      for (int i = 0; i < 30; i++) {
        double x = random.nextDouble() * w - 0.5 * (canvasSize - width);
        double y = random.nextDouble() * h - 0.5 * (canvasSize - height);
        int duration = 1500 + random.nextInt(3) * 500;
        weatherElements.add(Star(
            centerX: x,
            centerY: y,
            initRadius: radius,
            baseColor: color,
            initProgress: random.nextInt(duration),
            duration: duration));
      }
    }
  }

  _buildMeteors() {
    if (isNight && weatherKind == WeatherKind.clear) {
      List<Color> colors = <Color>[
        Color.fromRGBO(170, 215, 252, 1.0),
        Color.fromRGBO(255, 255, 255, 1.0),
        Color.fromRGBO(255, 255, 255, 1.0)
      ];
      List<double> scales = <double>[0.4, 0.7, 1.0];
      for (int i = 0; i < 15; i++) {
        weatherElements.add(Meteor(
          color: colors[i % 3],
          scale: scales[i % 3],
          viewHeight: width,
          viewWidth: height,
        ));
      }
    }
  }

  _buildCloud() {
    if (weatherKind == WeatherKind.cloud ||
        weatherKind == WeatherKind.cloudy ||
        weatherKind == WeatherKind.thunder) {
      List<double> widthRate;
      List<double> heightRate;
      List<double> radiusRate;
      Color cloudColor;
      List<double> cloudAlpha;
      List<double> cloudScale;
      switch (weatherKind) {
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
          if (isNight) {
            cloudColor = Color.fromRGBO(151, 168, 202, 1.0);
          } else {
            cloudColor = Color.fromRGBO(203, 245, 255, 1.0);
          }
          break;
        case WeatherKind.cloudy:
        case WeatherKind.thunder:
        default:
          widthRate = <double>[
            -0.0234,
            0.4663,
            1.0270,
            -0.1701,
            0.4866,
            1.3223
          ];
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
          if (weatherKind == WeatherKind.cloudy) {
            cloudAlpha = <double>[0.2, 0.1];
            cloudColor = Color.fromRGBO(171, 171, 171, 1.0);
          } else {
            cloudAlpha = <double>[0.1, 0.1];
            cloudColor = Color.fromRGBO(0, 0, 0, 1.0);
          }
          break;
      }
      Random r = new Random();
      for (int i = 0; i < 6; i++) {
        weatherElements.add(Cloud(
          initCX: width * widthRate[i],
          initCY: width * heightRate[i],
          initRadius: width * radiusRate[i],
          baseColor: cloudColor,
          scale: i > 2 ? cloudScale[1] : cloudScale[0],
          alpha: i > 2 ? cloudAlpha[1] : cloudAlpha[0],
          initProgress: r.nextInt(7000),
          duration: 7000,
        ));
      }
    }
  }

  _buildThunder() {
    if (weatherKind == WeatherKind.thunder ||
        weatherKind == WeatherKind.thunder_storm) {
      weatherElements.add(Thunder(
        viewWidth: width,
        viewHeight: height,
      ));
    }
  }

  _buildRain() {
    if (weatherKind == WeatherKind.rainy ||
        weatherKind == WeatherKind.thunder_storm ||
        weatherKind == WeatherKind.sleet) {
      List<Color> colors;
      int rainSize;
      switch (weatherKind) {
        case WeatherKind.rainy:
          rainSize = 51;
          if (isNight) {
            colors = <Color>[
              Color.fromRGBO(182, 142, 82, 1.0),
              Color.fromRGBO(88, 92, 113, 1.0),
              Color.fromRGBO(255, 255, 255, 1.0)
            ];
          } else {
            colors = <Color>[
              Color.fromRGBO(223, 179, 114, 1.0),
              Color.fromRGBO(152, 175, 222, 1.0),
              Color.fromRGBO(255, 255, 255, 1.0)
            ];
          }
          break;
        case WeatherKind.thunder_storm:
          rainSize = 45;
          colors = <Color>[
            Color.fromRGBO(182, 142, 82, 1.0),
            Color.fromRGBO(88, 92, 113, 1.0),
            Color.fromRGBO(255, 255, 255, 1.0),
          ];
          break;
        case WeatherKind.sleet:
          rainSize = 45;
          if (isNight) {
            colors = <Color>[
              Color.fromRGBO(40, 102, 155, 1.0),
              Color.fromRGBO(99, 144, 182, 1.0),
              Color.fromRGBO(255, 255, 255, 1.0)
            ];
          } else {
            colors = <Color>[
              Color.fromRGBO(128, 197, 255, 1.0),
              Color.fromRGBO(185, 222, 255, 1.0),
              Color.fromRGBO(255, 255, 255, 1.0)
            ];
          }
          break;
        default:
      }
      List<double> scales = <double>[0.6, 0.8, 1.0];
      for (int i = 0; i < rainSize; i++) {
        weatherElements.add(Rain(
          color: colors[i % colors.length],
          scale: scales[i % scales.length],
          viewHeight: width,
          viewWidth: height,
        ));
      }
    }
  }

  _buildWind() {
    if (weatherKind == WeatherKind.wind) {
      List<Color> colors = <Color>[
        Color.fromRGBO(240, 200, 148, 1.0),
        Color.fromRGBO(237, 178, 100, 1.0),
        Color.fromRGBO(209, 142, 54, 1.0),
      ];
      List<double> scales = <double>[0.6, 0.8, 1.0];
      for (int i = 0; i < 51; i++) {
        weatherElements.add(Wind(
          color: colors[i % 3],
          scale: scales[i % 3],
          viewHeight: width,
          viewWidth: height,
        ));
      }
    }
  }

  _buildSnow() {
    if (weatherKind == WeatherKind.snow) {
      List<Color> colors;
      if (isNight) {
        colors = <Color>[
          Color.fromRGBO(40, 102, 155, 1.0),
          Color.fromRGBO(99, 144, 182, 1.0),
          Color.fromRGBO(255, 255, 255, 1.0)
        ];
      } else {
        colors = <Color>[
          Color.fromRGBO(128, 197, 255, 1.0),
          Color.fromRGBO(185, 222, 255, 1.0),
          Color.fromRGBO(255, 255, 255, 1.0)
        ];
      }
      List<double> scales = <double>[0.6, 0.8, 1.0];
      for (int i = 0; i < 51; i++) {
        weatherElements.add(Snow(
          color: colors[i % 3],
          scale: scales[i % 3],
          viewHeight: width,
          viewWidth: height,
        ));
      }
    }
  }

  _buildHail() {
    if (weatherKind == WeatherKind.hail) {
      List<Color> colors;
      if (isNight) {
        colors = <Color>[
          Color.fromRGBO(64, 67, 85, 1.0),
          Color.fromRGBO(127, 131, 154, 1.0),
          Color.fromRGBO(255, 255, 255, 1.0)
        ];
      } else {
        colors = <Color>[
          Color.fromRGBO(101, 134, 203, 1.0),
          Color.fromRGBO(152, 175, 222, 1.0),
          Color.fromRGBO(255, 255, 255, 1.0)
        ];
      }
      List<double> scales = <double>[0.6, 0.8, 1.0];
      for (int i = 0; i < 51; i++) {
        weatherElements.add(Hail(
          color: colors[i % 3],
          scale: scales[i % 3],
          viewHeight: width,
          viewWidth: height,
        ));
      }
    }
  }

  _buildSmog() {
    if (weatherKind == WeatherKind.haze || weatherKind == WeatherKind.fog) {
      double cX = (0.5000 * width);
      double cY = (1.2565 * width);

      Color color;
      double alpha;
      if (weatherKind == WeatherKind.fog) {
        color = Color.fromRGBO(66, 66, 66, 1.0);
        alpha = 0.1;
      } else {
        color = Color.fromRGBO(0, 0, 0, 1.0);
        alpha = 0.05;
      }

      List<double> scales = <double>[0.4440, 0.5770, 0.7106, 0.8434, 0.9769];

      for (int i = 0; i < scales.length; i++) {
        weatherElements.add(Smog(
          initCX: cX,
          initCY: cY,
          initRadius: width * scales[i],
          baseColor: color,
          alpha: alpha,
          initProgress: 0,
          duration: 5000,
        ));
      }
    }
  }

  void update(int interval, double rotation2D, double rotation3D) {
    for (WeatherElement element in weatherElements) {
      element.update(interval, rotation2D, rotation3D);
    }
  }

  void paint(Canvas canvas, Paint paint, double rotation2D) {
    // 背景绘制
    paint.color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, width, height), paint);
    // 元素绘制
    for (WeatherElement element in weatherElements) {
      element.paint(canvas, paint, rotation2D);
    }
  }
}
