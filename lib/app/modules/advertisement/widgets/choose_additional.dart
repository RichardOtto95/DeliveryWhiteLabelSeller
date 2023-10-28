import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/modules/advertisement/advertisement_store.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
// import 'package:delivery_seller_white_label/app/shared/widgets/emtpy_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChooseAdditional extends StatefulWidget {
  @override
  State<ChooseAdditional> createState() => _ChooseAdditionalState();
}

class _ChooseAdditionalState extends State<ChooseAdditional> {
  final AdvertisementStore store = Modular.get();
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: store.getAdditionalList(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CenterLoadCircular();
                  }
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> additionalQuery =
                      snapshot.data!.docs;
                      
                  return Column(
                    children: [
                      SizedBox(
                        height: viewPaddingTop(context) + wXD(50, context),
                      ),
                      ...additionalQuery.map((additionalDoc) {                        
                        return InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () async {
                            // print('store.checkedAdditional: ${store.checkedAdditionalMap}');
                            print('store.checkedAdditionalList: ${store.checkedAdditionalList}');
                            // print('additionalDoc.id: ${additionalDoc.id}');
                            setState(() {
                              if(!store.checkedAdditionalList.contains(additionalDoc.id)){
                                store.checkedAdditionalList.add(additionalDoc.id);
                              } else{
                                store.checkedAdditionalList.remove(additionalDoc.id);
                                print('additionalDoc.id: ${additionalDoc.id}');
                                print('store.additionalResponse.containsKey(additionalDoc.id): ${store.additionalResponse.containsKey(additionalDoc.id)}');
                                if(store.additionalResponse.containsKey(additionalDoc.id)){
                                  store.additionalResponse.remove(additionalDoc.id);
                                }
                              }
                            });
                          },
                          child: Container(
                            width: maxWidth(context),
                            height: wXD(52, context),
                            margin: EdgeInsets.symmetric(
                              horizontal: wXD(23, context),
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: getColors(context).onBackground.withOpacity(.2),
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(getIcon(additionalDoc['type'])),
                                SizedBox(width: 10,),
                                Container(
                                  width: maxWidth(context) *.65,
                                  child: Text(
                                    additionalDoc['title'],
                                    style: textFamily(
                                      context,
                                      color: getColors(context).primary,
                                      fontSize: 17,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Spacer(),
                                Checkbox(
                                  activeColor: colors.primary,
                                  value: store.checkedAdditionalList.contains(additionalDoc.id),
                                  onChanged: (bool? value){
                                    setState(() {
                                      if(!store.checkedAdditionalList.contains(additionalDoc.id)){
                                        store.checkedAdditionalList.add(additionalDoc.id);
                                      } else{
                                        store.checkedAdditionalList.remove(additionalDoc.id);
                                        print('additionalDoc.id: ${additionalDoc.id}');
                                        print('store.additionalResponse.containsKey(additionalDoc.id): ${store.additionalResponse.containsKey(additionalDoc.id)}');
                                        if(store.additionalResponse.containsKey(additionalDoc.id)){
                                          store.additionalResponse.remove(additionalDoc.id);
                                        }
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                }),
          ),
          DefaultAppBar('Escolha seus adicionais')
        ],
      ),
    );
  }
  IconData getIcon(String type){
    IconData iconData;
    switch (type) {
      case "text-field":
        iconData = Icons.text_fields_outlined;
        break;

      case "increment":
        iconData = Icons.unfold_more;
        break;

      case "radio-button":
        iconData = Icons.radio_button_checked;
        break;

      case "check-box":
        iconData = Icons.check_box;
        break;

      case "text":
        iconData = Icons.abc_outlined;
        break;

      case "text-area":
        iconData = Icons.text_fields_outlined;
        break;

      case "combo-box":
        iconData = Icons.keyboard_arrow_down;
        break;

      default:
        iconData = Icons.error;
        break;
    }
    return iconData;
  }
}
