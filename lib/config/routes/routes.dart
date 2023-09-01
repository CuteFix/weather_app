import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/const/app_routes.dart';
import 'package:weather_app/core/blocs/home/home_bloc.dart';
import 'package:weather_app/pages/home/home_page.dart';

var appRoutes = <String, WidgetBuilder>{
  AppRoutes.homePage: (context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
            create: (context) => HomeBloc()..add(const GetCurrentLocationEvent())),
      ],
      child: const HomePage(),
    );
  },
};
