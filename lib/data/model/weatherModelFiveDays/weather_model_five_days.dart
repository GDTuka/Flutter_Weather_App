import 'package:json_annotation/json_annotation.dart';
import 'package:weather_app/data/services/api_servisec.dart';

part 'weather_model_five_days.g.dart';

@JsonSerializable()
class FiveDayWeather {
  double lat;
  double lon;
  String timezone;
  int timezoneOffset;
  List<Daily> daily;

  FiveDayWeather(this.lat, this.lon, this.timezone, this.timezoneOffset, this.daily);
  factory FiveDayWeather.fromJson(Map<String, dynamic> json) => _$FiveDayWeatherFromJson(json);
  Map<String, dynamic> toJson() => _$FiveDayWeatherToJson(this);
}

@JsonSerializable()
class Daily {
  int dt;
  int sunrise;
  int sunset;
  int moonrise;
  int moonset;
  double? moonPhase;
  Temp temp;
  FeelsLike feelsLike;
  int pressure;
  int humidity;
  double dewPoint;
  double windSpeed;
  int windDeg;
  double windGust;
  List<Weather> weather;
  int clouds;
  double pop;
  double? rain;
  double? uvi;

  Daily(this.dt, this.sunrise, this.sunset, this.moonrise, this.moonset, this.moonPhase, this.temp, this.feelsLike, this.pressure, this.humidity, this.dewPoint, this.windSpeed, this.windDeg, this.windGust, this.weather, this.clouds, this.pop, this.rain, this.uvi);
  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);
  Map<String, dynamic> toJson() => _$DailyToJson(this);
}

@JsonSerializable()
class Temp {
  double day;
  double min;
  double max;
  double night;
  double eve;
  double morn;

  Temp(this.day, this.min, this.max, this.night, this.eve, this.morn);
  factory Temp.fromJson(Map<String, dynamic> json) => _$TempFromJson(json);
  Map<String, dynamic> toJson() => _$TempToJson(this);
}

@JsonSerializable()
class FeelsLike {
  double day;
  double night;
  double eve;
  double morn;

  FeelsLike(this.day, this.night, this.eve, this.morn);
  factory FeelsLike.fromJson(Map<String, dynamic> json) => _$FeelsLikeFromJson(json);
  Map<String, dynamic> toJson() => _$FeelsLikeToJson(this);
}

@JsonSerializable()
class Weather {
  int id;
  String main;
  String description;
  String icon;

  Weather(this.id, this.main, this.description, this.icon);
  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
