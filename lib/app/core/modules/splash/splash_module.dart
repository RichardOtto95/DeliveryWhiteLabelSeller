// ignore: implementation_imports
import 'package:delivery_seller_white_label/app/core/modules/splash/splash_page.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'splash_store.dart';

class SplashModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SplashStore()),
  ];

  @override
  Widget get view => SplashPage();
}
