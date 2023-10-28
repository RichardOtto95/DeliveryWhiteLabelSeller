import 'package:delivery_seller_white_label/app/modules/sign_email/sign_email_page.dart';
import 'package:delivery_seller_white_label/app/modules/sign_email/sign_email_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SignEmailModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SignEmailStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SignEmailPage()),
  ];
}
