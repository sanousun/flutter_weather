import 'package:flutter/material.dart';

import '../models/city.dart';

import '../city/city_provider.dart';
import '../city/city_bloc.dart';

import 'city_search_page.dart';

class CityPage extends StatelessWidget {
  static const routeName = '/city';

  @override
  Widget build(BuildContext context) {
    final cityBloc = CityProvider.of(context);
    return Scaffold(
      appBar: new AppBar(
        leading: BackButton(),
        title: Text("城市列表"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed(CitySearchPage.routeName);
            },
            tooltip: "搜索",
          )
        ],
      ),
      body: StreamBuilder<List<City>>(
          stream: cityBloc.items,
          builder: (context, snapshot) {
            if (snapshot.data?.isEmpty ?? true) {
              return Center(
                child: Text("暂无城市列表"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length * 2,
              itemBuilder: (BuildContext context, int index) {
                if (index % 2 == 0) {
                  City city = snapshot.data[index ~/ 2];
                  GestureTapCallback onTap = () {
                    cityBloc.cityChoose.add(city);
                    Navigator.of(context).pop();
                  };
                  return city.id == null
                      ? _buildCityItem(context, city, onTap)
                      : Dismissible(
                          key: ValueKey(city),
                          onDismissed: (direction) {
                            cityBloc.cityAddition
                                .add(CityAddition(city, false));
                          },
                          child: _buildCityItem(context, city, onTap),
                        );
                } else {
                  return Divider();
                }
              },
            );
          }),
    );
  }

  Widget _buildCityItem(
      BuildContext context, City city, GestureTapCallback onTap) {
    ThemeData themeData = Theme.of(context);
    return ListTile(
      title: Text(city.location),
      subtitle: Text(city.desc),
      leading: city.id == null
          ? Icon(
              Icons.my_location,
              color: themeData.textTheme.subhead.color,
            )
          : null,
      onTap: onTap,
    );
  }
}
