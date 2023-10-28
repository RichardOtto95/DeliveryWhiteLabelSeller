import 'package:delivery_seller_white_label/app/core/services/auth/auth_store.dart';
import 'package:delivery_seller_white_label/app/modules/address/address_Page.dart';
import 'package:delivery_seller_white_label/app/modules/address/address_store.dart';
import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'widgets/address_map.dart';
import 'widgets/custom_place_picker.dart';

class AddressModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AddressStore()),
    Bind.lazySingleton((i) => MainStore()),
    Bind.lazySingleton((i) => AuthStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => AddressPage(signRoot: args.data)),
    ChildRoute('/address-map', child: (_, args) => AddressMap()),
    ChildRoute('/place-picker', child: (_, args) => CustomPlacePicker(data: args.data)),
    // ChildRoute('/place-picker', child: (_, args) => CustomPlacePicker()),
  ];

  @override
  Widget get view => AddressPage();
}
