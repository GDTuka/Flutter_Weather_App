import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/data/model/weatherModelFiveDays/weather_model_five_days.dart';
import 'package:weather_app/data/model/weather_model_current.dart';

abstract class Weather {
  Future<String> generateWeatherApiLink(bool now);

  Future<MainWeather> getCurrentWeatherData();

  Future<FiveDayWeather> getFiveDayWeatherData();
}

class WeatherApi extends Weather {
  @override
  Future<String> generateWeatherApiLink(bool now) async {
    // bool now parametr check if users need link that returns current weather in http request, else returns link that return 5 day weather with http request
    // check All execption, they will be hanlde by what returned in HomeBloc
    bool isServicesAvaible = await Geolocator.isLocationServiceEnabled();
    if (!isServicesAvaible) {
      return "not available";
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return "permisions denied";
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return "denied forever";
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    double lat = position.latitude;
    double lon = position.longitude;
    String key = "bab303583250e1deb1bd08379c680633";
    String serverLink = "https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${key}";
    if (now) {
      serverLink = "https://api.openweathermap.org/data/2.5/onecall?lat=${lat}&lon=${lon}&exclude=current,hourly,minutely,alerts&appid=$key";
    }
    return serverLink;
  }

  @override
  Future<MainWeather> getCurrentWeatherData() async {
    String serverLink = await generateWeatherApiLink(false);
    http.Response response;
    response = await http.post(Uri.parse(serverLink));
    print(response.body);
    MainWeather weather = MainWeather.fromJson(jsonDecode(response.body));
    return weather;
  }

  @override
  Future<FiveDayWeather> getFiveDayWeatherData() async {
    String serverLink = await generateWeatherApiLink(true);
    http.Response response;
    response = await http.post(Uri.parse(serverLink));
    FiveDayWeather weather = FiveDayWeather.fromJson(jsonDecode(response.body));
    return weather;
  }
}
