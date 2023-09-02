import 'package:equatable/equatable.dart';

class WeatherForecastData extends Equatable {
  final String? timezone;
  final List<String> dailyTime;
  final List<String>? hourlyTime;
  final List<double?> hourlyTemperature;
  final List<int?> hourlyRelativeHumidity;
  final List<int> weatherCode;
  final CurrentWeather currentWeather;
  final List<double?>? temperature2mMax;
  final List<double?>? temperature2mMin;

  const WeatherForecastData({
    this.timezone,
    required this.dailyTime,
    this.hourlyTime,
    required this.currentWeather,
    required this.hourlyTemperature,
    required this.hourlyRelativeHumidity,
    required this.weatherCode,
    this.temperature2mMax,
    this.temperature2mMin,
  });

  factory WeatherForecastData.fromJson(Map<String, dynamic> json) {
    return WeatherForecastData(
      timezone: json['timezone'] ?? '',
      dailyTime: List<String>.from(json['daily']['time']),
      hourlyTime: List<String>.from(json['hourly']['time']),
      hourlyTemperature: List<double?>.from(json['hourly']['temperature_2m']),
      hourlyRelativeHumidity: List<int?>.from(json['hourly']['relativehumidity_2m']),
      weatherCode: List<int>.from(json['daily']['weathercode']),
      currentWeather: CurrentWeather.fromJson(json['current_weather']),
      temperature2mMax: List<double?>.from(json['daily']['temperature_2m_max']),
      temperature2mMin: List<double?>.from(json['daily']['temperature_2m_min']),
    );
  }

  @override
  List<Object?> get props => [
        timezone,
        dailyTime,
        hourlyTime,
        currentWeather,
        hourlyTemperature,
        hourlyRelativeHumidity,
        weatherCode,
        temperature2mMax,
        temperature2mMin,
      ];

  WeatherForecastData copyWith({
    String? timezone,
    List<String>? dailyTime,
    List<String>? hourlyTime,
    List<double>? hourlyTemperature,
    CurrentWeather? currentWeather,
    List<int>? hourlyRelativeHumidity,
    List<int>? weatherCode,
    List<double>? temperature2mMax,
    List<double>? temperature2mMin,
  }) {
    return WeatherForecastData(
      timezone: timezone ?? this.timezone,
      dailyTime: dailyTime ?? this.dailyTime,
      currentWeather: currentWeather ?? this.currentWeather,
      hourlyTime: dailyTime ?? this.hourlyTime,
      hourlyTemperature: hourlyTemperature ?? this.hourlyTemperature,
      hourlyRelativeHumidity: hourlyRelativeHumidity ?? this.hourlyRelativeHumidity,
      weatherCode: weatherCode ?? this.weatherCode,
      temperature2mMax: temperature2mMax ?? this.temperature2mMax,
      temperature2mMin: temperature2mMin ?? this.temperature2mMin,
    );
  }
}

class CurrentWeather extends Equatable {
  final double temperature;
  final double windSpeed;
  final int windDirection;
  final int weatherCode;
  final int isDay;
  final String time;

  const CurrentWeather({
    required this.temperature,
    required this.windSpeed,
    required this.windDirection,
    required this.weatherCode,
    required this.isDay,
    required this.time,
  });

  @override
  List<Object?> get props => [temperature, windSpeed, windDirection, weatherCode, isDay, time];

  CurrentWeather copyWith({
    double? temperature,
    double? windSpeed,
    int? windDirection,
    int? weatherCode,
    int? isDay,
    String? time,
  }) {
    return CurrentWeather(
      temperature: temperature ?? this.temperature,
      windSpeed: windSpeed ?? this.windSpeed,
      windDirection: windDirection ?? this.windDirection,
      weatherCode: weatherCode ?? this.weatherCode,
      isDay: isDay ?? this.isDay,
      time: time ?? this.time,
    );
  }

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: json['temperature'],
      windSpeed: json['windspeed'],
      windDirection: json['winddirection'],
      weatherCode: json['weathercode'],
      isDay: json['is_day'],
      time: json['time'],
    );
  }
}
