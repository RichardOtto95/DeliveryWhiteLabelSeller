import 'package:delivery_seller_white_label/app/core/services/auth/auth_service_interface.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/load_circular_overlay.dart';
import 'package:delivery_seller_white_label/app/core/services/auth/auth_store.dart';
import 'package:delivery_seller_white_label/app/core/models/seller_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:async';
import '../../shared/utilities.dart';
part 'sign_store.g.dart';

class SignStore = _SignStoreBase with _$SignStore;

abstract class _SignStoreBase with Store {
  final AuthStore authStore = Modular.get();
  // final Seller seller;
  AuthServiceInterface authService = Modular.get();
  @observable
  User? valueUser;
  @observable
  String? phone;
  @observable
  String userPhone = "";
  @observable
  ConfirmationResult? resultConfirm;
  @observable
  int start = 60;
  @observable
  Timer? timer;

  // @observable
  // _SignStoreBase(this.seller);

  @action
  void setPhone(_phone) => phone = _phone;

  @action
  int getStart() => start;

  @action
  verifyNumber(BuildContext context) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(overlayEntry);
    authStore.canBack = false;
    print('##### phone $phone');
    userPhone = '+55' + phone!;
    print('##### userPhone $userPhone');

    if (!kIsWeb) {
      print("isNotWeb");
      await authStore.verifyNumber(phone!, context);
    } else {
      print("isWeb");
      final FirebaseAuth _auth = FirebaseAuth.instance;
      try {
        resultConfirm = await _auth.signInWithPhoneNumber(userPhone);

        final el =
            html.window.document.getElementById('__ff-recaptcha-container');
        if (el != null) {
          el.style.visibility = 'hidden';
        }

        print("resultCOnfirm: ${resultConfirm}");

        authStore.canBack = true;

        Modular.to.pushNamed('/sign/verify', arguments: userPhone);
      } on FirebaseAuthException catch (e) {
        print('error code: ${e.code}');
          switch (e.code) {
            case "too-many-requests":
              showToast(
                  "Número bloqueado por muitas tentativas de login");
              break;

            default:
              print('Case of ${e.code} not defined');
              break;
          }
      }
    }
    print('##### afteer verify number');
    overlayEntry.remove();
  }

  @action
  signinPhone(String _code, String verifyId, context) async {
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => const LoadCircularOverlay());

    Overlay.of(context)!.insert(loadOverlay);

    if (!kIsWeb) {
      await authStore
          .handleSmsSignin(_code, verifyId)
          .then((User? value) async {
        print("Dentro do then");
        print('%%%%%%%% signinPhone2 $value %%%%%%%%');
        if (value != null) {
          valueUser = value;
          DocumentSnapshot _user = await FirebaseFirestore.instance
              .collection('sellers')
              .doc(value.uid)
              .get();

          if (_user.exists) {
            // QuerySnapshot addresses =
            //     await _user.reference.collection("addresses").get();
            print('%%%%%%%% signinPhone _user.exists == true  %%%%%%%%');

            String? tokenString = await FirebaseMessaging.instance.getToken();
            print('tokenId: $tokenString');
            await _user.reference.update({
              'token_id': [tokenString]
            });
            Modular.to.pushReplacementNamed("/main");
            // if (addresses.docs.isEmpty) {
            // Modular.to.pushNamedAndRemoveUntil(
            //   '/address',
            //   (p0) {
            //     print('pushNamedAndRemoveUntil: $p0');
            //     return false;
            //   },
            //   arguments: true
            // );
            // Modular.to.pushReplacementNamed('/address', arguments: true);
            // Modular.to.pushNamed('/address', arguments: true);
            // } else {
            //   Modular.to.pushNamed("/main");
            // }
          } else {
            print('%%%%%%%% signinPhone _user.exists == false  %%%%%%%%');
            Seller seller = Seller(id: value.uid);
            seller.phone = value.phoneNumber;
            await authService.preRegisteredUser(seller);
            // try {
            //   print('try push on boarding');

            Modular.to.pushReplacementNamed("/on-boarding");
            // } catch (e) {
            //   print('error');
            //   print(e);
            // }
            // Seller? response = await authService.preRegisteredUser(seller);
            // if(response != null){
            //   seller = response;
            // }
            // await authService.handleSignup(seller);
            // Modular.to.pushNamed('/address', arguments: true);
            // Modular.to.pushReplacementNamed('/address', arguments: true);
          }
          // print("Modular.to.localPath: ${Modular.to.localPath}");

          // Modular.to.pushNamedAndRemoveUntil(
          //   '/main',
          //   (p0) {
          //     print('pushNamedAndRemoveUntil: $p0');
          //     return false;
          //   },
          // );
        }
      });
    } else {
      if (_code.length != 6) {
        showToast("Digite o código corretamente");
        loadOverlay.remove();
      } else {
        try {
          print("resultConfirm");
          UserCredential userCredential = await resultConfirm!.confirm(_code);
          User user = userCredential.user!;
          valueUser = user;
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('sellers')
            .doc(user.uid)
            .get();

          if(userDoc.exists){
            Modular.to.pushReplacementNamed("/main");
          } else {
            print('%%%%%%%% signinPhone _user.exists == false  %%%%%%%%');
            Seller seller = Seller(id: user.uid);
            seller.phone = user.phoneNumber;
            await authService.preRegisteredUser(seller);
            Modular.to.pushReplacementNamed("/on-boarding");
          }
        } on FirebaseAuthException catch (e) {
          print('Failed: ${e.code}');
          switch (e.code) {
            case 'invalid-verification-code':
              showToast("Código inválido", error: true);
              break;

            case "too-many-requests":
              showToast("Número bloqueado por muitas tentativas de login");
              break;

            default:
              print('Case of ${e.code} not defined');
              break;
          }
        }
      }
    }

    print("Fora do then");
    loadOverlay.remove();

    authStore.canBack = true;
  }
}
