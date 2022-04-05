import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/screens/fiveDay/bloc/five_day_event.dart';
import 'package:weather_app/screens/fiveDay/bloc/five_day_state.dart';

class FiveDayBloc extends Bloc<FiveDayEvents, FiveDayStates> {
  WeatherRepository _repository;
  FiveDayBloc({required WeatherRepository weatherRepository})
      : _repository = weatherRepository,
        super(WeatherLoadingState()) {
    on<LoadWeatherEvent>((event, emit) => _loadWeather(event, emit));
    on<NavigateToHomeEvent>((event, emit) => _navigateToHome(event, emit));
  }
  Future<void> _loadWeather(LoadWeatherEvent event, Emitter emit) async {}
  Future<void> _navigateToHome(NavigateToHomeEvent event, Emitter emit) async {
    emit(NavigateToHomeState());
  }
}
