import '../models/city.dart';

class CityCollection {
  CityDbProvider _dbProvider = CityDbProvider();

  List<City> _cityList = <City>[];
  int _curIndex = 0;

  City get currentCity =>
      _curIndex < _cityList.length ? _cityList[_curIndex] : null;

  List<City> get cities => <City>[]..addAll(_cityList);

  CityCollection() {
    //TODO 数据库
  }

  void addCity(City city) {
    _cityList.add(city);
  }

  void removeCity(City city) {
    int index = _cityList.indexOf(city);
    if (index != -1) {
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
