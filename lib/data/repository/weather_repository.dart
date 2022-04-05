import 'package:weather_app/data/model/weatherModel.dart';
import 'package:weather_app/data/services/api_servisec.dart';

class WeatherRepository {
  WeatherRepository({required WeatherApi weatherApi}) : _weatherApi = weatherApi;
  WeatherApi _weatherApi;
  Future<String> generateServerLink() async => _weatherApi.generateWeatherApiLink();
  Future<MainWeather> getCurrentWeahter() async => _weatherApi.getCurrentWeatherData();
  Future<String> getFiveDayWeather() async => _weatherApi.getFiveDayWeatherData();
}
