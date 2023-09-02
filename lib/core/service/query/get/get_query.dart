import 'package:weather_app/utils/url_utils.dart';

class WeatherQuery {
  final String endpoint;
  final Map<String, dynamic> params;

  WeatherQuery(this.endpoint, this.params);

  String buildQuery() {
    final queryString = params.entries.map((entry) => '${entry.key}=${entry.value}').join('&');
    return UrlUtils.query("$endpoint?$queryString");
  }
}

class GetQuery {
  static WeatherQuery getForecastWeatherByCoordinates({
    required double latitude,
    required double longitude,
    List<String> hourly = const ['temperature_2m', 'relativehumidity_2m'],
    List<String> daily = const ['weathercode', 'temperature_2m_max', 'temperature_2m_min'],
    String timezone = 'auto',
    int pastDays = 0,
    int forecastDays = 16,
    bool currentWeather = true,
  }) {
    final params = {
      'latitude': latitude,
      'longitude': longitude,
      'hourly': hourly.join(','),
      'daily': daily.join(','),
      'current_weather': currentWeather,
      'timezone': timezone,
      'past_days': pastDays,
      'forecast_days': forecastDays,
    };
    return WeatherQuery('forecast', params);
  }

  static String getIconUrl(String icon) => UrlUtils.icon(icon);
}
