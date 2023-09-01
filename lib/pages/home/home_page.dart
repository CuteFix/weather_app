import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:weather_app/const/app_colors.dart';
import 'package:weather_app/const/app_style.dart';
import 'package:weather_app/const/app_texts.dart';
import 'package:weather_app/core/blocs/home/home_bloc.dart';
import 'package:weather_app/models/city_data.dart';
import 'package:weather_app/models/weather_data.dart';
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
          return Scaffold(
              //appBar: _buildAppBar(),
              body: _buildWeatherContainer(context, state));
        },
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(40.0),
      child: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF70A4F8), Color(0xFFACB6E5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _buildCityTextField(),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              _searchForWeather();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCityTextField() {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 100),
      height: 35,
      child: TextField(
        controller: _cityController,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white2Color,
          hintText: AppTexts.enterCityHint,
          hintStyle: AppStyle.textStyleDayOfWeek(),
          contentPadding: const EdgeInsets.only(left: 10),
        ),
        onChanged: (text) async {
          context.read<HomeBloc>().add(GetListCityEvent(text));
        },
        onSubmitted: (text) {
          if (text.isNotEmpty) {
            context.read<HomeBloc>().add(GetWeatherCityName(text));
          } else {
            context.read<HomeBloc>().add(const GetCurrentLocationEvent());
          }
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
            final wind = state.item.wind ?? const Wind();

            gradient = (weather?.main ?? WeatherStatus.clear).getGradient();
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: gradient,
              ),
              child: _buildWeatherColumn(
                context,
                weather,
                mainWeather,
                wind,
                state.item.name ?? '',
                state.items,
                state.cityList ?? [],
              ),
            );
          } else {
            return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: gradient,
                ),
                child: _sizedContainer(const CircularProgressIndicator()));
          }
        },
      ),
    );
  }

  Column _buildWeatherColumn(
    BuildContext context,
    Weather? weather,
    Main mainWeather,
    Wind wind,
    String cityName,
    List<WeatherData> forecastWeatherList,
    List<LocationData> cityList,
  ) {
    return Column(
      children: [
        Stack(
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).viewPadding.top),
                  const SizedBox(height: 10.0),
                  Center(child: _buildCityTextField()),
                  //  SizedBox(height: MediaQuery.of(context).viewPadding.top),
                  // TextField(
                  //   controller: _cityController,
                  //   style: AppStyle.textStyleCityName(),
                  //   textAlign: TextAlign.center,
                  //   decoration: InputDecoration(
                  //     hintText: AppTexts.enterCityHint,
                  //     hintStyle: AppStyle.textStyleCityName(),
                  //     contentPadding: const EdgeInsets.all(2.0),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: const BorderSide(
                  //         width: 0,
                  //         style: BorderStyle.none,
                  //       ),
                  //     ),
                  //   ),
                  //   onChanged: (text) async {
                  //     context.read<HomeBloc>().add(GetListCityEvent(text));
                  //   },
                  // ),
                  const SizedBox(height: 16.0),
                  Text(
                    cityName,
                    style: AppStyle.textStyleCityName(),
                  ),
                  const SizedBox(height: 16.0),
                  if (weather != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 150.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: AppColors.greyColor.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 20.0,
                                    offset: const Offset(0, 0.0),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: _sizedContainer(
                                CachedNetworkImage(
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  imageUrl: weather.icon ?? '',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              '${mainWeather.temp?.toStringAsFixed(1) ?? 'N/A'}°C',
                              style: AppStyle.textStyleTemperature(),
                            ),
                            _buildWeatherInfoText(
                                AppTexts.minTempLabel, mainWeather.tempMin?.toStringAsFixed(1)),
                            _buildWeatherInfoText(
                                AppTexts.maxTempLabel, mainWeather.tempMax?.toStringAsFixed(1)),
                            const SizedBox(height: 16.0),
                            Text(
                              '${AppTexts.humidityLabel}${mainWeather.humidity?.toString()}%',
                              style: AppStyle.textStyleWeatherInfo(),
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            if (cityList.isNotEmpty && _cityController.text.isNotEmpty)
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).viewPadding.top + 10,
                    ),
                    SizedBox(
                      height: cityList.length * 60,
                      width: (MediaQuery.of(context).size.width - 102),
                      child: ListView.separated(
                        itemCount: cityList.length,
                        itemBuilder: (context, index) {
                          final isLastItem = index == cityList.length - 1;

                          final border = Border(
                            bottom: BorderSide(
                              color: isLastItem ? Colors.transparent : AppColors.white2Color,
                              width: isLastItem ? 0.0 : 1.0,
                            ),
                          );

                          Widget item = InkWell(
                            onTap: () {
                              _selectCity(
                                  '${cityList[index].name ?? ' '},${cityList[index].country ?? ''}');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white2Color,
                                border: border,
                              ),
                              height: 40,
                              width: double.infinity,
                              child: Center(
                                // Center the content horizontally
                                child: ListTile(
                                  title: Column(
                                    children: [
                                      Text(
                                        '${cityList[index].name ?? ' '},${cityList[index].country}',
                                        style: AppStyle.textStyleButton(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );

                          if (isLastItem) {
                            // Wrap the last item with ClipRRect to create a circular border
                            item = ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12.0),
                                bottomRight: Radius.circular(12.0),
                              ),
                              child: item,
                            );
                          }

                          return item;
                        },
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.greyColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        if (weather != null) Expanded(child: _buildWeatherListView(forecastWeatherList)),
      ],
    );
  }

  Widget _buildWeatherInfoText(String label, String? value) {
    return Text(
      '$label${value ?? 'N/A'}°C',
      style: AppStyle.textStyleWeatherInfo(),
    );
  }

  Widget _buildWeatherListView(List<WeatherData> forecastWeatherList) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white2Color,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 10.0,
            offset: const Offset(-5, -4.0),
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        thickness: 4,
        radius: const Radius.circular(16.0),
        child: ListView.builder(
          itemCount: forecastWeatherList.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            final forecastData = forecastWeatherList[index];
            final weather = forecastData.weather.isNotEmpty ? forecastData.weather[0] : null;
            final mainWeather = forecastData.main ?? const Main();
            final dateTime = DateTime.parse(forecastData.dateTime ?? "2022-08-30 15:00:00");

            return Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Column(
                children: [
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getDayOfWeek(forecastData.dt ?? 1),
                                style: AppStyle.textStyleDayOfWeek(),
                              ),
                              Text(
                                '${dateTime.hour}h',
                                style: AppStyle.textStyleDayOfWeek(),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: AppColors.greyColor),
                                child: _sizedContainer(
                                  CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    imageUrl: weather?.icon ?? '',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15.0),
                              Text(
                                '${mainWeather.temp?.toStringAsFixed(1) ?? 'N/A'}°C',
                                style: AppStyle.textStyleDayOfWeek(),
                              ),
                              const SizedBox(width: 15.0),
                              Text(
                                '${AppTexts.humidityLabel}${mainWeather.humidity?.toString()}%',
                                style: AppStyle.textStyleDayOfWeek(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(color: AppColors.greyColor),
                ],
              ),
            );
          },
        ),
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

  void _selectCity(String city) {
    context.read<HomeBloc>().add(GetWeatherCityName(city));
    setState(() {
      _cityController.text = city;
    });
  }

  String _getDayOfWeek(int timestamp) {
    final day = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).weekday;
    switch (day) {
      case DateTime.monday:
        return AppTexts.monday;
      case DateTime.tuesday:
        return AppTexts.tuesday;
      case DateTime.wednesday:
        return AppTexts.wednesday;
      case DateTime.thursday:
        return AppTexts.thursday;
      case DateTime.friday:
        return AppTexts.friday;
      case DateTime.saturday:
        return AppTexts.saturday;
      case DateTime.sunday:
        return AppTexts.sunday;
      default:
        return '';
    }
  }

  Widget _sizedContainer(Widget child) {
    return SizedBox(
      width: 150.0,
      height: 150.0,
      child: Center(child: child),
    );
  }

  void _showPermissionSnackBar(BuildContext context, String? permission) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(permission ?? '')),
    );
  }
}
