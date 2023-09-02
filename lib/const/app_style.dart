import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/const/app_colors.dart';

class AppStyle {
  static TextStyle textStyleLogo(BuildContext context) => const TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeight.w700,
        color: AppColors.orange1Color,
        fontFamily: 'Noto Sans CJK SC',
      );

  static TextStyle _googleFonts(TextStyle textStyle) {
    return GoogleFonts.lato(textStyle: textStyle);
  }

  static TextStyle textStyleCityName() => _googleFonts(
        const TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.w600,
        ),
      );

  static TextStyle textStyleTemperature() => _googleFonts(
        const TextStyle(
          fontSize: 36.0,
          color: AppColors.whiteColor,
          fontWeight: FontWeight.bold,
        ),
      );

  static TextStyle textStyleWeatherDays() => _googleFonts(
        const TextStyle(
          fontSize: 18.0,
        ),
      );

  static TextStyle textStyleWeatherInfo() => _googleFonts(
        const TextStyle(
          color: AppColors.whiteColor,
          fontSize: 18.0,
        ),
      );

  static TextStyle textStyleWindInfo() => _googleFonts(
        const TextStyle(
          fontSize: 18.0,
        ),
      );

  static TextStyle textStyleButton() => _googleFonts(
        const TextStyle(
          fontSize: 16.0,
        ),
      );

  static TextStyle textStyleDayOfWeek() => _googleFonts(
        const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      );
}
