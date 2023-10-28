import 'package:delivery_seller_white_label/app/core/models/seller_model.dart';
import 'package:delivery_seller_white_label/app/core/services/auth/auth_service.dart';
import 'package:delivery_seller_white_label/app/core/services/auth/auth_store.dart';
import 'package:delivery_seller_white_label/app/modules/sign/sign_Page.dart';
import 'package:delivery_seller_white_label/app/modules/sign/sign_store.dart';
import 'package:delivery_seller_white_label/app/modules/verify/verify.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SignModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => Seller()),
    Bind.lazySingleton((i) => AuthStore()),
    // Bind.lazySingleton((i) => SignStore(i.get())),
    Bind.lazySingleton((i) => SignStore()),
    Bind.lazySingleton((i) => AuthService()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/sign', child: (_, args) => SignPage()),
    ChildRoute('/verify', child: (_, args) => Verify(phoneNumber: args.data)),
  ];

  @override
  Widget get view => SignPage();
}
