import 'package:equatable/equatable.dart';
import 'package:weather_app/core/repositories/query/get/get_query.dart';
import 'package:weather_app/utils/weather_status_utils.dart';

class WeatherData extends Equatable {
  final Coord? coord;
  final List<Weather> weather;
  final String? base;
  final Main? main;
  final int? visibility;
  final Wind? wind;
  final Rain? rain;
  final Clouds? clouds;
  final int? dt;
  final Sys? sys;
  final int? timezone;
  final int? id;
  final String? name;
  final int? cod;
  final bool hasPermission;
  final String? permission;
  final String? dateTime;

  WeatherData({
    this.coord,
    List<Weather>? weather,
    this.base,
    this.main,
    this.visibility,
    this.wind,
    this.rain,
    this.clouds,
    this.dt,
    this.sys,
    this.timezone,
    this.id,
    this.name,
    this.cod,
    this.hasPermission = false,
    this.permission,
    this.dateTime,
  }) : weather = weather ?? [];

  factory WeatherData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return WeatherData();

    return WeatherData(
      coord: json['coord'] != null ? Coord.fromJson(json['coord']) : null,
      weather: json['weather'] != null
          ? List<Weather>.from(json['weather'].map((x) => Weather.fromJson(x)))
          : [],
      base: json['base'],
      main: json['main'] != null ? Main.fromJson(json['main']) : null,
      visibility: json['visibility'],
      wind: json['wind'] != null ? Wind.fromJson(json['wind']) : null,
      rain: json['rain'] != null ? Rain.fromJson(json['rain']) : null,
      clouds: json['clouds'] != null ? Clouds.fromJson(json['clouds']) : null,
      dt: json['dt'],
      sys: json['sys'] != null ? Sys.fromJson(json['sys']) : null,
      timezone: json['timezone'],
      id: json['id'],
      name: json['name'],
      cod: json['cod'],
      dateTime: json['dt_txt'],
    );
  }

  WeatherData copyWith({
    Coord? coord,
    List<Weather>? weather,
    String? base,
    Main? main,
    int? visibility,
    Wind? wind,
    Rain? rain,
    Clouds? clouds,
    int? dt,
    Sys? sys,
    int? timezone,
    int? id,
    String? name,
    int? cod,
    String? dateTime,
    bool? hasPermission,
    String? permission,
  }) {
    return WeatherData(
      coord: coord ?? this.coord,
      weather: weather ?? this.weather,
      base: base ?? this.base,
      main: main ?? this.main,
      visibility: visibility ?? this.visibility,
      wind: wind ?? this.wind,
      rain: rain ?? this.rain,
      clouds: clouds ?? this.clouds,
      dt: dt ?? this.dt,
      sys: sys ?? this.sys,
      timezone: timezone ?? this.timezone,
      id: id ?? this.id,
      name: name ?? this.name,
      cod: cod ?? this.cod,
      dateTime: dateTime ?? this.dateTime,
      hasPermission: hasPermission ?? this.hasPermission,
      permission: permission ?? this.permission,
    );
  }

  @override
  List<Object?> get props => [
        coord,
        weather,
        base,
        main,
        visibility,
        wind,
        rain,
        clouds,
        dt,
        sys,
        timezone,
        id,
        name,
        cod,
        dateTime,
        hasPermission,
        permission,
      ];
}

class Coord extends Equatable {
  final double? lon;
  final double? lat;

  const Coord({
    this.lon,
    this.lat,
  });

