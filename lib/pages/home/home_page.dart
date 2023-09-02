import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/const/app_colors.dart';
import 'package:weather_app/core/blocs/home/home_bloc.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/pages/home/widgets/city_list.dart';
import 'package:weather_app/pages/home/widgets/city_text_field.dart';
import 'package:weather_app/pages/home/widgets/refresh_button.dart';
import 'package:weather_app/pages/home/widgets/sized_container.dart';
import 'package:weather_app/pages/home/widgets/weather_column.dart';
import 'package:weather_app/utils/weather_status_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final TextEditingController _cityController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  LinearGradient? gradient =
      const LinearGradient(colors: [AppColors.blue1Color, AppColors.blue2Color]);

  @override
  void dispose() {
    _cityController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is LoadedHomeState &&
              !state.item.hasPermission &&
              state.item.permission?.isNotEmpty == true) {
            _showPermissionSnackBar(context, state.item.permission);
          }
        },
        builder: (context, state) {
          return Scaffold(body: _buildWeatherContainer(context, state));
        },
      ),
    );
  }

  Widget _buildWeatherContainer(BuildContext context, HomeState state) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        _searchForWeather();
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is LoadedHomeState) {
            final weather = state.item.weather.isNotEmpty ? state.item.weather[0] : null;
            final mainWeather = state.item.main ?? const Main();
            gradient = (weather?.main ?? WeatherStatus.clear).getGradient();
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: gradient,
              ),
              child: weather == null
                  ? Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).viewPadding.top),
                        const SizedBox(height: 10.0),
                        Center(
                            child: CityTextField(
                          controller: _cityController,
                        )),
                        if ((state.cityList ?? []).isNotEmpty && _cityController.text.isNotEmpty)
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                MediaQuery.removePadding(
                                  context: context,
                                  child: CityList(
                                      cityList: (state.cityList ?? []),
                                      cityController: _cityController,
                                      paddingTop: 0),
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                  child: Center(child: RefreshButton(refresh: _searchForWeather))),
                            ],
                          ),
                        ),
                      ],
                    )
                  : WeatherColumn(
                      cityController: _cityController,
                      scrollController: _scrollController,
                      weather: weather,
                      mainWeather: mainWeather,
                      cityName: state.item.name ?? '',
                      cityList: state.cityList ?? [],
                      forecastWeatherList: state.items,
                      refresh: _searchForWeather,
                    ),
            );
          } else {
            return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: gradient,
                ),
                child: const SizedContainer(CircularProgressIndicator()));
          }
        },
      ),
    );
  }

  void _searchForWeather() async {
    if (_cityController.text.isNotEmpty) {
      context.read<HomeBloc>().add(GetWeatherCityName(_cityController.text));
    } else {
      context.read<HomeBloc>().add(const GetCurrentLocationEvent());
    }
  }

  void _showPermissionSnackBar(BuildContext context, String? permission) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(permission ?? '')),
    );
  }
}
