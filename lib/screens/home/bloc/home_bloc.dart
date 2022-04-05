import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
    on<ShareEvent>((event, emit) => _share(event, emit));
    on<BackToWeather>((event, emit) => _backToWeather(event, emit));
    on<CheckIfLocationAvailable>(
        (event, emit) => _checkIfLocationAreAvailable(event, emit));
  }

  Future<void> _loadWeather(LoadWeatherEvent event, Emitter emit) async {
    emit(WeatherLoading());
    bool networkConnection = await InternetConnectionChecker().hasConnection;
    if (networkConnection) {
      try {
        String parsedWeather = await _repository.getCurrentWeahter();
        // send users error if it exist
        if (parsedWeather ==
            "Геолокация недостпуна, вы не можете узнать погоду") {
          emit(ErrorMessager(
              "Геолокация недостпуна, вы не можете узнать погоду"));
        } else if (parsedWeather == "Нет разрешения на геолоакцию") {
          emit(ErrorMessager("Нет разрешения на геолоакцию"));
        } else if (parsedWeather ==
            "Невозможно получить разрешение на геологацию") {
          emit(ErrorMessager("Невозможно получить разрешение на геологацию"));
        } else {
          MainWeather weather = MainWeather.fromJson(jsonDecode(parsedWeather));
          weather.main.temp = (weather.main.temp - 273.15).roundToDouble();
          weather.visibility = weather.visibility ~/ 100;
          if (weather.clouds.all > 50) {
            emit(WeatherLoaded(weather, "assets/weatherPic/cloud.png"));
          } else if (weather.clouds.all < 20) {
            emit(WeatherLoaded(weather, "assets/weatherPic/sun.png"));
          } else {
            emit(WeatherLoaded(weather, "assets/weatherPic/sun_and_cloud.png"));
          }
        }
      } catch (e) {
        List<bool> aliveOrNot = await _repository.checkIfServerLinksAlive();
        if (aliveOrNot[0] == false && aliveOrNot[1] == true) {
          emit(ErrorMessager(
              "На сервер произошла ошибка, невозможно получить данные, пожалуйста напишите в техподдержку"));
        } else {
          emit(ErrorMessager(
              "Произошла ошибка на стороне клиета, обртитесь в техподдержку"));
        }
      }
    } else {
      emit(ErrorMessager("Нет интернет соединения"));
    }
  }

  Future<void> _navigateToFiveDayPage(
      NavigateToFiveDayPageEvent event, Emitter emit) async {
    emit(NavigateToOtherPage(event.weather));
  }

  // this ShareState parametrs, are for show weather data when userrs decide in wich application they want to send weather text
  Future<void> _share(ShareEvent event, Emitter emit) async {
    if (event.weather.clouds.all > 50) {
      emit(ShareState(event.weather, "assets/weatherPic/cloud.png"));
    } else if (event.weather.clouds.all < 20) {
      emit(ShareState(event.weather, "assets/weatherPic/sun.png"));
    } else {
      emit(ShareState(event.weather, "assets/weatherPic/sun_and_cloud.png"));
    }
  }

  /// Return weather data without loading it again
  Future<void> _backToWeather(BackToWeather event, Emitter emit) async {
    emit(WeatherLoaded(event.weather, event.weatherPicture));
  }

  Future<void> _checkIfLocationAreAvailable(
      CheckIfLocationAvailable event, Emitter emit) async {
    bool isServicesAvaible = await Geolocator.isLocationServiceEnabled();
    if (!isServicesAvaible) {
      emit(ErrorMessager("Геолокация недостпуна, вы не можете узнать погоду"));
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(ErrorMessager("Нет разрешения на геолоакцию"));
      }
    }
    if (permission == LocationPermission.deniedForever) {
      emit(ErrorMessager("Невозможно получить разрешение на геологацию"));
    }
  }
}
