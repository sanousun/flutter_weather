import 'dart:async';

import '../models/city.dart';

class CityCollection {
  CityDbProvider _dbProvider = CityDbProvider();

  List<City> _cityList = <City>[];
  int _curIndex = 0;

  City get currentCity =>
      _curIndex < _cityList.length ? _cityList[_curIndex] : null;

  List<City> get cities => <City>[]..addAll(_cityList);

  Future initDb() async {
    await _dbProvider.open();
    List<City> cities = await _dbProvider.getAll();
    _cityList.addAll(cities);
  }

  Future dispose() async {
    await _dbProvider.close();
  }

  Future addCity(City city) async {
    City newCity = await _dbProvider.insert(city);
    _cityList.add(newCity);
  }

  void addCityLocation(City city) {
    _cityList.add(city);
  }

  Future removeCity(City city) async {
    int index = _cityList.indexOf(city);
    if (index != -1) {
      await _dbProvider.delete(city.id);
      _cityList.remove(city);
      nextCity();
    }
  }

  void previousCity() {
    _curIndex = (_curIndex + _cityList.length - 1) % _cityList.length;
  }

  void nextCity() {
    _curIndex = (_curIndex + 1) % _cityList.length;
  }

  int chooseCity(City city) {
    int index = _cityList.indexOf(city);
    if (index != -1) {
      _curIndex = index;
    }
    return index;
  }
}
