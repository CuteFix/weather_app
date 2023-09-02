import 'package:weather_app/core/service/weather_service.dart';
import 'package:weather_app/models/permission_data.dart';
import 'package:weather_app/models/weather_data.dart';

abstract class IWeatherRepository {
  Future<WeatherData> getCurrentWeather(String cityName);
  Future<List<WeatherData>> getForecastWeather(String cityName);
}

class WeatherRepository implements IWeatherRepository {
  final WeatherService weatherService;
  WeatherRepository(this.weatherService);

  @override
  Future<WeatherData> getCurrentWeather(String cityName) async {
    final PermissionData permission = await weatherService.handleLocationPermission();
    final weatherData =
        await weatherService.getCurrentWeatherByLocationOrCurrentLocation(cityName, permission);
    return weatherData ?? WeatherData();
  }

  @override
  Future<List<WeatherData>> getForecastWeather(String cityName) async {
    final permission = await weatherService.handleLocationPermission();
    final forecast16Days =
        await weatherService.getForecastWeatherByLocationOrCurrentLocation(cityName, permission);
    return forecast16Days;
  }
}
