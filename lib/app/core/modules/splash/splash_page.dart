import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

import 'splash_store.dart';

class SplashPage extends StatefulWidget {
  final String title;
  const SplashPage({Key? key, this.title = 'SplashPage'}) : super(key: key);
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  final SplashStore store = Modular.get();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 300), () {
        if (FirebaseAuth.instance.currentUser != null) {
          // Modular.to.pushNamed("/main");
          Modular.to.pushReplacementNamed("/main/");
        } else {
          // Modular.to.pushNamed("/on-boarding");
          Modular.to.pushReplacementNamed("/sign/");
          // Modular.to.pushReplacementNamed("/on-boarding");
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColors(context).surface,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: wXD(100, context)),
        alignment: Alignment.center,
        child: Image.asset(
          brightness == Brightness.light
              ? "./assets/images/logo.png"
              : "./assets/images/logo_dark.png",
          fit: BoxFit.fitHeight,
          width: maxWidth(context),
        ),
        // child: Image.asset(
        //   "./assets/images/logo.png",
        //   fit: BoxFit.fitHeight,
        //   height: maxHeight(context),
        // ),
      ),
    );
  }
}
