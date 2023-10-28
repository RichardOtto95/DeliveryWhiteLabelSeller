import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';

import 'opinions.dart';

class AllRatings extends StatefulWidget {
  final String adsId;
  AllRatings({Key? key, required this.adsId}) : super(key: key);

  @override
  _AllRatingsState createState() => _AllRatingsState();
}

class _AllRatingsState extends State<AllRatings> {
  int items = 25;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("ads")
                .doc(widget.adsId)
                .collection("ratings")
                .orderBy("created_at", descending: true)
                .limit(items)
                .snapshots(),
            builder: (context, snapshot) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: wXD(80, context),
                  // bottom: wXD(30, context),
                ),
                child: Column(
                  children: [
                    ...snapshot.data!.docs
                        .map((e) => Opinion(
                              productOpnion: e['product_opnion'],
                              rating: e['product_rating'].toDouble(),
                            ))
                        .toList(),
                    snapshot.data!.docs.length < items
                        ? Container()
                        : InkWell(
                            onTap: () => setState(() => items += 25),
                            child: Container(
                              height: wXD(50, context),
                              width: maxWidth(context),
                              alignment: Alignment.center,
                              child: Text(
                                "Mostrar mais",
                                style: textFamily(context, fontSize: 17),
                              ),
                            ),
                          )
                  ],
                ),
              );
            },
          ),
          DefaultAppBar('Avaliações'),
        ],
      ),
    );
  }
}
