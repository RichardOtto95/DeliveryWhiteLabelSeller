import 'package:delivery_seller_white_label/app/modules/home/home_Page.dart';
import 'package:delivery_seller_white_label/app/modules/home/home_store.dart';
import 'package:delivery_seller_white_label/app/modules/home/widgets/best_sellers.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => HomePage()),
    ChildRoute('/best-sellers', child: (_, args) => BestSellers())
  ];

  @override
  Widget get view => HomePage();
}
