import 'package:equatable/equatable.dart';
import 'package:weather_app/utils/weather_status_utils.dart';

class WeatherData extends Equatable {
  final List<Weather> weather;
  final Main? main;
  final String? name;
  final bool hasPermission;
  final String? permission;
  final String? dateTime;

  WeatherData({
    List<Weather>? weather,
    this.main,
    this.name,
    this.hasPermission = false,
    this.permission,
    this.dateTime,
  }) : weather = weather ?? [];

  WeatherData copyWith({
    List<Weather>? weather,
    Main? main,
    String? name,
    String? dateTime,
    bool? hasPermission,
    String? permission,
  }) {
    return WeatherData(
      weather: weather ?? this.weather,
      main: main ?? this.main,
      name: name ?? this.name,
      dateTime: dateTime ?? this.dateTime,
      hasPermission: hasPermission ?? this.hasPermission,
      permission: permission ?? this.permission,
    );
  }

  @override
  List<Object?> get props => [
        weather,
        main,
        name,
        dateTime,
        hasPermission,
        permission,
      ];
}

class Weather extends Equatable {
  final int? id;
  final WeatherStatus? main; // Change the type to WeatherStatus enum
  final String? description;
  final String? icon;

  const Weather({
    this.id,
    this.main, // Change the type to WeatherStatus enum
    this.description,
    this.icon,
  });

  Weather copyWith({
    int? id,
    WeatherStatus? main, // Change the type to WeatherStatus enum
    String? description,
    String? icon,
  }) {
    return Weather(
      id: id ?? this.id,
      main: main ?? this.main, // Change the type to WeatherStatus enum
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object?> get props => [id, main, description, icon]; // Include main (WeatherStatus) in props
}

class Main extends Equatable {
  final double? temp;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? humidity;
  final int? seaLevel;
  final int? grndLevel;

  const Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
    this.seaLevel,
    this.grndLevel,
  });

  Main copyWith({
    double? temp,
    double? feelsLike,
    double? tempMin,
    double? tempMax,
    int? pressure,
    int? humidity,
    int? seaLevel,
    int? grndLevel,
  }) {
    return Main(
      temp: temp ?? this.temp,
      feelsLike: feelsLike ?? this.feelsLike,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      pressure: pressure ?? this.pressure,
      humidity: humidity ?? this.humidity,
      seaLevel: seaLevel ?? this.seaLevel,
      grndLevel: grndLevel ?? this.grndLevel,
    );
  }

  @override
  List<Object?> get props =>
      [temp, feelsLike, tempMin, tempMax, pressure, humidity, seaLevel, grndLevel];
}
