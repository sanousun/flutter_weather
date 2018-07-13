import 'city.dart';

class CityList {
  List<City> cities = <City>[];

  CityList.clone(CityList cityList) {
    cities.addAll(cityList.cities);
  }
}
