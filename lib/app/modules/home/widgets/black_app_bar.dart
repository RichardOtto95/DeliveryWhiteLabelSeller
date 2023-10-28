import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../core/models/address_model.dart';

class BlackAppBar extends StatelessWidget {
  final MainStore mainStore = Modular.get();
  final User? _user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyleFromColor(getColors(context).primary),
      child: Container(
        width: maxWidth(context),
        height: MediaQuery.of(context).viewPadding.top + wXD(60, context),
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(3)),
          color: getColors(context).primary,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: getColors(context).shadow,
              offset: Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.bottomCenter,
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(_user!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              DocumentSnapshot sellerDoc = snapshot.data!;

              if (sellerDoc['main_address'] == null) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: wXD(4, context)),
                    Icon(
                      Icons.location_on,
                      color: getColors(context).onPrimary,
                    ),
                    SizedBox(width: wXD(4, context)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: TextButton(
                        onPressed: () async => await Modular.to
                            .pushNamed('/address', arguments: false),
                        child: Text(
                          "Cadastrar endereço",
                          maxLines: 1,
                          style: TextStyle(
                            color: getColors(context).onPrimary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream:
                    Address(id: sellerDoc['main_address']).getAddressSnap(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  Address address = Address.fromDoc(snapshot.data!);
                  // print('address: ${address.formatedAddress}');
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: getColors(context).onPrimary,
                      ),
                      SizedBox(width: wXD(4, context)),
                      Container(
                        alignment: Alignment.center,
                        width: wXD(270, context),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: TextButton(
                            onPressed: () async => await Modular.to
                                .pushNamed('/address', arguments: false),
                            child: Text(address.formatedAddress!,
                                maxLines: 1,
                                style: TextStyle(
                                    color: getColors(context).onPrimary,
                                    fontSize: 12)),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
      ),
    );
  }

  Future<String> getAddress() async {
    final User? _userAuth = FirebaseAuth.instance.currentUser;

    print("getAddress");
    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection("sellers")
        .doc(_userAuth!.uid)
        .get();

    mainStore.sellerOn = _user['online'];

    if (_user.get("main_address") == null) {
      Modular.to.pushNamed("/address", arguments: true);
      return "Sem endereço cadastrado";
    }
    DocumentSnapshot address = await _user.reference
        .collection("addresses")
        .doc(_user.get("main_address"))
        .get();
    return address.get("formated_address");
  }
}
