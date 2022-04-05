import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/data/services/api_servisec.dart';
import 'package:weather_app/screens/home/bloc/home_bloc.dart';
import 'package:weather_app/screens/home/bloc/home_events.dart';
import 'package:weather_app/screens/home/bloc/home_states.dart';

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
        body: HomeView(),
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
      if (state is WeatherLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is WeatherLoaded) {
        return Column(
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
                            style: const TextStyle(fontSize: 20))),
                  ],
                )
              ],
            ),
            Container(
                width: 150,
                height: 150,
                margin: const EdgeInsets.only(top: 50),
                child: Image.asset("${state.weatherPicture}")),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    margin: EdgeInsets.only(left: 7),
                    child: Image.asset("assets/weatherPic/cloud.png"),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 7),
                    child: Text("${state.weather.clouds.all}%",
                        style: const TextStyle(fontSize: 20)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 7),
                    width: 25,
                    height: 25,
                    child: Image.asset("assets/weatherPic/wind.png"),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 7),
                    child: Text("${state.weather.wind.speed}м/c",
                        style: const TextStyle(fontSize: 20)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 7),
                    width: 25,
                    height: 25,
                    child: Image.asset("assets/weatherPic/visibility.png"),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 7),
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
            InkWell(
                onTap: () {
                  _homeBloc.add(NavigateToFiveDayPageEvent());
                },
                child: Center(
                  child: Container(
                      width: 300,
                      height: 50,
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          border: Border.all(color: Colors.white, width: 1),
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
                ))
          ],
        );
      } else {
        return const Text("some error happend");
      }
    }, listener: (context, state) {
      if (state is NavigateToOtherPage) {
        Navigator.pushNamed(context, "/fiveDay");
      }
    });
  }
}
