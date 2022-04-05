import 'package:weather_app/data/model/weather_model_current.dart';
import 'package:weather_app/screens/home/view/home_view.dart';

abstract class HomeEvents {}

class LoadWeatherEvent extends HomeEvents {}

class NavigateToFiveDayPageEvent extends HomeEvents {
  MainWeather weather;
  NavigateToFiveDayPageEvent(this.weather);
}

class ShareEvent extends HomeEvents {
  MainWeather weather;
  ShareEvent(this.weather);
}

class BackToWeather extends HomeEvents {
  MainWeather weather;
  String weatherPicture;
  BackToWeather(this.weather, this.weatherPicture);
}

class CheckIfLocationAvailable extends HomeEvents {}
