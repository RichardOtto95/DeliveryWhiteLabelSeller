import 'package:delivery_seller_white_label/app/core/modules/root/root_store.dart';
import 'package:delivery_seller_white_label/app/core/modules/splash/splash_module.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

import '../../../shared/color_theme.dart';
import '../../../shared/utilities.dart';

class RootPage extends StatefulWidget {
  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final RootStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    colors =
        WidgetsBinding.instance.window.platformBrightness == Brightness.light
            ? MyThemes.lightTheme.colorScheme
            : MyThemes.darkTheme.colorScheme;

    return MaterialApp(
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale("pt", "")],
      debugShowCheckedModeBanner: false,
      home: SplashModule(),
    );
  }
}
