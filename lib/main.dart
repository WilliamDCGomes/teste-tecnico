import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'app/modules/login/page/login_page.dart';
import 'app/utils/stylePages/app_colors.dart';

void main() {
  runApp(
    const App(
      color: MaterialColor(
        0XFF1E4767,
        {
          50: AppColors.defaultColor,
          100: AppColors.defaultColor,
          200: AppColors.defaultColor,
          300: AppColors.defaultColor,
          400: AppColors.defaultColor,
          500: AppColors.defaultColor,
          600: AppColors.defaultColor,
          700: AppColors.defaultColor,
          800: AppColors.defaultColor,
          900: AppColors.defaultColor,
        },
      ),
    ),
  );
}

class App extends StatefulWidget {
  final MaterialColor color;
  const App({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.defaultColor,
      systemNavigationBarColor: AppColors.defaultColor,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return ResponsiveSizer(builder: (context, orientation, screentype) {
      return GetMaterialApp(
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: AppColors.defaultColor,
          primarySwatch: widget.color,
        ),
        getPages: [
          GetPage(name: "/loginPage", page: () => const LoginPage()),
        ],
        initialRoute: "/loginPage",
      );
    });
  }
}