import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_seller_white_label/app/modules/sign_up/sign_up_store.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final String title;
  const SignUpPage({Key? key, this.title = 'SignUpPage'}) : super(key: key);
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final SignUpStore store = Modular.get();

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
