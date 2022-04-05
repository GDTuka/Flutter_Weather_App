import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/model/weatherModelFiveDays/weather_model_five_days.dart';
import 'package:weather_app/data/model/weather_model_current.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/screens/fiveDay/bloc/five_day_bloc.dart';
import 'package:weather_app/screens/fiveDay/bloc/five_day_event.dart';
import 'package:weather_app/screens/fiveDay/bloc/five_day_state.dart';

class FiveDay extends StatefulWidget {
  const FiveDay({Key? key}) : super(key: key);

  @override
  State<FiveDay> createState() => _FiveDayState();
}

class _FiveDayState extends State<FiveDay> {
  @override
  Widget build(BuildContext context) {
    final MainWeather _weather =
        ModalRoute.of(context)!.settings.arguments as MainWeather;
    return BlocProvider(
      create: (context) =>
          FiveDayBloc(weatherRepository: context.read<WeatherRepository>())
            ..add(LoadWeatherEvent()),
      child: WillPopScope(
          onWillPop: () async {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            return false;
          },
          child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Five day Weather",
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/", (route) => false);
                  },
                ),
              ),
              body: FiveDaysView(
                currentWeather: _weather,
              ))),
    );
  }
}

class FiveDaysView extends StatelessWidget {
  FiveDaysView({Key? key, required this.currentWeather}) : super(key: key);
  MainWeather currentWeather;
  @override
  Widget build(BuildContext context) {
    final _fiveDayBloc = context.read<FiveDayBloc>();
    return BlocConsumer<FiveDayBloc, FiveDayStates>(
        builder: (context, state) {
          if (state is WeatherLoadingState || state is NavigateToHomeState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is WeatherLoadedState) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Text("Местоположение:${currentWeather.name}"),
                      )
                    ],
                  ),
                  Container(
                    height: 200,
                    margin: const EdgeInsets.only(top: 100),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.weather.daily.length,
                      itemBuilder: (context, index) {
                        return Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blueAccent, width: 2),
                                borderRadius: BorderRadius.circular(10)),
                            width: 200,
                            margin: const EdgeInsets.only(left: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      "Температура",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                        "Утро:${state.weather.daily[index].temp.morn}℃ ",
                                        style: const TextStyle(fontSize: 17)),
                                    Text(
                                        "День:${state.weather.daily[index].temp.day}℃ ",
                                        style: const TextStyle(fontSize: 17)),
                                    Text(
                                        "Ночь:${state.weather.daily[index].temp.night}℃ ",
                                        style: const TextStyle(fontSize: 17)),
                                    Text(
                                        "Облачность:${state.weather.daily[index].clouds}%",
                                        style: const TextStyle(fontSize: 17)),
                                    const Text("Вероятность дождя",
                                        style: TextStyle(fontSize: 20)),
                                  ],
                                ),
                              ],
                            ));
                      },
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Center(
              child: Text("Some Error"),
            );
          }
        },
        listener: (context, state) {});
  }
}
