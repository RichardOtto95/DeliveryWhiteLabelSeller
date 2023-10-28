import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_seller_white_label/app/modules/sign_email/sign_email_store.dart';
import 'package:flutter/material.dart';

class SignEmailPage extends StatefulWidget {
  final String title;
  const SignEmailPage({Key? key, this.title = 'SignEmailPage'})
      : super(key: key);
  @override
  SignEmailPageState createState() => SignEmailPageState();
}

class SignEmailPageState extends State<SignEmailPage> {
  final SignEmailStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
