import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/screens/home/bloc/home_events.dart';
import 'package:weather_app/screens/home/bloc/home_states.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  final WeatherRepository _repository;
  HomeBloc({required WeatherRepository weatherRepository})
      : _repository = weatherRepository,
        super(WeatherLoading()) {
    on<LoadWeatherEvent>((event, emit) => _loadWeather(event, emit));
    on<NavigateToFiveDayPageEvent>((event, emit) => _navigateToFiveDayPage(event, emit));
  }

  Future<void> _loadWeather(LoadWeatherEvent event, Emitter emit) async {
    await _repository.getCurrentWeahter();
  }

  Future<void> _navigateToFiveDayPage(NavigateToFiveDayPageEvent event, Emitter emit) async {
    emit(NavigateToFiveDayPageEvent());
  }
}
