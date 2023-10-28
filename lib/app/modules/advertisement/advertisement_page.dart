import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/core/models/ads_model.dart';
import 'package:delivery_seller_white_label/app/modules/advertisement/widgets/advertisement_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/ads.dart';
import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';

import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/emtpy_state.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/floating_circle_button.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_seller_white_label/app/modules/advertisement/advertisement_store.dart';
import 'package:flutter/material.dart';

import 'widgets/delete_ads.dart';

class AdvertisementPage extends StatefulWidget {
  @override
  AdvertisementPageState createState() => AdvertisementPageState();
}

class AdvertisementPageState extends State<AdvertisementPage> {
  final AdvertisementStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  late OverlayEntry overlayEntry;
  final ScrollController scrollController = ScrollController();
  final ScrollController deleteScrollController = ScrollController();
  final User? _user = FirebaseAuth.instance.currentUser;

  double offset = 0.0;
  double maxScrollExtent = 0.0;

  int limit = 15;

  double lastExtent = 0;

  @override
  initState() {
    deleteScrollController.addListener(() {
      maxScrollExtent = deleteScrollController.position.maxScrollExtent;
      offset = deleteScrollController.offset;
    });

    scrollController.addListener(() {
      if (scrollController.offset >
              (scrollController.position.maxScrollExtent - 300) &&
          lastExtent < scrollController.position.maxScrollExtent) {
        setState(() {
          lastExtent = scrollController.position.maxScrollExtent;
          limit += 10;
          // print("adicionando mais 10");
          // print("scroll: ${scrollController.offset}");
          // print("maxContent: ${scrollController.position.maxScrollExtent}");
          // print("limit: $limit");
        });
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        mainStore.setVisibleNav(true);
        store.setAddAds(true);
      } else {
        mainStore.setVisibleNav(false);
        store.setAddAds(false);
      }
    });
    // mainStore.mainScrollController.addListener(() {
    //   if (mainStore.mainScrollController.position.userScrollDirection ==
    //       ScrollDirection.reverse) {
    //   } else if (mainStore.mainScrollController.position.userScrollDirection ==
    //       ScrollDirection.forward) {
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerDown: (a) {
          if (mainStore.menuOverlay != null) {
            mainStore.menuOverlay?.remove();
            mainStore.menuOverlay = null;
          }
        },
        onPointerUp: (a) {
          // print('pointer up: ${scrollController.positions.length}');
          // print('pointer up: $offset');
          if (wXD(offset, context) < -55) {
            store.callDelete(removeDelete: true);
          } else if ((wXD(maxScrollExtent, context) + wXD(80, context)) <
              wXD(offset, context)) {
            store.callDelete(removeDelete: true);
            deleteScrollController.animateTo(0,
                duration: Duration(milliseconds: 10), curve: Curves.ease);
          }
        },
        child: Stack(
          children: [
            Container(
              height: maxHeight(context),
              width: maxWidth(context),
              child: SingleChildScrollView(
                controller: scrollController,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("sellers")
                      .doc(_user!.uid)
                      .collection('ads')
                      .orderBy("created_at", descending: true)
                      .where("status", whereIn: ["ACTIVE", "UNDER-ANALYSIS"])
                      .limit(limit)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                    }
                    if (!snapshot.hasData) {
                      return CenterLoadCircular();
                    } else {
                      QuerySnapshot qs = snapshot.data!;
                      // qs.docs.forEach((adDoc) {});
                      // WidgetsBinding.instance.addTimingsCallback((_) {
                      //   store.charging = store.setAdsValues(qs);
                      // });
                      List<AdsModel> adsList = [];
                      for (DocumentSnapshot adsDoc in qs.docs) {
                        // print("adsDoc.id: ${adsDoc.id}");
                        adsList.add(AdsModel.fromDoc(adsDoc));
                      }
                      // WidgetsBinding.instance
                      //     ?.addPostFrameCallback((timeStamp) {
                      //   store.adsActive = adsList.length;
                      // });
                      return Observer(
                        builder: (context) {
                          switch (store.adsStatusSelected) {
                            case 'ACTIVE':
                              return adsList.isEmpty
                                ? EmptyState(
                                    text: 'Sem anúncios ativos',
                                    icon: Icons.campaign_outlined,
                                    height: maxHeight(context),
                                ) : Column(
                                  children: <Widget>[
                                    SizedBox(
                                        height: viewPaddingTop(context) +
                                            wXD(60, context)),
                                    ...adsList.map(
                                      (ads) {
                                        String image = '';
                                        if (ads.images.isNotEmpty) {
                                          image = ads.images.first;
                                        }
                                        return Ads(
                                          ad: ads,
                                          image: image,
                                        );
                                      },
                                    ),
                                    Container(
                                      height: wXD(120, context),
                                      width: wXD(100, context),
                                      alignment: Alignment.center,
                                      child: limit == qs.docs.length
                                          ? CircularProgressIndicator()
                                          : Container(),
                                    ),
                                  ],
                                );
                            case 'pending':
                              return store.charging
                                  ? CenterLoadCircular()
                                  : store.pendingAds.isEmpty
                                      ? EmptyState(
                                          text: 'Sem anúncios pendentes',
                                          icon: Icons.campaign_outlined,
                                        )
                                      : Column(
                                          children: <Widget>[
                                            SizedBox(height: wXD(123, context)),
                                            ...store.pendingAds.map(
                                              (ads) => Ads(
                                                ad: AdsModel(
                                                  id: ads.id,
                                                  title: ads.title,
                                                  // sellerPrice: ads.sellerPrice,
                                                  paused: ads.paused,
                                                  highlighted: ads.highlighted,
                                                  description: ads.description,
                                                ),
                                                image:
                                                    'https://t2.tudocdn.net/518979?w=660&h=643',
                                              ),
                                            ),
                                            SizedBox(height: wXD(120, context))
                                          ],
                                        );
                            case 'expired':
                              return store.charging
                                  ? CenterLoadCircular()
                                  : store.expiredAds.isEmpty
                                      ? EmptyState(
                                          text: 'Sem anúncios expirados',
                                          icon: Icons.campaign_outlined,
                                        )
                                      : Column(
                                          children: <Widget>[
                                            SizedBox(height: wXD(123, context)),
                                            ...store.expiredAds.map(
                                              (ads) => Ads(
                                                ad: AdsModel(
                                                  id: ads.id,
                                                  title: ads.title,
                                                  // sellerPrice: ads.sellerPrice,
                                                  paused: ads.paused,
                                                  highlighted: ads.highlighted,
                                                  description: ads.description,
                                                ),
                                                image:
                                                    'https://t2.tudocdn.net/518979?w=660&h=643',
                                              ),
                                            ),
                                            Container(
                                              height: wXD(120, context),
                                              width: wXD(100, context),
                                              alignment: Alignment.center,
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          ],
                                        );
                            default:
                              return Text('Is wroooooooong');
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ),
            AdvertisementAppBar(),
            Observer(builder: (context) {
              return AnimatedPositioned(
                duration: Duration(milliseconds: 400),
                curve: Curves.ease,
                bottom: wXD(127, context),
                right: store.addAds ? wXD(17, context) : wXD(-56, context),
                child: FloatingCircleButton(
                  onTap: () {
                    Modular.to.pushNamed('/advertisement/create-ads');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) => CreateAds(),
                    //   ),
                    // );
                  },
                  size: wXD(56, context),
                  child: Icon(
                    Icons.add,
                    size: wXD(30, context),
                    color: getColors(context).primary,
                  ),
                ),
              );
            }),
            Observer(builder: (context) {
              return Visibility(
                visible: store.delete,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: store.delete ? 2 : 0.001,
                      sigmaY: store.delete ? 2 : 0.001),
                  child: AnimatedOpacity(
                    opacity: store.delete ? .6 : 0,
                    duration: Duration(seconds: 1),
                    child: GestureDetector(
                      onTap: () => store.callDelete(removeDelete: true),
                      child: Container(
                        height: store.delete ? maxHeight(context) : 0,
                        width: store.delete ? maxWidth(context) : 0,
                        color: getColors(context).onBackground,
                      ),
                    ),
                  ),
                ),
              );
            }),
            Observer(builder: (context) {
              return AnimatedPositioned(
                top: store.delete ? 0 : maxHeight(context),
                duration: Duration(seconds: 1),
                curve: Curves.ease,
                child: DeleteAds(
                  scrollController: deleteScrollController,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
