import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/app/obsever.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/data/services/api_servisec.dart';

import 'app/app.dart';

void main() {
  WeatherApi weatherApi = WeatherApi();
  final weatherRepository = WeatherRepository(weatherApi: weatherApi);
  FlutterError.onError = (details) {
    log(details.exception.toString(), stackTrace: details.stack);
  };

  runZonedGuarded(() async {
    await BlocOverrides.runZoned(
        () async => runApp(App(
              weatherRepository: weatherRepository,
            )),
        blocObserver: AppBlocObserver());
  }, (error, stack) => log(error.toString(), stackTrace: stack));
}
