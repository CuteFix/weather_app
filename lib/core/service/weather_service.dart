import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/const/app_texts.dart';
import 'package:weather_app/core/service/query/get/get_query.dart';
import 'package:weather_app/models/permission_data.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/models/weather_forecast_data.dart';
import 'package:weather_app/utils/weather_status_id_utils.dart';

abstract class IWeatherService {
  Future<WeatherData?> getCurrentWeatherByLocationOrCurrentLocation(
      String cityName, PermissionData permission);
  Future<List<WeatherData>> getForecastWeatherByLocationOrCurrentLocation(
      String cityName, PermissionData permission);
  Future<PermissionData> handleLocationPermission();
}

class WeatherService implements IWeatherService {
  final Dio dio;

  WeatherService(this.dio);
  @override
  Future<WeatherData?> getCurrentWeatherByLocationOrCurrentLocation(
      String cityName, PermissionData permission) async {
    try {
      final Response response16Days;
      final List<Placemark>? placeMark;

      if (cityName.isNotEmpty) {
        final locations = await locationFromAddress(cityName);
        placeMark =
            await placemarkFromCoordinates(locations.first.latitude, locations.first.longitude);
        final query = GetQuery.getForecastWeatherByCoordinates(
          latitude: locations.first.latitude,
          longitude: locations.first.longitude,
          forecastDays: 1,
        ).buildQuery();

        response16Days = await dio.get(query);
      } else {
        if (permission.hasPermission) {
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          placeMark = await placemarkFromCoordinates(position.latitude, position.longitude);
          final query = GetQuery.getForecastWeatherByCoordinates(
            latitude: position.latitude,
            longitude: position.longitude,
            forecastDays: 1,
          ).buildQuery();

          response16Days = await dio.get(query);
        } else {
          return null;
        }
      }

      final responseData = response16Days.data;
      final weatherForecastData = WeatherForecastData.fromJson(responseData);
      final currentWeather = CurrentWeather.fromJson(responseData['current_weather']);

      int sumRelativeHumidity = 0;

      for (final number in weatherForecastData.hourlyRelativeHumidity) {
        if (number != null) {
          sumRelativeHumidity += number;
        }
      }

      sumRelativeHumidity ~/= 24;

      final double temperature = currentWeather.temperature;
      final int weatherCode = currentWeather.weatherCode;
      final String? city = placeMark.isNotEmpty == true ? placeMark[0].locality : '';
      final double? maxTemp = weatherForecastData.temperature2mMax?.isNotEmpty == true
          ? weatherForecastData.temperature2mMax![0]
          : 0;
      final double? minTemp = weatherForecastData.temperature2mMin?.isNotEmpty == true
          ? weatherForecastData.temperature2mMin![0]
          : 0;

      final weatherData = WeatherData(
        name: city,
        main: Main(
            temp: temperature, humidity: sumRelativeHumidity, tempMax: maxTemp, tempMin: minTemp),
        weather: [
          Weather(
            description: '',
            main: WeatherStatusIdUtils.mapWeatherCodeToStatus(weatherCode),
            icon: GetQuery.getIconUrl(
              WeatherStatusIdUtils.mapWeatherStatusToCodeIcon(
                WeatherStatusIdUtils.mapWeatherCodeToStatus(weatherCode),
              ),
            ),
          )
        ],
      );

      return weatherData.copyWith(
          permission: permission.permissionText, hasPermission: permission.hasPermission);
    } catch (e) {
      return _handleDioException(e);
    }
  }

  @override
  Future<List<WeatherData>> getForecastWeatherByLocationOrCurrentLocation(
      String cityName, PermissionData permission) async {
    try {
      final Response response16Days;

      if (cityName.isNotEmpty) {
        final locations = await locationFromAddress(cityName);
        final query = GetQuery.getForecastWeatherByCoordinates(
          latitude: locations.first.latitude,
          longitude: locations.first.longitude,
          forecastDays: 16,
        ).buildQuery();

        response16Days = await dio.get(query);
      } else {
        if (permission.hasPermission) {
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          final query = GetQuery.getForecastWeatherByCoordinates(
            latitude: position.latitude,
            longitude: position.longitude,
            forecastDays: 16,
          ).buildQuery();

          response16Days = await dio.get(query);
        } else {
          return [];
        }
      }

      final responseData = response16Days.data;
      final weatherForecastData = WeatherForecastData.fromJson(responseData);
      final weatherDataList = <WeatherData>[];

      final hourlyTemperatureList = <double?>[];
      final hourlyRelativehumidityList = <int?>[];

      for (int i = 0; i < weatherForecastData.hourlyTemperature.length; i += 24) {
        final slice = weatherForecastData.hourlyTemperature.sublist(i, i + 24);
        final slice2 = weatherForecastData.hourlyRelativeHumidity.sublist(i, i + 24);

        final validValues = slice.where((value) => value != null);
        final validValues2 = slice2.where((value) => value != null);

        if (validValues.isNotEmpty && validValues2.isNotEmpty) {
          final average = validValues.reduce((a, b) => a! + b!)! / validValues.length;
          final average2 = validValues2.reduce((a, b) => a! + b!)! ~/ validValues2.length;
          hourlyTemperatureList.add(average);
          hourlyRelativehumidityList.add(average2);
        } else {
          hourlyTemperatureList.add(null);
          hourlyRelativehumidityList.add(null);
        }
      }

      for (int i = 0; i < weatherForecastData.dailyTime.length; i++) {
        final dailyTime = weatherForecastData.dailyTime[i];
        final hourlyTemperature = hourlyTemperatureList[i] ?? 0;
        final hourlyRelativeHumidity = hourlyRelativehumidityList[i] ?? 0;
        final weatherCode = weatherForecastData.weatherCode[i];

        final weatherData = WeatherData(
          dateTime: dailyTime,
          main: Main(temp: hourlyTemperature, humidity: hourlyRelativeHumidity),
          weather: [
            Weather(
              description: '',
              icon: GetQuery.getIconUrl(
                WeatherStatusIdUtils.mapWeatherStatusToCodeIcon(
                  WeatherStatusIdUtils.mapWeatherCodeToStatus(weatherCode),
                ),
              ),
            )
          ],
        );

        weatherDataList.add(weatherData);
      }

      return weatherDataList;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<PermissionData> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const PermissionData(
        hasPermission: false,
        permissionText: AppTexts.locationServiceDisabled,
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const PermissionData(
          hasPermission: false,
          permissionText: AppTexts.locationPermissionsDenied,
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return const PermissionData(
        hasPermission: false,
        permissionText: AppTexts.locationPermissionsDeniedForever,
      );
    }

    return const PermissionData(
      hasPermission: true,
      permissionText: AppTexts.locationPermissionsAvailable,
    );
  }

  WeatherData _handleDioException(dynamic e) {
    if (e is DioException) {
      if (e.response != null) {
        debugPrint(AppTexts.dioError);
        debugPrint('STATUS: ${e.response?.statusCode}');
        debugPrint('DATA: ${e.response?.data}');
        debugPrint('HEADERS: ${e.response?.headers}');
        return WeatherData().copyWith(permission: e.response?.data['message']);
      } else {
        debugPrint(AppTexts.errorSendingRequest);
        debugPrint(e.message);
        return WeatherData().copyWith(permission: AppTexts.errorSendingRequest);
      }
    } else {
      debugPrint('${AppTexts.unknownError} $e');
      return WeatherData().copyWith(permission: AppTexts.unknownError);
    }
  }
}
