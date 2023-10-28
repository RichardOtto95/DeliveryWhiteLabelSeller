import 'package:delivery_seller_white_label/app/core/services/auth/auth_store.dart';
import 'package:delivery_seller_white_label/app/modules/sign/sign_store.dart';

import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final SignStore store = Modular.get();
  final AuthStore authStore = Modular.get();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  MaskTextInputFormatter maskFormatterPhone = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  String text = '';
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyleFromColor(getColors(context).surface),
      child: Listener(
        onPointerDown: (a) =>
            FocusScope.of(context).requestFocus(new FocusNode()),
        child: WillPopScope(
          onWillPop: () async {
            return authStore.getCanBack();
          },
          child: Scaffold(
            body: Observer(
              builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    Image.asset(
                      brightness == Brightness.light
                          ? "./assets/images/logo.png"
                          : "./assets/images/logo_dark.png",
                      width: wXD(173, context),
                      height: wXD(153, context),
                    ),
                    Spacer(),
                    Text(
                      'Entrar em sua loja',
                      textAlign: TextAlign.center,
                      style: textFamily(
                        context,
                        fontSize: 28,
                        color: getColors(context).onBackground,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(flex: 2),
                    Container(
                      width: wXD(235, context),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: getColors(context)
                                  .onBackground
                                  .withOpacity(.3)),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Telefone',
                            style: textFamily(
                              context,
                              fontSize: 20,
                              color: getColors(context)
                                  .onBackground
                                  .withOpacity(.5),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              inputFormatters: [maskFormatterPhone],
                              keyboardType: TextInputType.phone,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration:
                                  InputDecoration.collapsed(hintText: ''),
                              style: textFamily(context, fontSize: 20),
                              onChanged: (val) {
                                print(
                                    'val: ${maskFormatterPhone.unmaskText(val)}');
                                text = maskFormatterPhone.unmaskText(val);
                                store.setPhone(text);
                              },
                              validator: (value) {
                                print('value validator: $value');
                                if (value == null || value.isEmpty) {
                                  return 'Por favor preenchar o número de telefone';
                                }
                                if (value.length < 15) {
                                  return 'Preencha com todos os números';
                                }
                              },
                              onEditingComplete: () {
                                if (text.length == 11) {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  if (store.phone == null) {
                                    store.phone = text;
                                  }
                                  print('store.start: ${store.start}');
                                  if (store.start != 60 && store.start != 0) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Aguarde ${store.start} segundos para reenviar um novo código",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  } else {
                                    store.verifyNumber(context);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Digite o número por completo!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                              controller: _phoneNumberController,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(flex: 1),
                    store.start != 60 && store.start != 0
                        ? Text(
                            "Aguarde ${store.start} segundos para reenviar um novo código",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.normal),
                          )
                        : Container(),
                    Spacer(flex: 1),
                    SideButton(
                      onTap: () {
                        if (text.length == 11) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          if (store.phone == null) {
                            store.phone = text;
                          }
                          print('store.start: ${store.start}');

                          if (store.start != 60 && store.start != 0) {
                            Fluttertoast.showToast(
                                msg:
                                    "Aguarde ${store.start} segundos para reenviar um novo código",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            store.verifyNumber(context);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Digite o número por completo!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      //  => Modular.to.pushNamed(
                      //   '/sign/verify',
                      //   arguments: _phoneNumberController.text,
                      // ),
                      title: 'Entrar',
                      height: wXD(52, context),
                      width: wXD(142, context),
                    ),
                    Spacer(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
