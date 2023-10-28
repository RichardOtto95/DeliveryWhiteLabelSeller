import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'firebase_options.dart';
import 'app/app_module.dart';
import 'app/app_widget.dart';
import 'app/shared/color_theme.dart';
import 'app/shared/utilities.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Intl.defaultLocale = 'pt_BR';

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  colors = WidgetsBinding.instance.window.platformBrightness == Brightness.light
      ? MyThemes.lightTheme.colorScheme
      : MyThemes.darkTheme.colorScheme;

  runApp(ModularApp(module: AppModule(), child: AppWidget()));
  // runApp(MediaQuery(data: MediaQueryData(), child: CustomPlacePicker()));
}
