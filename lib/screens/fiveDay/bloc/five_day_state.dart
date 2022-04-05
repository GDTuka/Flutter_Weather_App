import 'package:weather_app/data/model/weatherModelFiveDays/weather_model_five_days.dart';

abstract class FiveDayStates {}

class WeatherLoadingState extends FiveDayStates {}

class WeatherLoadedState extends FiveDayStates {
  FiveDayWeather weather;
  WeatherLoadedState(this.weather);
}

class NavigateToHomeState extends FiveDayStates {}

class ShareState extends FiveDayStates {
  FiveDayWeather weather;
  ShareState(this.weather);
}
