import 'package:weather_app/data/services/api_servisec.dart';

class WeatherRepository {
  WeatherRepository({required WeatherApi weatherApi}) : _weatherApi = weatherApi;
  WeatherApi _weatherApi;
}
