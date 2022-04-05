import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocProvider(create: (context) => FiveDayBloc(weatherRepository: context.read<WeatherRepository>()), child: FiveDaysView());
  }
}

class FiveDaysView extends StatelessWidget {
  const FiveDaysView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _fiveDayBloc = context.read<FiveDayBloc>();
    return BlocConsumer<FiveDayBloc, FiveDayStates>(builder: (context, state) {
      if (state is WeatherLoadingState || state is NavigateToHomeState) {
        return const CircularProgressIndicator();
      }
      if (state is WeatherLoadedState) {
        return Scaffold(
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
                size: 10,
              ),
              onPressed: () {
                _fiveDayBloc.add(NavigateToHomeEvent());
              },
            ),
          ),
          body: Center(child: Text("FiveDay")),
        );
      } else {
        return const Center(
          child: Text("Some Error"),
        );
      }
    }, listener: (context, state) {
      if (state is NavigateToHomeState) {
        Navigator.pushNamed(context, '/home');
      }
    });
  }
}
