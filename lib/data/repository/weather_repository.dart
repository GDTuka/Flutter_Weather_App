import 'package:weather_app/data/model/weatherModelFiveDays/weather_model_five_days.dart';
import 'package:weather_app/data/model/weather_model_current.dart';
import 'package:weather_app/data/services/api_servisec.dart';

class WeatherRepository {
  WeatherRepository({required WeatherApi weatherApi})
      : _weatherApi = weatherApi;
  final WeatherApi _weatherApi;
  Future<String> generateServerLink(bool now) async =>
      _weatherApi.generateWeatherApiLink(now);
  Future<MainWeather> getCurrentWeahter() async =>
      _weatherApi.getCurrentWeatherData();
  Future<FiveDayWeather> getFiveDayWeather() async =>
      _weatherApi.getFiveDayWeatherData();
}
