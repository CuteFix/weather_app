import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/const/app_colors.dart';
import 'package:weather_app/const/app_style.dart';
import 'package:weather_app/const/app_texts.dart';
import 'package:weather_app/core/blocs/home/home_bloc.dart';

class CityTextField extends StatelessWidget {
  final TextEditingController controller;

  const CityTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 100),
      height: 35,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white2Color,
          hintText: AppTexts.enterCityHint,
          hintStyle: AppStyle.textStyleDayOfWeek(),
          contentPadding: const EdgeInsets.only(left: 10),
        ),
        onChanged: (text) async {
          context.read<HomeBloc>().add(GetListCityEvent(text));
        },
        onSubmitted: (text) {
          if (text.isNotEmpty) {
            context.read<HomeBloc>().add(GetWeatherCityName(text));
          } else {
            context.read<HomeBloc>().add(const GetCurrentLocationEvent());
          }
        },
      ),
    );
  }
}
