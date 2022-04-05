class MainWeather {
  Coord coord;
  List<Weather> weather;
  String base;
  Main main;
  int visibility;
  Wind wind;
  Clouds clouds;
  int dt;
  Sys sys;
  int timezone;
  int id;
  String name;
  int cod;

  MainWeather(this.coord, this.weather, this.base, this.main, this.visibility, this.wind, this.clouds, this.dt, this.sys, this.timezone, this.id, this.name, this.cod);
}

class Coord {
  double lon;
  double lat;

  Coord(this.lon, this.lat);
}

class Weather {
  int id;
  String main;
  String description;
  String icon;

  Weather(this.id, this.main, this.description, this.icon);
}

class Main {
  double temp;
  double feelsLike;
  double tempMin;
  double tempMax;
  int pressure;
  int humidity;

  Main(this.temp, this.feelsLike, this.tempMin, this.tempMax, this.pressure, this.humidity);
}

class Wind {
  double speed;
  int deg;

  Wind(this.speed, this.deg);
}

class Clouds {
  int all;

  Clouds(this.all);
}

class Sys {
  int type;
  int id;
  double message;
  String country;
  int sunrise;
  int sunset;

  Sys(this.type, this.id, this.message, this.country, this.sunrise, this.sunset);
}
