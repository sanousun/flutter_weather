import 'package:flutter/material.dart';
import 'city_bloc.dart';

class CityProvider extends InheritedWidget {
  final CityBloc cityBloc;

  CityProvider({
    Key key,
    CityBloc cityBloc,
    Widget child,
  })  : this.cityBloc = cityBloc ?? CityBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CityBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(CityProvider) as CityProvider)
          .cityBloc;
}
