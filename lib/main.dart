import 'package:flutter/material.dart';
import 'package:weather_app/config/routes/routes.dart';
import 'package:weather_app/const/app_colors.dart';
import 'package:weather_app/const/app_texts.dart';
import 'package:weather_app/pages/splash/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp(showSplash: true));
}

class MainApp extends StatelessWidget {
  final bool showSplash;

  const MainApp({
    super.key,
    this.showSplash = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppTexts.appTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(AppColors.greyColor),
          ),
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: outlineInputBorder(),
            border: outlineInputBorder(),
            focusedBorder: outlineInputBorder(),
          ),
        ),
        routes: appRoutes,
        home: const SplashPage());
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: AppColors.blackColor.withOpacity(0.5)),
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
    );
  }
}
