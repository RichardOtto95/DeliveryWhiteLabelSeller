import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/emtpy_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../advertisement_store.dart';

class ChooseCategoryPage extends StatelessWidget {
  final String categoryId;
  final AdvertisementStore store = Modular.get();

  ChooseCategoryPage({
    Key? key,
    required this.categoryId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('categories')
                  .doc(categoryId)
                  .collection('options')
                  .where("status", isEqualTo: "ACTIVE")
                  .orderBy('created_at', descending: false)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CenterLoadCircular();
                }

                if (snapshot.data == null) {
                  return Container();
                }

                if (snapshot.data!.docs.isEmpty) {
                  return EmptyState(
                    text: "Sem subcategorias ainda",
                    icon: Icons.category_outlined,
                  );
                }

                QuerySnapshot options = snapshot.data!;

                print('options.docs.length: ${options.docs.length}');

                return Column(
                  children: [
                    SizedBox(
                        height: viewPaddingTop(context) + wXD(60, context)),
                    ...List.generate(
                      options.docs.length,
                      (index) {
                        DocumentSnapshot optionDoc = options.docs[index];
                        print('itemBuilder: $index, ${optionDoc['label']}');
                        return GestureDetector(
                          onTap: () {
                            store.editingAd
                                ? store.adEdit.option = optionDoc['label']
                                : store.setAdsOption(optionDoc['label']);
                            store.categoryValidateVisible = false;
                            print(
                                "Modular.to.localPath: ${Modular.to.localPath}");
                            Modular.to.popUntil(
                              (route) {
                                // print(
                                //     "\n route.settings.name: ${route.settings.name}");
                                // print(
                                //     "${route.settings.name} =='/advertisement/create-ads@0': ${route.settings.name == "/advertisement/create-ads@0"} ");
                                return route.settings.name!
                                    .contains("/advertisement/create-ads");
                              },
                            );
                            // Modular.to.popUntil((route) => route.navigator.;
                            // Modular.to.pushNamedAndRemoveUntil(
                            //     '/advertisement/create-ads',
                            //     ModalRoute.withName(
                            //         '/advertisement/create-ads'));
                          },
                          child: Container(
                            width: maxWidth(context),
                            height: wXD(52, context),
                            margin: EdgeInsets.symmetric(
                                horizontal: wXD(23, context)),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: getColors(context)
                                            .onBackground
                                            .withOpacity(.2)))),
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  optionDoc['label'],
                                  style: textFamily(
                                    context,
                                    color: getColors(context).primary,
                                    fontSize: 17,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: wXD(23, context),
                                  color: getColors(context).primary,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          Observer(builder: (context) {
            return DefaultAppBar(
                store.editingAd ? store.adEdit.category : store.adsCategory);
          }),
        ],
      ),
    );
  }
}
