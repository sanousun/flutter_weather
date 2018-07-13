import 'package:flutter/material.dart';

import '../models/city.dart';
import '../models/weather.dart';

import '../city/city_provider.dart';

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
                  return ListTile(
                    title: Text(city.location),
                    subtitle: Text(city.desc),
                    onTap: () {},
                  );
                } else {
                  return Divider(
                    height: 1.0,
                    color: Colors.grey[300],
                  );
                }
              },
            );
          }),
    );
  }
}
