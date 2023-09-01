import 'package:weather_app/config/config.dart';

class UrlUtils {
  static String query(String query) =>
      '${Config.baseUrl}$query${'&appid=${Config.token}&units=metric'}';

  static String icon(String icon) => 'https://openweathermap.org/img/wn/$icon@4x.png';
}
