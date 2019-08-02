import '../weather/widget/weather_bg_widget.dart';
import 'city.dart';
import 'update_time.dart';
import 'life_style.dart';

class Weather {
  Weather.fromJson(Map<dynamic, dynamic> json) {
    print(json['hourly']);
    weatherNow = WeatherNow.fromJson(json['now']);
    weatherForecasts = json['daily_forecast'] == null
        ? []
        : ((json['daily_forecast'] as List)
            .map((map) => WeatherForecast.fromJson(map))
            .toList());
    weatherHourlys = json['hourly'] == null
        ? []
        : ((json['hourly'] as List)
            .map((map) => WeatherHourly.fromJson(map))
            .toList());
    city = City.fromJson(json['basic']);
    updateTime = UpdateTime.fromJson(json['update']);
    lifeStyles = json['lifestyle'] == null
        ? []
        : ((json['lifestyle'] as List)
            .map((map) => LifeStyle.fromJson(map))
            .toList());
  }

  bool get isNight {
    if (weatherForecasts != null && weatherForecasts.length > 0) {
      var today = weatherForecasts[0];
    }
    return false;
  }

  WeatherNow weatherNow;
  List<WeatherForecast> weatherForecasts;
  List<WeatherHourly> weatherHourlys;
  City city;
  UpdateTime updateTime;
  List<LifeStyle> lifeStyles;
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

  WeatherKind getWeatherKind() {
    switch (condCode) {
      case "100":
        return WeatherKind.clear;
      case "101":
      case "102":
      case "103":
        return WeatherKind.cloud;
      case "104":
        return WeatherKind.cloudy;
      case "200":
      case "201":
      case "202":
      case "203":
        return WeatherKind.clear;
      case "204":
      case "205":
      case "206":
      case "207":
      case "208":
      case "209":
      case "210":
      case "211":
      case "212":
      case "213":
        return WeatherKind.wind;
      case "302":
        return WeatherKind.thunder;
      case "303":
        return WeatherKind.thunder_storm;
      case "304":
        return WeatherKind.hail;
      case "300":
      case "301":
      case "305":
      case "306":
      case "307":
      case "308":
      case "309":
      case "310":
      case "311":
      case "312":
      case "313":
        return WeatherKind.rainy;
      case "400":
      case "401":
      case "402":
      case "403":
      case "404":
      case "405":
      case "406":
      case "407":
        return WeatherKind.snow;
      case "500":
      case "501":
        return WeatherKind.fog;
      case "502":
        return WeatherKind.haze;
      case "503":
      case "504":
      case "505":
      case "506":
      case "507":
      case "508":
        return WeatherKind.wind;
      default:
        return WeatherKind.clear;
    }
  }
}

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

  String get condCodeWithNight {
    bool isNightIconExist = condCode == '100' ||
        condCode == '103' ||
        condCode == '104' ||
        condCode == '300' ||
        condCode == '301' ||
        condCode == '406' ||
        condCode == '407';
    DateTime dateTime = DateTime.parse(time);
    DateTime morning = DateTime(dateTime.year, dateTime.month, dateTime.day, 7);
    DateTime night = DateTime(dateTime.year, dateTime.month, dateTime.day, 19);
    bool isNight = !(dateTime.isAfter(morning) && dateTime.isBefore(night));
    if (isNight && isNightIconExist) {
      return "${condCode}n";
    }
    return condCode;
  }
}
