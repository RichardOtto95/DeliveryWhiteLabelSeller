import 'package:delivery_seller_white_label/app/core/modules/splash/splash_module.dart';
import 'package:delivery_seller_white_label/app/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
// import 'core/modules/root/root_module.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale("pt", "BR")],
      debugShowCheckedModeBanner: false,
      title: "DeliveryApp",
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case "/splash":
            return MaterialPageRoute(builder: (context) => SplashModule());
          default:
        }
      },
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
    ).modular();
  }
}
