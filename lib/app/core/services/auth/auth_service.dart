import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/core/models/seller_model.dart';
import 'package:delivery_seller_white_label/app/core/services/auth/auth_service_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class AuthService implements AuthServiceInterface {
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future handleFacebookSignin() {
    return Future(() {});
  }

  @override
  Future<String> handleGetToken() {
    return Future(() => '');
  }

  @override
  handleGetUser() async {
    return Future(() => _auth.currentUser!);
  }

  @override
  Future preRegisteredUser(seller) async {
    Seller newSeller = Seller();
    try {
      QuerySnapshot preRegisterUserQuery = await FirebaseFirestore.instance
        .collection("sellers")
        .where('status', isEqualTo: 'PREREGISTERED')
        .where('phone', isEqualTo: seller.phone)
        .get();

      print('preRegisterUserQuery: ${preRegisterUserQuery.docs.length}');

      if (preRegisterUserQuery.docs.isNotEmpty) {
        DocumentSnapshot preRegisterUserDoc = preRegisterUserQuery.docs.first;
        newSeller.username = preRegisterUserDoc['username'];
        newSeller.avatar = preRegisterUserDoc['avatar'];
        // newSeller.phone = preRegisterDoc['phone'];
        newSeller.corporateName = preRegisterUserDoc['corporate_name'];
        newSeller.storeCategory = preRegisterUserDoc['store_category'];
        newSeller.storeDescription = preRegisterUserDoc['store_description'];
        newSeller.storeName = preRegisterUserDoc['store_name'];
        // newSeller.id = seller.id;

        Seller? responseSeller = await handleSignup(newSeller);
        await preRegisterUserDoc.reference.update({
          'status': "REGISTERED",
          'user_id': seller.id,
        });

        QuerySnapshot preRegisterAds =
            await preRegisterUserDoc.reference.collection("ads").get();
        if (preRegisterAds.docs.isNotEmpty) {
          DocumentSnapshot sellerDoc = await FirebaseFirestore.instance
              .collection('sellers')
              .doc(responseSeller!.id)
              .get();
          for (var i = 0; i < preRegisterAds.docs.length; i++) {
            DocumentSnapshot preRegisterAdsDoc = preRegisterAds.docs[i];
            DocumentReference sellerAdsRef =
                sellerDoc.reference.collection('ads').doc(preRegisterAdsDoc.id);
            await sellerAdsRef.set(preRegisterAdsDoc.data());
            await sellerAdsRef.update({
              'seller_id': sellerDoc.id,
              'status': 'ACTIVE',
            });

            await FirebaseFirestore.instance
                .collection('ads')
                .doc(preRegisterAdsDoc.id)
                .update({
              'seller_id': sellerDoc.id,
              'status': 'ACTIVE',
            });
          }
        }
      } else {
        await handleSignup(seller);
      }
    } catch (e) {
      print('error');
      print(e);
    }
  }

  @override
  Future<User> handleEmailSignin(String userEmail, String userPassword) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: userEmail, password: userPassword);
    final User? user = result.user!;

    assert(user != null);
    // assert(await user!.getIdToken() != null);

    final User currentUser = _auth.currentUser!;
    assert(user!.uid == currentUser.uid);

    //print'signInEmail succeeded: $user');

    return user!;
  }

  @override
  Future<Seller?> handleSignup(seller) async {
    print('%%%%%%%% handleSignup %%%%%%%%');
    User user = _auth.currentUser!;
    if (seller != null) {
      seller.id = user.uid;
      seller.createdAt = Timestamp.now();
      if (seller.username == null || seller.username == '') {
        seller.username = '${user.phoneNumber}';
      }
      seller.notificationEnabled = true;
      seller.phone = user.phoneNumber;
      seller.status = 'ACTIVE';
      seller.connected = true;
      seller.online = false;
      seller.country = 'Brasil';
      seller.tokenId = [];
      print('sellerMap: ${Seller().toJson(seller)}');
      DocumentReference sellerRef =
          FirebaseFirestore.instance.collection('sellers').doc(user.uid);

      await sellerRef.set(Seller().toJson(seller));
      if(!kIsWeb){
        String? tokenString = await FirebaseMessaging.instance.getToken();
        print('tokenId: $tokenString');
        await sellerRef.update({
          'token_id': [tokenString]
        });
      }

      DocumentReference additionalObservationRef = await sellerRef.collection('additional').add({
        "created_at": FieldValue.serverTimestamp(),
        "hint": "Observação:",
        "id": null,
        "increment_value": null,
        "increment_maximum": null,
        "increment_minimum": null,
        "number_mandatory_fields": 0,
        "mandatory": false,
        "short": false,
        "not_edit": true,
        "status": "ACTIVE",
        "title": "Observação",
        "type": "text-area",
        "index": 1,
        "auto_selected": true,
        "seller_config": "reading",
        "customer_config": "edition",
        "alignment": "left",
        "font_size": 18,
      });
      additionalObservationRef.update({"id": additionalObservationRef.id});

      DocumentReference additionalNewOrOld = await sellerRef.collection('additional').add({
        "created_at": FieldValue.serverTimestamp(),
        "hint": null,
        "id": null,
        "increment_value": null,
        "increment_maximum": null,
        "increment_minimum": null,
        "number_mandatory_fields": null,
        "mandatory": false,
        "not_edit": false,
        "status": "ACTIVE",
        "title": "Novo/Usado",
        "type": "radio-button",
        "short": false,
        "index": 0,
        "auto_selected": true,
        "seller_config": "edition",
        "customer_config": "reading",
        "alignment": "left",
        "font_size": 18,
      });
      await additionalNewOrOld.update({"id": additionalNewOrOld.id});

      for (var i = 0; i < 2; i++) {
        String label = i == 0 ? "Novo" : "Usado";
        DocumentReference ref = await additionalNewOrOld.collection('radiobutton').add({
          "id": "",
          "index": i,
          "label": label,
          "value": 0,
          "status": "ACTIVE",
        });
        await ref.update({"id": ref.id});
      }

      return seller;
    }
    return null;
  }

  @override
  Future<User> handleLinkAccountGoogle(User _user) async {
    // final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    // final GoogleSignInAuthentication googleAuth =
    //     await googleUser.authentication;
    User user = _user;

    // final AuthCredential credential = GoogleAuthProvider.getCredential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );

    // user = (await _user.linkWithCredential(credential)).user;
    // //print"signed in " + user.displayName);
    // Firestore.instance
    //     .collection('users')
    //     .document(user.uid)
    //     .updateData({'firstName': user.displayName, 'email': user.email});
    // // var credentialResult = await _auth.signInWithCredential(credential);
    // // user.linkWithCredential(credential);
    return user;
  }

  @override
  handleGoogleSignin() async {
    // final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    // final GoogleSignInAuthentication googleAuth =
    //     await googleUser.authentication;
    User? user;
    // if (user== null) throw Exception();

    // final AuthCredential credential = GoogleAuthProvider.getCredential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );
    // List<String> providers =
    //     await _auth.fetchSignInMethodsForEmail(email: googleUser.email);
    // //print'providers: $providers');
    // if (providers != null) {
    //   //print"TEM PROV  $user");
    //   user = (await _auth.signInWithCredential(credential)).user;

    //   user.linkWithCredential(credential);
    //   //print"TEM PROV  $user");
    // } else {
    //   user = (await _auth.signInWithCredential(credential)).user;
    //   //print"signed in " + user.displayName);
    //   //print"NAO TEM PROV  $user");
    // }
    // user = (await _auth.signInWithCredential(credential)).user;
    // //print"signed in " + user.displayName);
    // var credentialResult = await _auth.signInWithCredential(credential);
    // user.linkWithCredential(credential);
    return user!;
  }

  @override
  Future handleSetSignout() {
    return _auth.signOut();
  }

  @override
  Future<String> verifyNumber(String userPhone) async {
    String? verifID;
    var phoneMobile = userPhone;
    //print'$phoneMobile');

    await _auth
        .verifyPhoneNumber(
      phoneNumber: phoneMobile,
      verificationCompleted: (AuthCredential authCredential) async {
        //code for signing in}).catchError((e){
        // final User user =
        //     (await _auth.signInWithCredential(authCredential)).user;
        _auth
            .signInWithCredential(authCredential)
            .then((UserCredential result) {
          //print'AuthResult ${result.user}');
        }).catchError((e) {
          //print'ERROR !!! $e');
        });
        // //print'verifyPhoneNumber $e}');
      },
      verificationFailed: (FirebaseAuthException authException) {
        // //printauthException.message);
        //print'ERROR !!! ${authException.message}');
      },
      codeSent: (verificationId, forceResendingToken) {
        verificationId = verificationId;
        verifID = verificationId;
        print("Código enviado para " + userPhone);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
        //printverificationId);
        //print"Timout");
      },
      timeout: Duration(seconds: 60),
    )
        .catchError((e) {
      //print'ERROR !!! $e');
    });
    return verifID!;
  }

  @override
  Future<User> handleSmsSignin(String smsCode, String verificationId) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    final User user = (await _auth.signInWithCredential(credential)).user!;

    return user;
  }
}
