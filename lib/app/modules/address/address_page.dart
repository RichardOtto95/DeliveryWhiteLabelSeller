import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/core/models/address_model.dart';
import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/emtpy_state.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/side_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_seller_white_label/app/modules/address/address_store.dart';
import 'package:flutter/material.dart';
import '../../shared/widgets/delivery_search_field.dart';
import 'widgets/address.dart';
import 'widgets/address_edition.dart';
import 'widgets/address_popup.dart';

class AddressPage extends StatefulWidget {
  final bool signRoot;

  AddressPage({Key? key, this.signRoot = false}) : super(key: key);
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends ModularState<AddressPage, AddressStore> {
  final MainStore mainStore = Modular.get();
  final AddressStore addressStore = Modular.get();
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    print("user.uid: ${user.uid}");
    if (widget.signRoot) {
      showToast("Defina um endereço para continuar");
    }
    super.initState();
  }

  getAdressPopUpOverlay(Address addressModel, context, bool isSingle) {
    store.editAddressOverlay = OverlayEntry(
      builder: (ovContext) => AddressPopUp(
        isSingle: isSingle,
        model: addressModel,
        onCancel: () {
          store.editAddressOverlay!.remove();
          store.addresEditionOverlay = null;
        },
        onEdit: () {
          store.editAddressOverlay!.remove();
          store.editAddressOverlay = null;
          store.addresEditionOverlay = OverlayEntry(
            builder: (oContext) => AddressEdition(
              address: addressModel,
              onBack: (Address? address) {
                if (address != null) {
                  print("Modular: ${Modular.to.path}");
                  Modular.to.pushNamed(
                    "/address/place-picker",
                    arguments: {
                      "address": address,
                      "editing": true,
                    },
                  );
                }
                store.addresEditionOverlay!.remove();
                store.addresEditionOverlay = null;
              },
              editing: true,
            ),
          );
          Overlay.of(context)!.insert(store.addresEditionOverlay!);
        },
        onDelete: () async {
          print('onDelete');
          store.deleteAddress(context, addressModel);
        },
      ),
    );
    Overlay.of(context)!.insert(store.editAddressOverlay!);
  }

  @override
  Widget build(context) {
    return WillPopScope(
      onWillPop: () async {
        print('_overlay != null: ${store.addresEditionOverlay != null}');
        print(
            'mainStore.globalOverlay != null: ${mainStore.globalOverlay != null}');
        print(
            'store.editAddressOverlay != null: ${store.editAddressOverlay != null}');
        if (store.addresEditionOverlay != null) {
          store.addresEditionOverlay!.remove();
          store.addresEditionOverlay = null;
          return false;
        }

        if (mainStore.globalOverlay != null) {
          mainStore.globalOverlay!.remove();
          mainStore.globalOverlay = null;
          return false;
        }

        if (store.editAddressOverlay != null) {
          store.editAddressOverlay!.remove();
          store.editAddressOverlay = null;
          return false;
        }

        return true;
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: maxHeight(context),
              width: maxWidth(context),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                        height: viewPaddingTop(context) + wXD(60, context)),
                    DeliverySearchField(
                      onTap: () async {
                        Modular.to.pushNamed("/address/place-picker", arguments: {
                          "address": Address(),
                          "editing": false,
                        });
                      },
                    ),
                    // UseCurrentLocalization(),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                        .collection("sellers")
                        .doc(user.uid)
                        .collection("addresses")
                        .where("status", isEqualTo: "ACTIVE")
                        .orderBy("main", descending: true)
                        .orderBy("created_at", descending: true)
                        .snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.hasError){
                          print(snapshot.error);
                        }
                        if (!snapshot.hasData) {
                          return CenterLoadCircular();
                        }

                        QuerySnapshot addresses = snapshot.data!;
                        store.hasAddress = addresses.docs.length != 0;
                        
                        if (addresses.docs.isEmpty) {
                          return EmptyState(
                            height: maxHeight(context) -
                                (viewPaddingTop(context) + wXD(200, context)),
                            text: "Sem endereços ainda",
                            icon: Icons.email_outlined,
                          );
                        }

                        return Column(
                          children: addresses.docs.map((address) => AddressWidget(
                            model: Address.fromDoc(address),
                            iconTap: () {
                              getAdressPopUpOverlay(Address.fromDoc(address), context, addresses.docs.length == 1);
                            },
                          )).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: DefaultAppBar(
                'Endereço de entrega',
              ),
            ),
            Visibility(
              visible: widget.signRoot && store.hasAddress,
              child: Positioned(
                bottom: wXD(50, context),
                right: 0,
                child: SideButton(
                  title: "Continuar",
                  height: wXD(52, context),
                  width: wXD(120, context),
                  onTap: () => Modular.to.pushNamed("/main"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}