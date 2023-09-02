import 'package:intl/intl.dart';
import 'package:weather_app/utils/weather_status_utils.dart';

enum WeatherDescription {
  clearSky,
  mainlyClear,
  partlyCloudy,
  overcast,
  fog,
  rimeFog,
  drizzleLight,
  drizzleModerate,
  drizzleDense,
  freezingDrizzleLight,
  freezingDrizzleDense,
  rainSlight,
  rainModerate,
  rainHeavy,
  freezingRainLight,
  freezingRainHeavy,
  snowFallSlight,
  snowFallModerate,
  snowFallHeavy,
  snowGrains,
  rainShowersSlight,
  rainShowersModerate,
  rainShowersViolent,
  snowShowersSlight,
  snowShowersHeavy,
  thunderstormSlightOrModerate,
  thunderstormSlightHail,
  thunderstormHeavyHail,
}

class WeatherStatusIdUtils {
  static WeatherStatus mapWeatherCodeToStatus(int code) {
    switch (code) {
      case 0:
        return WeatherStatus.clear;
      case 1:
      case 2:
      case 3:
        return WeatherStatus.clouds;
      case 45:
      case 48:
        return WeatherStatus.fog;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return WeatherStatus.drizzle;
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
        return WeatherStatus.rain;
      case 71:
      case 73:
      case 75:
      case 77:
        return WeatherStatus.snow;
      case 80:
      case 81:
      case 82:
      case 85:
      case 86:
        return WeatherStatus.rain;
      case 95:
      case 96:
      case 99:
        return WeatherStatus.thunderstorm;
      default:
        return WeatherStatus.clear; // Default to Clear Sky for unknown codes
    }
  }

  static String mapWeatherStatusToCodeIcon(WeatherStatus weatherStatus) {
    switch (weatherStatus) {
      case WeatherStatus.thunderstorm:
        return '11d';
      case WeatherStatus.drizzle:
        return '09d';
      case WeatherStatus.rain:
        return '10d';
      case WeatherStatus.snow:
        return '13d';
      case WeatherStatus.fog:
        return '50d';
      case WeatherStatus.clear:
        return '01d';
      case WeatherStatus.clouds:
        return '02d';
      default:
        return '01d'; // Default to Clear for unknown descriptions
    }
  }

  static String getDayName(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final formatter = DateFormat.EEEE();
      return formatter.format(date); // Returns the full day name (e.g., "Monday")
    } catch (e) {
      return ''; // Return an empty string for invalid date strings
    }
  }
}
