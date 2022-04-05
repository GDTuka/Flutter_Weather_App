import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/screens/fiveDay/view/five_days.dart';
import 'package:weather_app/screens/home/view/home_view.dart';

class App extends StatelessWidget {
  App({Key? key, required this.weatherRepository}) : super(key: key);
  WeatherRepository weatherRepository;
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: weatherRepository,
      child: AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white, scaffoldBackgroundColor: Colors.white),
      initialRoute: '/',
      routes: {'/': (context) => const Home(), '/fiveDay': (context) => const FiveDay()},
    );
  }
}
