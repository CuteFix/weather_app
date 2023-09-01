import 'package:flutter/material.dart';
import 'package:weather_app/const/app_colors.dart';

enum WeatherStatus {
  thunderstorm,
  drizzle,
  rain,
  snow,
  mist,
  smoke,
  haze,
  dust,
  fog,
  sand,
  ash,
  squall,
  tornado,
  clear,
  clouds,
}

extension WeatherStatusExtension on WeatherStatus {
  LinearGradient getGradient() {
    switch (this) {
      case WeatherStatus.thunderstorm:
        return const LinearGradient(
          colors: [AppColors.thunderstormStart, AppColors.thunderstormEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case WeatherStatus.drizzle:
        return const LinearGradient(
          colors: [AppColors.drizzleStart, AppColors.drizzleEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case WeatherStatus.rain:
        return const LinearGradient(
          colors: [AppColors.rainStart, AppColors.rainEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case WeatherStatus.snow:
        return const LinearGradient(
          colors: [AppColors.snowStart, AppColors.snowEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case WeatherStatus.mist:
        return const LinearGradient(
          colors: [AppColors.mistStart, AppColors.mistEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case WeatherStatus.smoke:
        return const LinearGradient(
          colors: [AppColors.smokeStart, AppColors.smokeEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case WeatherStatus.haze:
        return const LinearGradient(
          colors: [AppColors.hazeStart, AppColors.hazeEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case WeatherStatus.dust:
        return const LinearGradient(
          colors: [AppColors.dustStart, AppColors.dustEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case WeatherStatus.fog:
        return const LinearGradient(
          colors: [AppColors.fogStart, AppColors.fogEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case WeatherStatus.sand:
        return const LinearGradient(
          colors: [AppColors.sandStart, AppColors.sandEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case WeatherStatus.ash:
        return const LinearGradient(
          colors: [AppColors.ashStart, AppColors.ashEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case WeatherStatus.squall:
        return const LinearGradient(
          colors: [AppColors.squallStart, AppColors.squallEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case WeatherStatus.tornado:
        return const LinearGradient(
          colors: [AppColors.tornadoStart, AppColors.tornadoEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case WeatherStatus.clear:
        return const LinearGradient(
          colors: [AppColors.clearStart, AppColors.clearEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case WeatherStatus.clouds:
        return const LinearGradient(
          colors: [AppColors.cloudsStart, AppColors.cloudsEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}
