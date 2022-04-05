import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/model/weather_model_current.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/screens/home/bloc/home_events.dart';
import 'package:weather_app/screens/home/bloc/home_states.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  final WeatherRepository _repository;
  HomeBloc({required WeatherRepository weatherRepository})
      : _repository = weatherRepository,
        super(WeatherLoading()) {
    on<LoadWeatherEvent>((event, emit) => _loadWeather(event, emit));
    on<NavigateToFiveDayPageEvent>(
        (event, emit) => _navigateToFiveDayPage(event, emit));
  }

  Future<void> _loadWeather(LoadWeatherEvent event, Emitter emit) async {
    emit(WeatherLoading());
    try {
      MainWeather weather = await _repository.getCurrentWeahter();

      if (weather.clouds.all > 50) {
        emit(WeatherLoaded(weather, "assets/weatherPic/cloud.png"));
      } else if (weather.clouds.all < 20) {
        emit(WeatherLoaded(weather, "assets/weatherPic/sun.png"));
      } else {
        emit(WeatherLoaded(weather, "assets/weatherPic/sun_and_cloud.png"));
      }
    } catch (e) {}
  }

  Future<void> _navigateToFiveDayPage(
      NavigateToFiveDayPageEvent event, Emitter emit) async {
    emit(NavigateToOtherPage());
  }
}
