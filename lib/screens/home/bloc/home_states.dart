import 'package:weather_app/data/model/weather_model_current.dart';

abstract class HomeState {}

class WeatherLoading extends HomeState {}

class WeatherLoaded extends HomeState {
  MainWeather weather;
  String weatherPicture;
  WeatherLoaded(this.weather, this.weatherPicture);
}

class NavigateToOtherPage extends HomeState {
  MainWeather weather;
  NavigateToOtherPage(this.weather);
}

class ShareState extends HomeState {
  MainWeather weather;
  String weatherPicture;
  ShareState(this.weather, this.weatherPicture);
}

class ErrorMessager extends HomeState {
  String message;
  ErrorMessager(this.message);
}
