import 'dart:async';
import 'package:rxdart/subjects.dart';
import '../models/city.dart';

class CityAddition {
  const CityAddition(this.city, this.isAdd);

  final City city;
  final bool isAdd;
}

class CityBloc {
  final _cities = <City>[];

  final _cityItems = BehaviorSubject<List<City>>(seedValue: []);
  final _cityAdditionController = StreamController<CityAddition>();

  CityBloc() {
    _cityAdditionController.stream.listen(_handleAddition);
  }

  Sink<CityAddition> get cityAddition => _cityAdditionController.sink;

  Stream<List<City>> get items => _cityItems.stream;

  void dispose() {
    _cityAdditionController.close();
  }

  void _handleAddition(CityAddition cityAddition) {
    if (cityAddition.isAdd) {
      _cities.add(cityAddition.city);
    } else {
      _cities.remove(cityAddition.city);
    }
    // TODO 要不要clone
    _cityItems.add(_cities);
  }
}
