import 'package:weather_app/data/model/weatherModelFiveDays/weather_model_five_days.dart';

abstract class FiveDayEvents {}

class LoadWeatherEvent extends FiveDayEvents {}

class NavigateToHomeEvent extends FiveDayEvents {}

class ShareEvent extends FiveDayEvents {
  FiveDayWeather weather;
  ShareEvent(this.weather);
}

class BackToWeatherEvent extends FiveDayEvents {
  FiveDayWeather weather;
  BackToWeatherEvent(this.weather);
}
