// ignore: implementation_imports
import 'package:delivery_seller_white_label/app/core/services/auth/auth_service.dart';
import 'package:delivery_seller_white_label/app/core/services/auth/auth_store.dart';
import 'package:delivery_seller_white_label/app/modules/advertisement/advertisement_store.dart';
import 'package:delivery_seller_white_label/app/modules/profile/profile_store.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../profile/profile_store.dart';
import 'main_page.dart';
import 'main_store.dart';

class MainModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => MainStore()),
    Bind.lazySingleton((i) => AdvertisementStore()),
    Bind.lazySingleton((i) => AuthStore()),
    Bind.lazySingleton((i) => ProfileStore()),
    Bind<AuthService>((i) => AuthService()),
    Bind<ProfileStore>((i) => ProfileStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => MainPage()),
  ];

  @override
  Widget get view => MainPage();
}
