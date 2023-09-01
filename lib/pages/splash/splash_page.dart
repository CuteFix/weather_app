import 'package:flutter/material.dart';
import 'package:weather_app/config/config.dart';
import 'package:weather_app/const/app_colors.dart';
import 'package:weather_app/const/app_routes.dart';
import 'package:weather_app/const/app_style.dart';
import 'package:weather_app/const/app_texts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: Config.animationDelayMilliseconds),
    );
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    Future.delayed(const Duration(milliseconds: Config.navigateDelayMilliseconds), () {
      Navigator.pushReplacementNamed(context, AppRoutes.homePage);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.orange3Color, AppColors.orange2Color],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                child: Text(
                  'Weather App',
                  style: AppStyle.textStyleLogo(context).copyWith(color: AppColors.whiteColor),
                ),
                shaderCallback: (rect) {
                  return LinearGradient(
                    stops: [_animation.value - 0.5, _animation.value, _animation.value + 0.5],
                    colors: const [AppColors.whiteColor, AppColors.greyColor, AppColors.whiteColor],
                  ).createShader(rect);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      _textK(
                        textStyle: AppStyle.textStyleLogo(context).copyWith(
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = AppColors.blackColor.withOpacity(0.3),
                        ),
                      ),
                      _textK(),
                    ],
                  ),
                  ShaderMask(
                    child: Text(
                      AppTexts.appTitle.substring(1),
                      style: AppStyle.textStyleLogo(context).copyWith(color: AppColors.whiteColor),
                    ),
                    shaderCallback: (rect) {
                      return LinearGradient(
                        stops: [_animation.value - 0.5, _animation.value, _animation.value + 1],
                        colors: const [
                          AppColors.whiteColor,
                          AppColors.greyColor,
                          AppColors.whiteColor
                        ],
                      ).createShader(rect);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textK({TextStyle? textStyle}) {
    return Text(
      AppTexts.appTitle.substring(0, 1),
      style: textStyle ?? AppStyle.textStyleLogo(context),
    );
  }
}
