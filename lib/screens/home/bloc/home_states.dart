import 'package:weather_app/screens/home/view/home_view.dart';

abstract class HomeState {}

class WeatherLoading extends HomeState {}

class WeatherLoaded extends HomeState {}

class NavigateToOtherPage extends HomeState {}
