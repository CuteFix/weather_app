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
  static WeatherQuery getCurrentWeather({required num lat, required num lon}) =>
      WeatherQuery('weather', {'lat': lat, 'lon': lon});

  static WeatherQuery getWeatherByCityName({required String cityName}) =>
      WeatherQuery('weather', {'q': cityName});

  static WeatherQuery getForecastWeather({required num lat, required num lon, required num cnt}) =>
      WeatherQuery('forecast', {'lat': lat, 'lon': lon, 'cnt': cnt});

  static WeatherQuery getForecastWeatherByCityName({required String cityName, required num cnt}) =>
      WeatherQuery('forecast', {'q': cityName, 'cnt': cnt});

  static String getIconUrl(String icon) => UrlUtils.icon(icon);
}
