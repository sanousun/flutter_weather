class City {
  City.fromJson(Map<dynamic, dynamic> json) {
    cid = json['cid'] as String;
    lat = json['lat'] as String;
    lon = json['lon'] as String;
    location = json['location'] as String;
    parentCity = json['parent_city'] as String;
    adminArea = json['admin_area'] as String;
    cnty = json['cnty'] as String;
    tz = json['tz'] as String;
    type = json['type'] as String;
  }

  /// 地区／城市ID
  String cid;

  /// 地区／城市名称
  String location;

  /// 地区／城市纬度
  String lat;

  /// 地区／城市经度
  String lon;

  /// 该地区／城市的上级城市
  String parentCity;

  /// 该地区／城市所属行政区域
  String adminArea;

  /// 该地区／城市所属国家名称
  String cnty;

  /// 该地区／城市所在时区
  String tz;

  /// 该地区／城市的属性，目前有city城市和scenic中国景点
  String type;

  String get desc {
    String name = "$cnty $adminArea";
    if (!(adminArea == parentCity)) {
      name += " $parentCity";
    }
    return name;
  }

  @override
  int get hashCode => cid.hashCode;

  @override
  bool operator ==(other) => cid == other.cid;
}
