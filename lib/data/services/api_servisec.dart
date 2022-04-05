import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/data/model/weatherModelFiveDays/weather_model_five_days.dart';
import 'package:weather_app/data/model/weather_model_current.dart';

abstract class Weather {
  Future<String> generateWeatherApiLink(bool now);

  Future<String> getCurrentWeatherData();

  Future<FiveDayWeather> getFiveDayWeatherData();

  Future<List<bool>> checkIfServerAlive();
}

class WeatherApi extends Weather {
  @override
  Future<String> generateWeatherApiLink(bool now) async {
    // bool now parametr check if users need link that returns current weather in http request, else returns link that return 5 day weather with http request
    bool isServicesAvaible = await Geolocator.isLocationServiceEnabled();
    if (!isServicesAvaible) {
      return "Геолокация недостпуна, вы не можете узнать погоду";
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print(permission);
      if (permission == LocationPermission.denied) {
        return "Нет разрешения на геолоакцию";
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return "Невозможно получить разрешение на геологацию";
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double lat = position.latitude;
    double lon = position.longitude;
    String key = "bab303583250e1deb1bd08379c680633";
    String serverLink =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$key";
    if (now) {
      serverLink =
          "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=current,hourly,minutely,alerts&appid=$key";
    }
    return serverLink;
  }

  @override
  Future<String> getCurrentWeatherData() async {
    String serverLink = await generateWeatherApiLink(false);
    if (serverLink == "Невозможно получить разрешение на геологацию" ||
        serverLink == "Нет разрешения на геолоакцию" ||
        serverLink == "Геолокация недостпуна, вы не можете узнать погоду") {
      return serverLink;
    }
    http.Response response;
    response = await http.post(Uri.parse(serverLink));
    String weather = response.body;
    return weather;
  }

  @override
  Future<FiveDayWeather> getFiveDayWeatherData() async {
    String serverLink = await generateWeatherApiLink(true);
    http.Response response;
    response = await http.post(Uri.parse(serverLink));
    FiveDayWeather weather = FiveDayWeather.fromJson(jsonDecode(response.body));
    for (int i = 0; i < weather.daily.length; i++) {
      weather.daily[i].temp.morn =
          (weather.daily[i].temp.morn - 273.15).roundToDouble();
      weather.daily[i].temp.day =
          (weather.daily[i].temp.day - 273.15).roundToDouble();
      weather.daily[i].temp.night =
          (weather.daily[i].temp.night - 273.15).roundToDouble();
    }
    return weather;
  }

  // check severs, first value of array says alive or not currentWeatherServerLink, second CheckIf alive FiveDayServerLink
  @override
  Future<List<bool>> checkIfServerAlive() async {
    List<bool> aliveOrNot = [];
    String currentWeatherServerLink = await generateWeatherApiLink(false);
    String fiveDayWeatherServerLink = await generateWeatherApiLink(true);

    http.Response currentWeatherResponse;
    http.Response fiveDayweatherResponse;

    currentWeatherResponse =
        await http.post(Uri.parse(currentWeatherServerLink));
    fiveDayweatherResponse =
        await http.post(Uri.parse(fiveDayWeatherServerLink));

    if (currentWeatherResponse.statusCode == 200) {
      aliveOrNot.add(true);
    } else {
      aliveOrNot.add(false);
    }

    if (fiveDayweatherResponse.statusCode == 200) {
      aliveOrNot.add(true);
    } else {
      aliveOrNot.add(false);
    }
    return aliveOrNot;
  }
}
