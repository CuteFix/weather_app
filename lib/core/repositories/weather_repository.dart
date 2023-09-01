import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/const/app_texts.dart';
import 'package:weather_app/core/repositories/query/get/get_query.dart';
import 'package:weather_app/models/weather_data.dart';

class Permission extends Equatable {
  final bool hasPermission;
  final String permissionText;

  const Permission({required this.hasPermission, required this.permissionText});
  @override
  List<Object?> get props => [hasPermission, permissionText];
}

abstract class IWeatherRepository {
  Future<WeatherData> getCurrentWeather(String cityName);
  Future<List<WeatherData>> getForecastWeather(String cityName);
}

class WeatherRepository implements IWeatherRepository {
  final Dio _dio = Dio();
  Future<Permission> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const Permission(
        hasPermission: false,
        permissionText: AppTexts.locationServiceDisabled,
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const Permission(
          hasPermission: false,
          permissionText: AppTexts.locationPermissionsDenied,
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return const Permission(
        hasPermission: false,
        permissionText: AppTexts.locationPermissionsDeniedForever,
      );
    }

    return const Permission(
      hasPermission: true,
      permissionText: AppTexts.locationPermissionsAvailable,
    );
  }

  @override
  Future<WeatherData> getCurrentWeather(String cityName) async {
    WeatherData? weatherData;

    if (cityName.isNotEmpty) {
      weatherData = await _getWeatherByCityName(cityName);
    } else {
      final permission = await _handleLocationPermission();

      if (permission.hasPermission) {
        weatherData = await _getCurrentWeatherByLocation();
      }
    }

    return weatherData ?? WeatherData();
  }

  Future<WeatherData?> _getWeatherByCityName(String cityName) async {
    try {
      final response = await _dio.get(
        GetQuery.getWeatherByCityName(cityName: cityName).buildQuery(),
      );

      return WeatherData.fromJson(response.data);
    } catch (e) {
      return _handleDioException(e);
    }
  }

  Future<WeatherData?> _getCurrentWeatherByLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final response = await _dio.get(GetQuery.getCurrentWeather(
        lat: position.latitude,
        lon: position.longitude,
      ).buildQuery());

      return WeatherData.fromJson(response.data);
    } catch (e) {
      return _handleDioException(e);
      //return WeatherData().copyWith(permission: (e));
    }
  }

  WeatherData? _handleDioException(dynamic e) {
    if (e is DioException) {
      if (e.response != null) {
        debugPrint(AppTexts.dioError);
        debugPrint('STATUS: ${e.response?.statusCode}');
        debugPrint('DATA: ${e.response?.data}');
        debugPrint('HEADERS: ${e.response?.headers}');
        return WeatherData().copyWith(permission: (e.response?.data['message']));
      } else {
        debugPrint(AppTexts.errorSendingRequest);
        debugPrint(e.message);
        return WeatherData().copyWith(permission: (AppTexts.errorSendingRequest));
      }
    } else {
      debugPrint('${AppTexts.unknownError} $e');
      return WeatherData().copyWith(permission: (AppTexts.unknownError));
    }
  }

  @override
  Future<List<WeatherData>> getForecastWeather(String cityName) async {
    List<WeatherData> forecast16Days = [];

    if (cityName.isNotEmpty) {
      forecast16Days = await _getForecastWeatherByCityName(cityName);
    } else {
      final permission = await _handleLocationPermission();

      if (permission.hasPermission) {
        forecast16Days = await _getForecastWeatherByLocation();
      }
    }

    return forecast16Days;
  }

  Future<List<WeatherData>> _getForecastWeatherByCityName(String cityName) async {
    try {
      final response16Days = await _dio.get(
        GetQuery.getForecastWeatherByCityName(
          cityName: cityName,
          cnt: 16,
        ).buildQuery(),
      );

      return (response16Days.data['list'] as List)
          .map((item) => WeatherData.fromJson(item))
          .toList();
    } catch (e) {
      _handleDioException(e);
      return [];
    }
  }

  Future<List<WeatherData>> _getForecastWeatherByLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final response16Days = await _dio.get(
        GetQuery.getForecastWeather(
          lat: position.latitude,
          lon: position.longitude,
          cnt: 16,
        ).buildQuery(),
      );

      return (response16Days.data['list'] as List)
          .map((item) => WeatherData.fromJson(item))
          .toList();
    } catch (e) {
      _handleDioException(e);
      return [];
    }
  }
}
