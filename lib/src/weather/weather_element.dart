import 'package:flutter/material.dart';
import 'dart:math';

abstract class WeatherElement {
  void update(int interval);

  void paint(Canvas canvas, Paint paint);
}

class Sun extends WeatherElement {
  Sun({
    this.speed,
    this.size,
    this.color,
    this.alpha,
    this.viewWidth,
    this.viewHeight,
  });

  double angle = 0.0;
  double speed;
  double size;
  Color color;
  double alpha;
  double viewWidth;
  double viewHeight;

  @override
  void paint(Canvas canvas, Paint paint) {
    canvas.save();
    canvas.translate(viewWidth, 0.0333 * viewWidth);
    Rect rect = Rect.fromLTRB(-size, -size, size, size);
    paint.color = color.withOpacity(alpha);
    canvas.rotate(angle);
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(rect, paint);
      canvas.rotate(22.5);
    }
    canvas.restore();
  }

  @override
  void update(int interval) {
    angle = ((speed * interval) + angle) % 90;
  }
}

class Star extends WeatherElement {
  Star({
    double centerX,
    double centerY,
    double initRadius,
    this.baseColor,
    int initProgress,
    this.duration,
  })  : this.center = Offset(centerX, centerY),
        this.radius = initRadius * (0.7 + (0.3 * Random().nextDouble())),
        this.progress = initProgress % duration;

  Offset center;
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

  @override
  void update(int interval) {
    progress = (progress + interval) % duration;
  }

  @override
  void paint(Canvas canvas, Paint paint) {
    paint.color = color;
    canvas.drawCircle(center, radius, paint);
  }
}

class Meteor extends WeatherElement {
  Meteor({
    this.color,
    this.scale,
    this.viewWidth,
    this.viewHeight,
  })  : this.canvasSize = pow(pow(viewWidth, 2) + pow(viewHeight, 2), 0.5),
        this.speed = viewHeight / 500,
        this.maxHeight = (1.1 * viewWidth / cos(60.0 * pi / 180.0)),
        this.minHeight = (1.1 * viewWidth / cos(60.0 * pi / 180.0)) * 0.7,
        this.width = viewWidth * 0.0088 * scale {
    _init(true);
  }

  Color color;
  double scale;
  double speed;
  double viewWidth;
  double viewHeight;
  double canvasSize;
  double minHeight;
  double maxHeight;

  double x;
  double y;
  double width;
  double height;

  Rect get rect {
    double x = this.x - (canvasSize - viewWidth) * 0.5;
    double y = this.y - (canvasSize - viewHeight) * 0.5;
    return Rect.fromLTRB(x, y, x + width, y + height);
  }

  void _init(bool firstTime) {
    Random r = new Random();
    x = r.nextDouble() * canvasSize;
    if (firstTime) {
      y = r.nextDouble() * (canvasSize - maxHeight) - canvasSize;
    } else {
      y = -maxHeight;
    }
    height = minHeight + r.nextDouble() * (maxHeight - minHeight);
  }

  @override
  void update(int interval) {
    y += speed * interval * (pow(scale, 1.5));
    x -= 0;
    if (y >= canvasSize) {
      _init(false);
    }
  }

  @override
  void paint(Canvas canvas, Paint paint) {
    paint.color = color;
    canvas.drawRect(rect, paint);
  }
}

class Cloud extends WeatherElement {
  Cloud({
    double centerX,
    double centerY,
    this.initRadius,
    this.scale,
    this.baseColor,
    this.alpha,
    int initProgress,
    this.duration,
  })  : this.center = Offset(centerX, centerY),
        this.progress = initProgress % duration;

  /// 初始化中心点
  Offset center;
  double initCX;
  double initCY;

  /// 初始化半径
  double initRadius;

  /// 半径最大的缩放比例
  double scale;

  double get radius {
    if (progress < 0.5 * duration) {
      return initRadius * (1 + (scale - 1) * progress / 0.5 / duration);
    } else {
      return initRadius *
          (scale - (scale - 1) * (progress - 0.5 * duration) / 0.5 / duration);
    }
  }

  /// 颜色及透明度
  Color baseColor;
  double alpha;

  Color get color => baseColor.withOpacity(alpha);

  /// 初始化进度
  int progress;
  int duration;

