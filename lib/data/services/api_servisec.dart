import 'package:geolocator/geolocator.dart';

abstract class Weather {
  Future<String> generateWeatherApiLink();
  Future<String> getCurrentWeatherData();
  Future<String> getFiveDayWeatherData();
}

class WeatherApi extends Weather {
  @override
  Future<String> generateWeatherApiLink() {
    // TODO: implement generateWeatherApiLink
    throw UnimplementedError();
  }

  @override
  Future<String> getCurrentWeatherData() {
    // TODO: implement getCurrentWeatherData
    throw UnimplementedError();
  }

  @override
  Future<String> getFiveDayWeatherData() {
    // TODO: implement getFiveDayWeatherData
    throw UnimplementedError();
  }
}
