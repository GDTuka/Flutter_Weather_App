import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weather_app/data/model/weatherModelFiveDays/weather_model_five_days.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/screens/fiveDay/bloc/five_day_event.dart';
import 'package:weather_app/screens/fiveDay/bloc/five_day_state.dart';

class FiveDayBloc extends Bloc<FiveDayEvents, FiveDayStates> {
  final WeatherRepository _repository;
  FiveDayBloc({required WeatherRepository weatherRepository})
      : _repository = weatherRepository,
        super(WeatherLoadingState()) {
    on<LoadWeatherEvent>((event, emit) => _loadWeather(event, emit));
    on<NavigateToHomeEvent>((event, emit) => _navigateToHome(event, emit));
    on<ShareEvent>((event, emit) => _share(event, emit));
    on<BackToWeatherEvent>((event, emit) => _backToWeather(event, emit));
  }
  Future<void> _loadWeather(LoadWeatherEvent event, Emitter emit) async {
    emit(WeatherLoadingState());
    bool networkConnection = await InternetConnectionChecker().hasConnection;
    if (networkConnection) {
      try {
        FiveDayWeather weather = await _repository.getFiveDayWeather();
        emit(WeatherLoadedState(weather));
      } catch (e) {
        List<bool> aliveOrNot = await _repository.checkIfServerLinksAlive();
        if (aliveOrNot[0] == false && aliveOrNot[1] == true) {
          emit(ErrorMessenge(
              "На сервер произошла ошибка, невозможно получить данные, пожалуйста напишите в техподдержку"));
        } else {
          emit(ErrorMessenge(
              "Произошла ошибка на стороне клиета, обртитесь в техподдержку"));
        }
      }
    } else {
      emit(ErrorMessenge("Нет интернет Соединения"));
    }
  }

  Future<void> _navigateToHome(NavigateToHomeEvent event, Emitter emit) async {
    emit(NavigateToHomeState());
  }

  Future<void> _share(ShareEvent event, Emitter emit) async {
    emit(ShareState(event.weather));
  }

  Future<void> _backToWeather(BackToWeatherEvent event, Emitter emit) async {
    emit(WeatherLoadedState(event.weather));
  }
}