  @override
  void update(int interval) {
    progress = (progress + interval) % duration;
  }

  @override
  void paint(Canvas canvas, Paint paint) {
    paint.color = color;
    canvas.drawCircle(center, radius, paint);
  }
}

class Thunder extends WeatherElement {
  Thunder({
    this.viewWidth,
    this.viewHeight,
    this.baseColor = const Color.fromRGBO(255, 255, 255, 1.0),
    this.duration = 300,
  }) {
    _init();
  }

  Color baseColor;

  int progress;
  int duration;
  int delay;

  double viewWidth;
  double viewHeight;

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
    return baseColor.withOpacity(alpha);
  }

  void _init() {
    progress = 0;
    delay = Random().nextInt(1000) + 2000;
  }

  @override
  void update(int interval) {
    progress += interval;
    if (progress > duration + delay) {
      _init();
    }
  }

  @override
  void paint(Canvas canvas, Paint paint) {
    paint.color = color;
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, viewWidth, viewHeight), paint);
  }
}

class Rain extends WeatherElement {
  Rain({
    this.color,
    this.scale,
    this.viewWidth,
    this.viewHeight,
  })  : this.canvasSize = pow(pow(viewWidth, 2) + pow(viewHeight, 2), 0.5),
        this.speed = viewWidth / 300,
        this.maxWidth = 0.0111 * viewWidth,
        this.minWidth = 0.0089 * viewWidth,
        this.maxHeight = 0.0111 * viewWidth * 18,
        this.minHeight = 0.0089 * viewWidth * 14 {
    _init(true);
  }

  Color color;
  double scale;
  double speed;
  double viewWidth;
  double viewHeight;
  double canvasSize;
  double minWidth;
  double maxWidth;
  double minHeight;
  double maxHeight;

  double x;
  double y;
  double width;
  double height;

  Rect get rect {
    double x = this.x - (canvasSize - viewWidth) * 0.5;
    double y = this.y - (canvasSize - viewHeight) * 0.5;
    return Rect.fromLTRB(x, y, x + width * scale, y + height * scale);
  }

  void _init(bool firstTime) {
    Random r = new Random();
    x = r.nextInt(canvasSize.floor()).floorToDouble();
    if (firstTime) {
      y = r.nextInt((canvasSize - maxHeight).floor()) - canvasSize;
    } else {
      y = -maxHeight;
    }
    width = minWidth + r.nextDouble() * (maxWidth - minWidth);
    height = minHeight + r.nextDouble() * (maxHeight - minHeight);
  }

  @override
  void update(int interval) {
    y += speed * interval * (pow(scale, 1.5));
    x -= 0;
    if (y >= canvasSize) {
      _init(false);
    }
  }

  @override
  void paint(Canvas canvas, Paint paint) {
    paint.color = color;
    canvas.drawRect(rect, paint);
  }
}

class Wind extends WeatherElement {
  Wind({
    this.color,
    this.scale,
    this.viewWidth,
    this.viewHeight,
  })  : this.canvasSize = pow(pow(viewWidth, 2) + pow(viewHeight, 2), 0.5),
        this.speed = viewWidth / 150,
        this.maxHeight = 0.0111 * viewWidth,
        this.minHeight = 0.0089 * viewWidth,
        this.maxWidth = 0.0111 * viewWidth * 20,
        this.minWidth = 0.0089 * viewWidth * 15 {
    _init(true);
  }

  Color color;
  double scale;
  double speed;
  double viewWidth;
  double viewHeight;
  double canvasSize;
  double minWidth;
  double maxWidth;
  double minHeight;
  double maxHeight;

  double x;
  double y;
  double width;
  double height;

  Rect get rect {
    double x = this.x - (canvasSize - viewWidth) * 0.5;
    double y = this.y - (canvasSize - viewHeight) * 0.5;
    return Rect.fromLTRB(x, y, x + width * scale, y + height * scale);
  }

  void _init(bool firstTime) {
    Random r = new Random();
    y = r.nextDouble() * canvasSize;
    if (firstTime) {
      x = r.nextDouble() * (canvasSize - maxHeight) - canvasSize;
    } else {
      x = -maxHeight;
    }
    width = minWidth + r.nextDouble() * (maxWidth - minWidth);
    height = minHeight + r.nextDouble() * (maxHeight - minHeight);
  }

