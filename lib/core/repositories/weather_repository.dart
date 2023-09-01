import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
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
    final permission = await _handleLocationPermission();

    if (!permission.hasPermission) {
      return WeatherData()
          .copyWith(hasPermission: permission.hasPermission, permission: permission.permissionText);
    }

    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final response = cityName.isNotEmpty
          ? await _dio.get(
              GetQuery.getWeatherByCityName(cityName: cityName).buildQuery(),
            )
          : await _dio.get(GetQuery.getCurrentWeather(
              lat: position.latitude,
              lon: position.longitude,
            ).buildQuery());

      final weatherData = WeatherData.fromJson(response.data)
          .copyWith(hasPermission: permission.hasPermission, permission: permission.permissionText);

      return weatherData;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          debugPrint(AppTexts.dioError);
          debugPrint('STATUS: ${e.response?.statusCode}');
          debugPrint('DATA: ${e.response?.data}');
          debugPrint('HEADERS: ${e.response?.headers}');
          return WeatherData()
              .copyWith(permission: e.response?.data['message'].toString().capitalize());
        } else {
          debugPrint(AppTexts.errorSendingRequest);
          debugPrint(e.message);
        }
      } else {
        debugPrint('${AppTexts.unknownError} $e');
      }
      return WeatherData(); // Return an empty WeatherData on error
    }
  }

  @override
  Future<List<WeatherData>> getForecastWeather(String cityName) async {
    final permission = await _handleLocationPermission();

    if (!permission.hasPermission) {
      // Return a list containing a single WeatherData instance with permission info
      return [
        WeatherData(
          hasPermission: permission.hasPermission,
          permission: permission.permissionText,
        ),
      ];
    }

    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final response16Days = cityName.isNotEmpty
          ? await _dio.get(
              GetQuery.getForecastWeatherByCityName(
                cityName: cityName,
                cnt: 16,
              ).buildQuery(),
            )
          : await _dio.get(
              GetQuery.getForecastWeather(
                lat: position.latitude,
                lon: position.longitude,
                cnt: 16,
              ).buildQuery(),
            );

      final List<WeatherData> forecast16Days =
          (response16Days.data['list'] as List).map((item) => WeatherData.fromJson(item)).toList();
      return forecast16Days; // or forecast16Days
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          debugPrint('Dio error!');
          debugPrint('STATUS: ${e.response?.statusCode}');
          debugPrint('DATA: ${e.response?.data}');
          debugPrint('HEADERS: ${e.response?.headers}');
        } else {
          debugPrint('Error sending request!');
          debugPrint(e.message);
        }
      } else {
        debugPrint('Unknown error occurred: $e');
      }
      return []; // Return an empty list on error
    }
  }
}
