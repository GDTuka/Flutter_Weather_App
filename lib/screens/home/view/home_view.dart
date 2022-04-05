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
      create: (context) => HomeBloc(weatherRepository: context.read<WeatherRepository>())..add(LoadWeatherEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Weather now"),
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
        return Center(child: const CircularProgressIndicator());
      }
      if (state is WeatherLoaded) {
        return Column(
          children: [
            const Center(
              child: Text(""),
            )
          ],
        );
      } else {
        return const Text("some error happend");
      }
    }, listener: (context, state) {
      if (state is NavigateToFiveDayPageEvent) {
        Navigator.pushNamed(context, "/fiveDay");
      }
    });
  }
}