  @override
  void update(int interval) {
    x += speed * interval * pow(scale, 1.5);
    y -= 0;
    if (x >= canvasSize) {
      _init(false);
    }
  }

  @override
  void paint(Canvas canvas, Paint paint) {
    paint.color = color;
    canvas.drawRect(rect, paint);
  }
}

class Hail extends WeatherElement {
  Hail({
    this.color,
    this.scale,
    this.viewWidth,
    this.viewHeight,
  })  : this._canvasSize = pow(pow(viewWidth, 2) + pow(viewHeight, 2), 0.5),
        this._speed = viewHeight / 400,
        this.size = viewWidth * 0.0324 {
    _init(true);
  }

  double centerX;
  double centerY;

  double size;

  Color color;
  double scale;

  double _speed;

  double viewWidth;
  double viewHeight;

  double _canvasSize;

  void _init(bool firstTime) {
    Random r = Random();
    centerX = r.nextDouble() * _canvasSize;
    if (firstTime) {
      centerY = r.nextDouble() * (_canvasSize - size) - _canvasSize;
    } else {
      centerY = -size;
    }
  }

  void update(int interval) {
    centerY += _speed * interval * pow(scale, 1.5);
    if (centerY + size >= _canvasSize) {
      _init(false);
    }
  }

  @override
  void paint(Canvas canvas, Paint paint) {
    paint.color = color;
    Path path = Path();
    path.reset();
    path.moveTo(centerX - size, centerY);
    path.lineTo(centerX, centerY - size);
    path.lineTo(centerX + size, centerY);
    path.lineTo(centerX, centerY + size);
    path.close();
    canvas.drawPath(path, paint);
  }
}

class Snow extends WeatherElement {
  Snow({
    this.color,
    this.scale,
    this.viewWidth,
    this.viewHeight,
  })  : this._canvasSize = pow(pow(viewWidth, 2) + pow(viewHeight, 2), 0.5),
        this._speedY = viewHeight / 400,
        this.radius = viewWidth * 0.0213 * scale {
    _init(true);
  }

  double _cX;
  double _cY;

  double radius;

  Offset get center {
    var centerX = (_cX - (_canvasSize - viewWidth) * 0.5);
    var centerY = (_cY - (_canvasSize - viewHeight) * 0.5);
    return Offset(centerX, centerY);
  }

  Color color;
  double scale;

  double _speedX;
  double _speedY;

  double viewWidth;
  double viewHeight;

  double _canvasSize;

  void _init(bool firstTime) {
    Random r = Random();
    _cX = r.nextDouble() * _canvasSize;
    if (firstTime) {
      _cY = r.nextDouble() * (_canvasSize - radius) - _canvasSize;
    } else {
      _cY = -radius;
    }
    _speedX = r.nextDouble() * (2 * _speedY) - _speedY;
  }

  @override
  void update(int interval) {
    _cX += _speedX * interval * pow(scale, 1.5);
    _cY += _speedY * interval * pow(scale, 1.5);
    if (_cY >= _canvasSize) {
      _init(false);
    }
  }

  @override
  void paint(Canvas canvas, Paint paint) {
    paint.color = color;
    canvas.drawCircle(center, radius, paint);
  }
}

class Smog extends WeatherElement {
  Smog({
    double centerX,
    double centerY,
    this.initRadius,
    this.baseColor,
    this.alpha,
    int initProgress,
    this.duration,
  })  : this.center = Offset(centerX, centerY),
        this.progress = initProgress % duration;

  /// 初始化中心点
  Offset center;
  double initCX;
  double initCY;

  /// 初始化半径
  double initRadius;

  double get radius {
    if (progress < 0.5 * duration) {
      return initRadius * (1 + 0.03 * progress / 0.5 / duration);
    } else {
      return initRadius *
          (1.03 - 0.03 * (progress - 0.5 * duration) / 0.5 / duration);
    }
  }

  /// 颜色及透明度
  Color baseColor;
  double alpha;

  Color get color => baseColor.withOpacity(alpha);

  /// 初始化进度
  int progress;
  int duration;

  @override
  void update(int interval) {
    progress = (progress + interval) % duration;
  }

  @override
  void paint(Canvas canvas, Paint paint) {
    paint.color = color;
    canvas.drawCircle(center, radius, paint);
  }
}
