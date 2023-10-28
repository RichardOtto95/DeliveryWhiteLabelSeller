import 'package:delivery_seller_white_label/app/modules/advertisement/advertisement_Page.dart';
import 'package:delivery_seller_white_label/app/modules/advertisement/advertisement_store.dart';
import 'package:delivery_seller_white_label/app/modules/advertisement/widgets/ads_confirm.dart';
import 'package:delivery_seller_white_label/app/modules/advertisement/widgets/choose_category.dart';
import 'package:delivery_seller_white_label/app/modules/advertisement/widgets/create_ads.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'widgets/category.dart';
import 'widgets/choose_additional.dart';
import 'widgets/delivery_fee.dart';

class AdvertisementModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AdvertisementStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => AdvertisementPage()),
    ChildRoute('/create-ads', child: (_, args) => CreateAds()),
    ChildRoute('/ads-confirm',
        child: (_, args) => AdsConfirm(group: args.data)),
    ChildRoute('/choose-category', child: (_, args) => ChooseCategory()),
    ChildRoute('/choose-additional', child: (_, args) => ChooseAdditional()),
    ChildRoute('/delivery-fee', child: (_, args) => DeliveryFee()),
    ChildRoute('/category',
        child: (_, args) => ChooseCategoryPage(
              categoryId: args.data,
            )),
  ];

  @override
  Widget get view => AdvertisementPage();
}
