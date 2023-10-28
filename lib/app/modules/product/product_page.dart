import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/core/models/ads_model.dart';
import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
import 'package:delivery_seller_white_label/app/modules/product/widgets/additional.dart';
import 'package:delivery_seller_white_label/app/modules/product/widgets/characteristics.dart';
import 'package:delivery_seller_white_label/app/modules/product/widgets/store_informations.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'product_store.dart';
import 'widgets/item_data.dart';
import 'widgets/opinions.dart';
import 'widgets/product_informations.dart';

class ProductPage extends StatefulWidget {
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final MainStore mainStore = Modular.get();
  final ProductStore store = Modular.get();

  @override
  void dispose(){
    store.imageIndex = 1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('product page: ${mainStore.adsId}');
    return Listener(
      onPointerDown: (_) => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Stack(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('ads')
                  .doc(mainStore.adsId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CenterLoadCircular();
                } else {
                  AdsModel model = AdsModel.fromDoc(snapshot.data!);
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                            height: viewPaddingTop(context) + wXD(60, context)),
                        ItemData(model: model),
                        Characteristics(model: model),
                        StoreInformations(
                          sellerId: model.sellerId, adsId: model.id,
                        ),
                        GetFutureList(model: model,),
                        Opinions(model: model),
                      ],
                    ),
                  );
                }
              },
            ),
            DefaultAppBar('Detalhes')
          ],
        ),
      ),
    );
  }
}

class GetFutureList extends StatelessWidget{
  final AdsModel model;

  GetFutureList({Key? key, required this.model}) : super(key: key);

  final ProductStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: store.getAdditionalQuery(model.id),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return LinearProgressIndicator();
        }

        List<DocumentSnapshot> additionalQuery = snapshot.data!['customer-additional'];
        List<Map<String, dynamic>> snapshotData = snapshot.data!['seller-additional'];
        return Column(
          children: [
            ProductInformations(
              adsModel: model,
              snapshotData: snapshotData,
            ),
            Additional(
              adsModel: model,
              additionalQuery: additionalQuery,
            ),
          ],
        );
      }
    );
  }

}
