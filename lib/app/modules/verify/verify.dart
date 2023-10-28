import 'dart:async';
import 'package:delivery_seller_white_label/app/core/services/auth/auth_store.dart';
import 'package:delivery_seller_white_label/app/modules/sign/sign_store.dart';
import 'package:delivery_seller_white_label/app/modules/verify/widgets/custom_pincode_textfield.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Verify extends StatefulWidget {
  final String phoneNumber;
  const Verify({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final SignStore store = Modular.get();
  final AuthStore authStore = Modular.get();
  bool isCodeSent = false;
  bool secondResend = false;
  final TextEditingController _pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _onVerifyCode();
  }

  Timer? _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            print('*************8 reenviou');
            print(
                '*************authStore.phoneMobile ${authStore.phoneMobile}');
            print('*************authStore.mobile ${authStore.mobile}');
            store.phone = authStore.mobile;
            store.verifyNumber(context);
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void startTimereNumber() {
    const oneSec = const Duration(seconds: 1);
    store.start = 59;
    store.timer = new Timer.periodic(oneSec, (Timer timer) {
      if (store.start == 0) {
        store.timer!.cancel();

        print('##################### reenviou');
        print(
            '#####################3 authStore.phoneMobile ${authStore.phoneMobile}');
        print('#####################authStore.mobile ${authStore.mobile}');
      } else {
        store.start = store.start - 1;
        print('store.start: ${store.start}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (authStore.canBack) {
          if (_timer != null) {
            if (_timer!.isActive) {
              _timer!.cancel();
              _timer = null;
            }
          }
          setState(() {
            startTimereNumber();
          });
          print('onWillPop /sign');
          Modular.to
              .pushNamedAndRemoveUntil("/sign", ModalRoute.withName('/sign'));

          Modular.to.popUntil(ModalRoute.withName('/sign'));
          // Modular.to.popAndPushNamed('/sign');
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(flex: 6),
                Observer(builder: (context) {
                  return Text(
                    'Insira o código enviado para o \n número ${fullNumberMask.maskText(store.userPhone)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, height: 1.5),
                  );
                }),
                Spacer(flex: 2),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: wXD(30, context)),
                  width: maxWidth(context),
                  child: CustomPinCodeTextField(controller: _pinCodeController),
                ),
                Spacer(
                  flex: 2,
                ),
                TextButton(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: getColors(context).primary, width: 2)),
                    ),
                    padding: EdgeInsets.only(bottom: wXD(3, context)),
                    child: Text(
                      'Reenviar o código',
                      style: textFamily(
                        context,
                        color: getColors(context).onBackground,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  onPressed: () {
                    startTimer();
                    setState(() {
                      secondResend = true;
                    });
                  },
                ),
                Spacer(flex: 1),
                secondResend
                    ? Text(
                        "Reenviando código em $_start segundos",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.normal),
                      )
                    : Container(),
                Spacer(flex: 2),
                SideButton(
                  onTap: () async {
                    if (_pinCodeController.text.length == 6 &&
                        _pinCodeController.text.isNotEmpty) {
                      await store.signinPhone(
                        _pinCodeController.text,
                        authStore.getUserVerifyiD() ?? "",
                        context,
                      );
                    } else {
                      Fluttertoast.showToast(
                          msg: "Código incompleto!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  title: 'Validar',
                  height: wXD(52, context),
                  width: wXD(142, context),
                ),
                Spacer(),
              ],
            ),
            DefaultAppBar(
              'Código enviado',
              onPop: () {
                if (_timer != null) {
                  if (_timer!.isActive) {
                    _timer!.cancel();
                    _timer = null;
                  }
                }
                setState(() {
                  startTimereNumber();
                });
                Modular.to.pushNamedAndRemoveUntil(
                    "/sign", ModalRoute.withName('/sign'));
              },
            ),
          ],
        ),
      ),
    );
  }

  showToast(message, Color color) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: color,
    );
  }
}
