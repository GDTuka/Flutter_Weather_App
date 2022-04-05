import 'package:weather_app/data/model/weather_model_current.dart';
import 'package:weather_app/screens/home/view/home_view.dart';

abstract class HomeState {}

class WeatherLoading extends HomeState {}

class WeatherLoaded extends HomeState {
  MainWeather weather;
  String weatherPicture;
  WeatherLoaded(this.weather,this.weatherPicture);
}

class NavigateToOtherPage extends HomeState {}
