import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/const/app_colors.dart';
import 'package:weather_app/const/app_style.dart';
import 'package:weather_app/const/app_texts.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/pages/home/widgets/sized_container.dart';
import 'package:weather_app/utils/weather_status_id_utils.dart';

class WeatherListView extends StatefulWidget {
  final List<WeatherData> forecastWeatherList;
  final ScrollController scrollController;
  const WeatherListView(
      {super.key, required this.forecastWeatherList, required this.scrollController});

  @override
  State<WeatherListView> createState() => _WeatherListViewState();
}

class _WeatherListViewState extends State<WeatherListView> {
  bool forecastWeatherChange = true;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buttonDays(false, '8'),
              _buttonDays(true, '16'),
            ],
          ),
          Expanded(
            child: Scrollbar(
              controller: widget.scrollController,
              thumbVisibility: true,
              thickness: 4,
              radius: const Radius.circular(16.0),
              child: ListView.builder(
                itemCount: forecastWeatherChange ? widget.forecastWeatherList.length : 8,
                controller: widget.scrollController,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final forecastData = widget.forecastWeatherList[index];
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
                                      WeatherStatusIdUtils.getDayName(dateTime.toString()),
                                      style: AppStyle.textStyleDayOfWeek(),
                                    ),
                                    Text(
                                      DateFormat.yMMMd().format(dateTime),
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
                                      child: SizedContainer(
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
          ),
        ],
      ),
    );
  }

  InkWell _buttonDays(bool forecastWeatherChange, String days) {
    return InkWell(
      onTap: () {
        setState(() {
          this.forecastWeatherChange = forecastWeatherChange;
        });
      },
      child: Text(
        '$days days',
        style: AppStyle.textStyleWeatherDays(),
      ),
    );
  }
}
