import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/screens/home/bloc/home_bloc.dart';
import 'package:weather_app/screens/home/bloc/home_events.dart';
import 'package:weather_app/screens/home/bloc/home_states.dart';
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeBloc(weatherRepository: context.read<WeatherRepository>())
            ..add(LoadWeatherEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Weather now"),
          centerTitle: true,
        ),
        body: const HomeView(),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _homeBloc = context.read<HomeBloc>();
    return BlocConsumer<HomeBloc, HomeState>(builder: (context, state) {
      if (state is WeatherLoading ||
          state is NavigateToFiveDayPageEvent ||
          state is ShareState) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is ErrorMessager) {
        return Center(
          child: Text(state.message),
        );
      }
      if (state is WeatherLoaded) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: Text(
                            "Страна : ${state.weather.sys.country}",
                            style: const TextStyle(fontSize: 20),
                          )),
                      Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: Text("Местонахождения : ${state.weather.name}",
                              style: const TextStyle(fontSize: 15))),
                    ],
                  )
                ],
              ),
              Container(
                  width: 150,
                  height: 150,
                  margin: const EdgeInsets.only(top: 50),
                  child: Image.asset(state.weatherPicture)),
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      margin: const EdgeInsets.only(left: 7),
                      child: Image.asset("assets/weatherPic/cloud.png"),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 7),
                      child: Text("${state.weather.clouds.all}%",
                          style: const TextStyle(fontSize: 20)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 7),
                      width: 25,
                      height: 25,
                      child: Image.asset("assets/weatherPic/wind.png"),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 7),
                      child: Text("${state.weather.wind.speed}м/c",
                          style: const TextStyle(fontSize: 20)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 7),
                      width: 25,
                      height: 25,
                      child: Image.asset("assets/weatherPic/visibility.png"),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 7),
                      child: Text("${state.weather.visibility}%",
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${state.weather.main.temp}℃ ",
                        style: const TextStyle(fontSize: 70),
                      ),
                    ],
                  )),
              Column(
                children: [
                  InkWell(
                      onTap: () {
                        _homeBloc
                            .add(NavigateToFiveDayPageEvent(state.weather));
                      },
                      child: Center(
                        child: Container(
                            width: 300,
                            height: 50,
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("Посмотреть погоду на 5 дней",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                  ],
                                )
                              ],
                            )),
                      )),
                  InkWell(
                      onTap: () {
                        _homeBloc.add(ShareEvent(state.weather));
                      },
                      child: Center(
                        child: Container(
                            width: 300,
                            height: 50,
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("Поделиться погодой",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                  ],
                                )
                              ],
                            )),
                      ))
                ],
              )
            ],
          ),
        );
      } else {
        return const Text("some Erro");
      }
    }, listener: (context, state) {
      if (state is NavigateToOtherPage) {
        Navigator.pushNamed(context, "/fiveDay", arguments: state.weather);
      }
      if (state is ShareState) {
        String weatherToday =
            "Страна:${state.weather.sys.country}, Местонахождение: ${state.weather.name}, Температур:${state.weather.main.temp}℃ , Скорость ветра:${state.weather.wind.speed}м/c, Облачность:${state.weather.clouds.all}%";
        Share.share(weatherToday);
        if (state.weather.clouds.all > 50) {
          _homeBloc
              .add(BackToWeather(state.weather, "assets/weatherPic/cloud.png"));
        } else if (state.weather.clouds.all < 20) {
          _homeBloc
              .add(BackToWeather(state.weather, "assets/weatherPic/sun.png"));
        } else {
          _homeBloc.add(BackToWeather(
              state.weather, "assets/weatherPic/sun_and_cloud.png"));
        }
      }
    });
  }
}
