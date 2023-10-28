import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/core/models/seller_model.dart';
import 'package:delivery_seller_white_label/app/core/modules/root/root_store.dart';
import 'package:delivery_seller_white_label/app/core/utils/auth_status_enum.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';

import '../../../shared/utilities.dart';
import '../../../shared/widgets/load_circular_overlay.dart';
import 'auth_service.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  // _AuthStoreBase() {
  //   _authService.handleGetUser().then(setUser);
  // }
  final AuthService _authService = Modular.get();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RootStore rootController = Modular.get();

  // Seller seller = Seller();
  @observable
  AuthStatus status = AuthStatus.loading;
  @observable
  String? userVerifyId;
  @observable
  String mobile = '';
  @observable
  String? phoneMobile;
  @observable
  bool linked = false;
  // @observable
  // User? user;
  @observable
  bool codeSent = false;
  @observable
  Seller? sellerBD;
  // @observable
  // OverlayEntry? overlayEntry;
  @observable
  bool canBack = true;

  @action
  bool getCanBack() => canBack;

  @action
  setCodeSent(bool _valc) => codeSent = _valc;
  @action
  setLinked(bool _vald) => linked = _vald;
  @action
  String? getUserVerifyiD() => userVerifyId;
  @action
  // setUser(User? value) {
  setUser(User? user) {
    // user = value;
    // status = value == null ? AuthStatus.signed_out : AuthStatus.signed_in;
    status = user == null ? AuthStatus.signed_out : AuthStatus.signed_in;
  }

  // _AuthStoreBase(this.seller);

  @action
  Future signinWithGoogle() async {
    await _authService.handleGoogleSignin();
  }

  @action
  Future linkAccountGoogle() async {
    // await _authService.handleLinkAccountGoogle(user!);
  }

  @action
  Future getUser() async {
    // user = await _authService.handleGetUser();
    User? _user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .get()
        .then((value) {
      // //print'dentro do then  ${value.data['firstName']}');
      sellerBD = Seller.fromDoc(value);
      // user = ;
      // //print'depois do fromDoc  $user');

      return _user;
    });
  }

  // @action
  // Future signup(Seller seller) async {
  //   seller = await _authService.handleSignup(seller);
  // }

  @action
  Future siginEmail(String email, String password) async {
    // user = await _authService.handleEmailSignin(email, password);
  }

  @action
  Future signout() async {
    setUser(null);
    return _authService.handleSetSignout();
  }

  @action
  Future sentSMS(String userPhone) async {
    return _authService.verifyNumber(userPhone);
  }

  @action
  Future verifyNumber(String userPhone, BuildContext context) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(overlayEntry);

    String verifID = '';
    phoneMobile = '+55' + userPhone;
    print('phoneMobile === $phoneMobile');
    mobile = userPhone;

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneMobile!,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) async {
        print('authCredential: =================$authCredential');
        OverlayEntry _overlayEntry =
            OverlayEntry(builder: (context) => LoadCircularOverlay());
        Overlay.of(context)!.insert(_overlayEntry);

        final User _user =
            (await _auth.signInWithCredential(authCredential)).user!;
        // setUser(_user);
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("sellers")
            .doc(_user.uid)
            .get();

        if (userDoc.exists) {
          // QuerySnapshot addresses =
          //     await userDoc.reference.collection("addresses").get();

          print('%%%%%%%% signinPhone _user.exists == true  %%%%%%%%');

          String? tokenString = await FirebaseMessaging.instance.getToken();

          print('tokenId: $tokenString');

          await userDoc.reference.update({
            'token_id': [tokenString]
          });
          Modular.to.pushReplacementNamed("/main");

          // if (addresses.docs.isEmpty) {
          //   Modular.to.pushNamed('/address', arguments: true);
          // } else {
          //   Modular.to.pushNamed("/main");
          // }
        } else {
          print('%%%%%%%% signinPhone _user.exists == false  %%%%%%%%');
          Seller seller = Seller();
          seller.phone = _user.phoneNumber;
          await _authService.preRegisteredUser(seller);
          Modular.to.pushReplacementNamed("/on-boarding");
          // await _authService.handleSignup(seller);
          // Modular.to.pushNamed('/address', arguments: true);
        }
        // Modular.to.pushNamedAndRemoveUntil(
        //   '/main',
        //   (p0) {
        //     print('pushNamedAndRemoveUntil: $p0');
        //     return false;
        //   },
        // );
        _overlayEntry.remove();
      },
      verificationFailed: (FirebaseAuthException authException) {
        print("authException.message: ${authException.message}");
        overlayEntry.remove();
        // overlayEntry = null;
      },
      codeSent: (String verificationId, int? forceResendingToken) async {
        print("verificationId: $verificationId");
        userVerifyId = verificationId;
        verifID = verificationId;
        codeSent = true;
        setCodeSent(true);

        overlayEntry.remove();
        // overlayEntry = null;
        canBack = true;
        await Modular.to.pushNamed('/sign/verify', arguments: userPhone);
      },
      codeAutoRetrievalTimeout: (String verificationId) async {
        print("codeAutoRetrievalTimeout ID: $verificationId");
        verificationId = verificationId;
        verifID = verificationId;
        // codeSent = true;
        // setCodeSent(true);

        // overlayEntry.remove();
        canBack = true;
      },
    );
    return verifID;
  }

  @action
  Future<User?> handleSmsSignin(String smsCode, String verificationId) async {
    print('%%%%%%%% handleSmsSignin %%%%%%%%');

    print('credential: =================$verificationId');
    print('credential: =================$smsCode');

    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    // print('credential: =================$credential');
    try {
      final User _user = (await _auth.signInWithCredential(credential)).user!;
      print('user: =================$_user');
      // user = _user;
      // await FirebaseAuth.instance
      //     .signInWithCredential(credential)
      //     .then((authResult) {
      //   print('KKKKKKKKKKKKKKKKKKKKKK${authResult.user}');
      // });
      return _user;
    } catch (e) {
      print('%%%%%%%%% error: ${e.toString()} %%%%%%%%%%%');
      if (e.toString() ==
          '[firebase_auth/invalid-verification-code] The sms verification code used to create the phone auth credential is invalid. Please resend the verification code sms and be sure use the verification code provided by the user.') {
        Fluttertoast.showToast(
            msg: "Código inválido!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      if (e.toString() ==
          '[firebase_auth/session-expired] The sms code has expired. Please re-send the verification code to try again.') {
        Fluttertoast.showToast(
            msg: "Sessão expirada!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      return null;
    }
  }
}
