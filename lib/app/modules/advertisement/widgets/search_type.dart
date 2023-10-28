import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/emtpy_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../advertisement_store.dart';

class SearchType extends StatelessWidget {
  SearchType({Key? key}) : super(key: key);

  final AdvertisementStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      height: hXD(530, context),
      decoration: BoxDecoration(
        color: getColors(context).surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
      ),
      alignment: Alignment.topLeft,
      child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection("types")
              .where("status", isEqualTo: "ACTIVE")
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CenterLoadCircular();
            }

            List<QueryDocumentSnapshot<Map<String, dynamic>>> types =
                snapshot.data!.docs;

            if (types.isEmpty) {
              return EmptyState(
                text: "Sem tipos ainda",
                icon: Icons.branding_watermark_outlined,
              );
            }
            store.types = types;

            return StatefulBuilder(builder: (context, stfbState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: maxWidth(context),
                    padding: EdgeInsets.fromLTRB(
                      wXD(29, context),
                      wXD(24, context),
                      wXD(25, context),
                      wXD(11, context),
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.5)))),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: wXD(23, context),
                          color: getColors(context).primary,
                        ),
                        SizedBox(width: wXD(24, context)),
                        Expanded(
                          child: TextField(
                            onChanged: (txt) {
                              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                  searchedTypes = [];

                              if (txt == "") {
                                searchedTypes = types;
                              } else {
                                types.forEach((type) {
                                  if (type["type"]
                                      .toString()
                                      .toLowerCase()
                                      .contains(txt.toLowerCase())) {
                                    searchedTypes.add(type);
                                  }
                                });
                              }
                              store.types = searchedTypes;
                            },
                            decoration: InputDecoration.collapsed(
                              hintText: 'Buscar tipo',
                              hintStyle: textFamily(
                                context,
                                fontSize: 15,
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.7),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(3),
                          onTap: () => store.setSearchType(false),
                          child: Icon(
                            Icons.close_rounded,
                            size: wXD(20, context),
                            color: Color(0xff555869).withOpacity(.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                          top: wXD(23, context),
                          left: wXD(19, context),
                          right: wXD(19, context)),
                      child: Observer(builder: (context) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: store.types
                              .map(
                                (e) => GestureDetector(
                                  onTap: () async {
                                    store.editingAd
                                        ? store.adEdit.type = e.get("type")
                                        : store.adsType = e.get("type");
                                    store.typeValidateVisible = false;
                                    store.setSearchType(false);
                                  },
                                  child: Container(
                                    width: maxWidth(context),
                                    padding: EdgeInsets.only(
                                        bottom: wXD(20, context)),
                                    child: Text(
                                      e.get("type"),
                                      style: textFamily(
                                        context,
                                        fontSize: 17,
                                        color: getColors(context).onBackground,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }),
                    ),
                  ),
                ],
              );
            });
          }),
    );
  }
}
