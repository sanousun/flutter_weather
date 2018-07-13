class WeatherForecast {
  WeatherForecast.fromJson(Map<dynamic, dynamic> json) {
    condCodeD = json['cond_code_d'];
    condCodeN = json['cond_code_n'];
    condTxtD = json['code_txt_d'];
    condTxtN = json['code_txt_n'];
    date = json['date'];
    hum = json['hum'];
    pcpn = json['pcpn'];
    pop = json['pop'];
    pres = json['pres'];
    tmpMax = json['tmp_max'];
    tmpMin = json['tmp_min'];
    uvIndex = json['uv_index'];
    vis = json['vis'];
    windDeg = json['wind_deg'];
    windDir = json['wind_dir'];
    windSc = json['wind_sc'];
    windSpd = json['wind_spd'];
    sr = json['sr'];
    ss = json['ss'];
    mr = json['mr'];
    ms = json['ms'];
  }

  /// 白天天气状况代码
  String condCodeD;

  /// 晚间天气状况代码
  String condCodeN;

  /// 白天天气状况描述
  String condTxtD;

  /// 晚间天气状况描述
  String condTxtN;

  /// 预报日期
  String date;

  /// 相对湿度
  String hum;

  /// 降水量
  String pcpn;

  /// 降水概率
  String pop;

  /// 大气压强
  String pres;

  /// 最高温度
  String tmpMax;

  /// 最低温度
  String tmpMin;

  /// 紫外线强度指数
  String uvIndex;

  /// 能见度，单位：公里
  String vis;

  /// 风向360角度
  String windDeg;

  /// 风向
  String windDir;

  /// 风力
  String windSc;

  /// 风速，公里/小时
  String windSpd;

  /// 日出时间
  String sr;

  /// 日落时间
  String ss;

  /// 月升时间
  String mr;

  /// 月落时间
  String ms;
}

class WeatherNow {
  WeatherNow.fromJson(Map<dynamic, dynamic> json) {
    fl = json['fl'];
    tmp = json['tmp'];
    condCode = json['cond_code'];
    condTxt = json['cond_txt'];
    hum = json['hum'];
    pcpn = json['pcpn'];
    pres = json['pres'];
    vis = json['vis'];
    windDeg = json['wind_deg'];
    windDir = json['wind_dir'];
    windSc = json['wind_sc'];
    windSpd = json['wind_spd'];
    cloud = json['cloud'];
  }

  /// 体感温度，默认单位：摄氏度
  String fl;

  /// 温度，默认单位：摄氏度
  String tmp;

  /// 实况天气状况代码
  String condCode;

  /// 实况天气状况描述
  String condTxt;

  /// 风向360角度
  String windDeg;

  /// 风向
  String windDir;

  /// 风力
  String windSc;

  String get windScDesc => windSc.contains('风') ? windSc : windSc + '级';

  /// 风速，公里/小时
  String windSpd;

  /// 相对湿度
  String hum;

  /// 降水量
  String pcpn;

  /// 大气压强
  String pres;

  /// 能见度，单位：公里
  String vis;

  /// 云量
  String cloud;
}

class WeatherHourly {
  WeatherHourly.fromJson(Map<dynamic, dynamic> json) {
    time = json['time'];
    tmp = json['tmp'];
    condCode = json['cond_code'];
    condTxt = json['cond_txt'];
    pop = json['pop'];
    pres = json['pres'];
    dew = json['dew'];
    could = json['could'];
    windDeg = json['wind_deg'];
    windDir = json['wind_dir'];
    windSc = json['wind_sc'];
    windSpd = json['wind_spd'];
  }

  /// 预报时间，格式yyyy-MM-dd HH:mm
  String time;

  /// 温度，默认单位：摄氏度
  String tmp;

  /// 实况天气状况代码
  String condCode;

  /// 实况天气状况描述
  String condTxt;

  /// 风向360角度
  String windDeg;

  /// 风向
  String windDir;

  /// 风力
  String windSc;

  /// 风速，公里/小时
  String windSpd;

  /// 降水概率
  String pop;

  /// 大气压强
  String pres;

  /// 露点温度
  String dew;

  /// 云量，百分比
  String could;
}