  factory Coord.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Coord();
    return Coord(
      lon: json['lon']?.toDouble(),
      lat: json['lat']?.toDouble(),
    );
  }

  Coord copyWith({
    double? lon,
    double? lat,
  }) {
    return Coord(
      lon: lon ?? this.lon,
      lat: lat ?? this.lat,
    );
  }

  @override
  List<Object?> get props => [lon, lat];
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

  factory Weather.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Weather();
    return Weather(
      id: json['id'],
      main: _parseWeatherStatus(json['main']), // Parse and assign WeatherStatus
      description: json['description'],
      icon: GetQuery.getIconUrl(json['icon']),
    );
  }

  static WeatherStatus? _parseWeatherStatus(String? main) {
    if (main == null) return null; // Handle null case if necessary

    switch (main.toLowerCase()) {
      case 'thunderstorm':
        return WeatherStatus.thunderstorm;
      case 'drizzle':
        return WeatherStatus.drizzle;
      case 'rain':
        return WeatherStatus.rain;
      case 'snow':
        return WeatherStatus.snow;
      case 'mist':
        return WeatherStatus.mist;
      case 'smoke':
        return WeatherStatus.smoke;
      case 'haze':
        return WeatherStatus.haze;
      case 'dust':
        return WeatherStatus.dust;
      case 'fog':
        return WeatherStatus.fog;
      case 'sand':
        return WeatherStatus.sand;
      case 'ash':
        return WeatherStatus.ash;
      case 'squall':
        return WeatherStatus.squall;
      case 'tornado':
        return WeatherStatus.tornado;
      case 'clear':
        return WeatherStatus.clear;
      case 'clouds':
        return WeatherStatus.clouds;
      default:
        return null; // Handle unknown cases or return null
    }
  }

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

  factory Main.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Main();
    return Main(
      temp: json['temp']?.toDouble(),
      feelsLike: json['feels_like']?.toDouble(),
      tempMin: json['temp_min']?.toDouble(),
      tempMax: json['temp_max']?.toDouble(),
      pressure: json['pressure'],
      humidity: json['humidity'],
      seaLevel: json['sea_level'],
      grndLevel: json['grnd_level'],
    );
  }

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

class Wind extends Equatable {
  final double? speed;
  final int? deg;
  final double? gust;

  const Wind({
    this.speed,
    this.deg,
    this.gust,
  });

  factory Wind.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Wind();
    return Wind(
      speed: json['speed']?.toDouble(),
      deg: json['deg'],
      gust: json['gust']?.toDouble(),
    );
  }

  Wind copyWith({
    double? speed,
    int? deg,
    double? gust,
  }) {
    return Wind(
      speed: speed ?? this.speed,
      deg: deg ?? this.deg,
      gust: gust ?? this.gust,
    );
  }

  @override
  List<Object?> get props => [speed, deg, gust];
}

class Rain extends Equatable {
  final double? h1;

  const Rain({
    this.h1,
  });

  factory Rain.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Rain();
    return Rain(
      h1: json['1h']?.toDouble(),
    );
  }
  Rain copyWith({
    double? h1,
  }) {
    return Rain(
      h1: h1 ?? this.h1,
    );
  }

  @override
  List<Object?> get props => [h1];
}

class Clouds extends Equatable {
  final int? all;

  const Clouds({
    this.all,
  });

  factory Clouds.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Clouds();
    return Clouds(
      all: json['all'],
    );
  }

  Clouds copyWith({
    int? all,
  }) {
    return Clouds(
      all: all ?? this.all,
    );
  }

  @override
  List<Object?> get props => [all];
}

class Sys extends Equatable {
  final int? type;
  final int? id;
  final String? country;
  final int? sunrise;
  final int? sunset;

  const Sys({
    this.type,
    this.id,
    this.country,
    this.sunrise,
    this.sunset,
  });

  factory Sys.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Sys();
    return Sys(
      type: json['type'],
      id: json['id'],
      country: json['country'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }

  Sys copyWith({
    int? type,
    int? id,
    String? country,
    int? sunrise,
    int? sunset,
  }) {
    return Sys(
      type: type ?? this.type,
      id: id ?? this.id,
      country: country ?? this.country,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
    );
  }

  @override
  List<Object?> get props => [type, id, country, sunrise, sunset];
}
