import 'dart:async';

import 'package:rxdart/subjects.dart';

import '../models/city.dart';
import '../models/city_collection.dart';

class CityAddition {
  const CityAddition(this.city, this.isAdd);

  final City city;
  final bool isAdd;
}

class CityBloc {
  final CityCollection _cityCollection = CityCollection();

  final _cities = BehaviorSubject<List<City>>(seedValue: []);
  final _currentCity = BehaviorSubject<City>();

  final _cityAdditionController = StreamController<CityAddition>();
  final _cityStepChooseController = StreamController<ChooseStep>();
  final _cityChooseController = StreamController<City>();

  CityBloc() {
    _cityAdditionController.stream.listen(_handleAddition);
    _cityStepChooseController.stream.listen(_handleStepChoose);
    _cityChooseController.stream.listen(_handleChoose);
    _cityCollection.init().then((value) {
      _cities.add(_cityCollection.cities);
      _currentCity.add(_cityCollection.currentCity);
    });
  }

  Sink<CityAddition> get cityAddition => _cityAdditionController.sink;

  Sink<City> get cityChoose => _cityChooseController.sink;

  Sink<ChooseStep> get cityStepChoose => _cityStepChooseController.sink;

  Stream<List<City>> get items => _cities.stream;

  Stream<City> get city => _currentCity.stream;

  void dispose() {
    _cityAdditionController.close();
    _cityStepChooseController.close();
    _cityChooseController.close();
    _cityCollection.dispose();
  }

  void _handleAddition(CityAddition cityAddition) {
    Future future;
    if (cityAddition.isAdd) {
      future = _cityCollection.addCity(cityAddition.city);
    } else {
      future = _cityCollection.removeCity(cityAddition.city);
    }
    future.then((dynamic) {
      _cities.add(_cityCollection.cities);
      _currentCity.add(_cityCollection.currentCity);
    });
  }

  void _handleStepChoose(ChooseStep step) {
    if (step == ChooseStep.next) {
      _cityCollection.nextCity();
    } else {
      _cityCollection.previousCity();
    }
    _currentCity.add(_cityCollection.currentCity);
  }

  void _handleChoose(City city) {
    int index = _cityCollection.chooseCity(city);
    if (index != -1) {
      _currentCity.add(_cityCollection.currentCity);
    }
  }
}

enum ChooseStep { next, previous }
