class LifeStyle {
  LifeStyle.fromJson(Map<dynamic, dynamic> json) {
    brf = json['brf'];
    txt = json['txt'];
    type = json['type'];
  }

  /// 生活指数简介
  String brf;

  /// 生活指数详细描述
  String txt;

  /// 生活指数类型
  /// comf：舒适度指数、cw：洗车指数、drsg：穿衣指数、
  /// flu：感冒指数、sport：运动指数、trav：旅游指数、
  /// uv：紫外线指数、air：空气污染扩散条件指数、ac：空调开启指数、
  /// ag：过敏指数、gl：太阳镜指数、mu：化妆指数、
  /// airc：晾晒指数、ptfc：交通指数、fsh：钓鱼指数、spi：防晒指数
  String type;

  String get typeDesc {
    switch (type) {
      case 'comf':
        return '舒适度指数';
      case 'cw':
        return '洗车指数';
      case 'drsg':
        return '穿衣指数';
      case 'flu':
        return '感冒指数';
      case 'sport':
        return '运动指数';
      case 'trav':
        return '旅游指数';
      case 'uv':
        return '紫外线指数';
      case 'air':
        return '空气污染扩散条件指数';
      case 'ac':
        return '空调开启指数';
      case 'ag':
        return '过敏指数';
      case 'gl':
        return '太阳镜指数';
      case 'mu':
        return '化妆指数';
      case 'airc':
        return '晾晒指数';
      case 'ptfc':
        return '交通指数';
      case 'fsh':
        return '钓鱼指数';
      case 'spi':
        return '防晒指数';
      default:
        return '';
    }
  }
}
