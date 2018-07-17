import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widget/weather_bg_widget.dart';

import '../api/api.dart';
import '../models/weather.dart';
import '../models/life_style.dart';
import '../models/city.dart';
import '../city/city_provider.dart';
import '../city/city_bloc.dart';
import '../city/city_page.dart';

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CityBloc cityBloc = CityProvider.of(context);
    return StreamBuilder<City>(
      stream: cityBloc.city,
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<City> snapshot) {
        return WeatherRefreshPage(snapshot?.data?.location);
      },
    );
  }
}

class WeatherRefreshPage extends StatefulWidget {
  WeatherRefreshPage(this.location);

  final String location;

  @override
  State<StatefulWidget> createState() => WeatherRefreshPageState();
}

class WeatherRefreshPageState extends State<WeatherRefreshPage> {
  static const _platform =
      const MethodChannel('com.sanousun.flutterweather/location');

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  double verticalOffsetPercent = 0.0;
  Weather weather;

  Future<Null> _handleRefresh() async {
    if (widget.location == null || widget.location.isEmpty) {
      return;
    }
    _refreshIndicatorKey.currentState?.show();
    setState(() {
      this.weather = null;
    });
    getWeatherNow(widget.location).then(
        (weather) => setState(() {
              this.weather = weather;
            }), onError: (e) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    });
  }

  void startLocation() {
    CityBloc cityBloc = CityProvider.of(context);
    _platform.invokeMethod("getLocation").then((map) {
      City city = City.fromJson(map);
      cityBloc.addLocationCity(city);
      cityBloc.initDbData();
    }, onError: (e) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      cityBloc.addLocationCity(City("杭州"));
      cityBloc.initDbData();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // 这里才可以调用 BuildContext.inheritFromWidgetOfExactType，
    // 因为要操作 cityProvider 还是在这里请求定位，而不是initState
    super.didChangeDependencies();
    startLocation();
  }

  @override
  void didUpdateWidget(WeatherRefreshPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.location != oldWidget.location) {
      _handleRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WeatherBgWidget(
      weatherKind: weather?.weatherNow?.getWeatherKind() ?? WeatherKind.clear,
      isNight: false,
      opacity: 1 - verticalOffsetPercent / 2,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text(
            widget.location ?? "定位中...",
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.location_city,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CityPage.routeName);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.info,
              ),
              onPressed: () {},
            )
          ],
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: WeatherContentPage(weather),
        ),
      ),
    );
  }
}

class WeatherContentPage extends StatefulWidget {
  WeatherContentPage(this.weather);

  final Weather weather;

  @override
  State<StatefulWidget> createState() => WeatherContentPageState();
}

class WeatherContentPageState extends State<WeatherContentPage> {
  double horizontalOffset = 0.0;
  double horizontalTotal = 0.0;

  @override
  void didUpdateWidget(WeatherContentPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    horizontalTotal = MediaQuery.of(context).size.width;
    CityBloc cityBloc = CityProvider.of(context);
    return GestureDetector(
      onHorizontalDragStart: (details) {
        setState(() {
          horizontalOffset = 0.0;
        });
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          horizontalOffset += details.delta.dx;
        });
      },
      onHorizontalDragEnd: (details) {
        if (horizontalOffset > (horizontalTotal / 3)) {
          cityBloc.cityStepChoose.add(ChooseStep.previous);
        } else if (horizontalOffset < (-horizontalTotal / 3)) {
          cityBloc.cityStepChoose.add(ChooseStep.next);
        } else {
          setState(() {});
        }
        horizontalOffset = 0.0;
      },
      child: Opacity(
        opacity: 1 - (horizontalOffset / horizontalTotal).abs(),
        child: ListView(
          children: _buildWeatherList(),
        ),
      ),
    );
  }

  List<Widget> _buildWeatherList() {
    if (widget.weather == null) {
      return <Widget>[Text('')];
    }
    return <Widget>[
      SizedBox(
        height: 320.0,
      ),
      _buildWeatherNow(widget.weather.weatherNow),
      const SizedBox(
        height: 56.0,
      ),
      Container(
        height: 160.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: widget.weather.weatherHourlys
              .map((weatherHourly) => _buildHourly(weatherHourly))
              .toList(),
        ),
      ),
      const SizedBox(
        height: 16.0,
      ),
      Column(
        children: widget.weather.weatherForecasts
            .map((weatherForecast) => _buildWeatherForecast(weatherForecast))
            .toList(),
      ),
      const SizedBox(
        height: 24.0,
      ),
      Column(
        children: widget.weather.lifeStyles
            .map((lifeStyle) => _buildLifeStyle(lifeStyle))
            .toList(),
      ),
      const SizedBox(
        height: 16.0,
      ),
    ];
  }

  Widget _buildWeatherNow(WeatherNow weatherNow) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "${weatherNow.condTxt}",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        Text(
          "${weatherNow.tmp}℃",
          style: TextStyle(
            fontSize: 64.0,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          "${weatherNow.windDir} ${weatherNow.windScDesc}",
          style: TextStyle(
            fontSize: 14.0,
          ),
        )
      ],
    );
  }

  Widget _buildHourly(WeatherHourly weatherHourly) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            weatherHourly.time.substring(10),
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          SizedBox(
            width: 32.0,
            height: 32.0,
            child: Image.asset('icons/${weatherHourly.condCode}.png'),
          ),
          SizedBox(
            height: 2.0,
          ),
          Text(
            "${weatherHourly.tmp}℃",
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherForecast(WeatherForecast weatherForecast) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            weatherForecast.date,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Expanded(
            child: Container(
                height: 48.0,
                width: 48.0,
                padding: EdgeInsets.all(8.0),
                child: Image.asset('icons/${weatherForecast.condCodeD}.png')),
          ),
          Text(
            "${weatherForecast.tmpMax}℃/${weatherForecast.tmpMin}℃",
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLifeStyle(LifeStyle lifeStyle) {
    return ListTile(
      title: Text("${lifeStyle.typeDesc}：${lifeStyle.brf}"),
      subtitle: Text(lifeStyle.txt),
    );
  }
}
