import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/const/app_style.dart';
import 'package:weather_app/const/app_texts.dart';
import 'package:weather_app/models/city_data.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/pages/home/widgets/city_list.dart';
import 'package:weather_app/pages/home/widgets/city_text_field.dart';
import 'package:weather_app/pages/home/widgets/sized_container.dart';
import 'package:weather_app/pages/home/widgets/weather_list_view.dart';

class WeatherColumn extends StatelessWidget {
  final Weather? weather;
  final Main mainWeather;
  final String cityName;
  final List<WeatherData> forecastWeatherList;
  final List<LocationData> cityList;
  final TextEditingController cityController;
  final ScrollController scrollController;

  const WeatherColumn({
    super.key,
    required this.weather,
    required this.mainWeather,
    required this.cityName,
    required this.forecastWeatherList,
    required this.cityList,
    required this.cityController,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 15,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).viewPadding.top),
                    const SizedBox(height: 10.0),
                    Center(
                        child: CityTextField(
                      controller: cityController,
                    )),
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
                              SizedContainer(
                                CachedNetworkImage(
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  imageUrl: weather?.icon ?? '',
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
              if (cityList.isNotEmpty && cityController.text.isNotEmpty)
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
                        child: CityList(cityList: cityList, cityController: cityController),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (weather != null)
          Expanded(
            flex: 10,
            child: WeatherListView(
              forecastWeatherList: forecastWeatherList,
              scrollController: scrollController,
            ),
          ),
      ],
    );
  }

  Widget _buildWeatherInfoText(String label, String? value) {
    return Text(
      '$label${value ?? 'N/A'}°C',
      style: AppStyle.textStyleWeatherInfo(),
    );
  }
}
