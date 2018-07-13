class UpdateTime {
  UpdateTime.fromJson(Map<dynamic, dynamic> json) {
    loc = json['loc'] as String;
    utc = json['utc'] as String;
  }

  /// 当地时间 yyyy-MM-dd hh:mm
  String loc;

  /// UTC时间 yyyy-MM-dd hh:mm
  String utc;
}
