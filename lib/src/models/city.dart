import 'dart:async';

import 'package:sqflite/sqflite.dart';

const String TABLE_CITY = 'city';
const String ID = '_id';
const String CID = 'cid';
const String LAT = 'lat';
const String LON = 'lon';
const String LOCATION = 'location';
const String PARENT_CITY = 'parent_city';
const String ADMIN_AREA = 'admin_area';
const String CNTY = 'cnty';
const String TZ = 'tz';
const String TYPE = 'type';

class City {
  City.fromJson(Map<dynamic, dynamic> json) {
    cid = json[CID];
    location = json[LOCATION];
    parentCity = json[PARENT_CITY];
    adminArea = json[ADMIN_AREA];
    cnty = json[CNTY];
    lat = json[LAT];
    lon = json[LON];
    tz = json[TZ];
    type = json[TYPE];
  }

  City(this.location);

  Map<String, dynamic> toMap() {
    return {
      CID: cid,
      LOCATION: location,
      PARENT_CITY: parentCity,
      ADMIN_AREA: adminArea,
      CNTY: cnty,
      LAT: lat,
      LON: lon,
      TZ: tz,
    };
  }

  int id;

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

class CityDbProvider {
  Database db;

  Future open() async {
    String path = await getDatabasesPath();
    db = await openDatabase(
      "$path/weather.db",
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        create table $TABLE_CITY(
          $ID integer primary key autoincrement,
          $CID varchar(32) not null,
          $LOCATION varchar(64) not null,
          $PARENT_CITY varchar(64) ,
          $ADMIN_AREA varchar(64) ,
          $CNTY varchar(64),
          $LAT varchar(32),
          $LON varchar(32),
          $TZ varchar(8))  
        ''');
      },
    );
  }

  Future close() async {
    await db.close();
  }

  Future<City> insert(City city) async {
    city.id = await db.insert(TABLE_CITY, city.toMap());
    return city;
  }

  Future<int> delete(int id) async {
    return await db.delete(TABLE_CITY, where: "$ID = ?", whereArgs: [id]);
  }

  Future<int> update(City city) async {
    return await db.update(TABLE_CITY, city.toMap(),
        where: "$ID = ?", whereArgs: [city.id]);
  }

  Future<List<City>> getAll() async {
    List<Map> maps = await db.query(TABLE_CITY);
    return maps.map((m) => City.fromJson(m)).toList();
  }
}
