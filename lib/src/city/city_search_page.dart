import 'package:flutter/material.dart';

import '../models/city.dart';
import '../api/api.dart';

import 'city_provider.dart';
import 'city_bloc.dart';

class CitySearchPage extends StatefulWidget {
  static const routeName = '/search';

  @override
  State<StatefulWidget> createState() => CityPageState();
}

class CityPageState extends State<CitySearchPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController _searchQuery = TextEditingController();
  bool _isSearching = false;
  List<City> _suggestionCity;

  @override
  Widget build(BuildContext context) {
    final cityBloc = CityProvider.of(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: buildSearchBar(),
        body: _suggestionCity == null
            ? Center(
                child: _isSearching ? CircularProgressIndicator() : null,
              )
            : ListView(
                children: _suggestionCity
                    .map((city) => ListTile(
                          title: Text(city.location),
                          subtitle: Text(city.desc),
                          onTap: () {
                            cityBloc.cityAddition.add(CityAddition(city, true));
                            Navigator.of(context).pop();
                          },
                        ))
                    .toList(),
              ));
  }

  Widget buildSearchBar() {
    return new AppBar(
      leading: BackButton(
        color: Theme.of(context).accentColor,
      ),
      title: TextField(
        controller: _searchQuery,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: '请输入城市名',
        ),
        onSubmitted: _handleSearchSubmit,
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }

  void _handleSearchSubmit(String value) {
    setState(() {
      _isSearching = true;
      _suggestionCity = null;
    });
    areaSearch(value).then((city) {
      setState(() {
        _suggestionCity = city;
        _isSearching = false;
      });
    }, onError: (e) {
      print(e.toString());
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      setState(() {
        _isSearching = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchQuery.clear();
  }
}
