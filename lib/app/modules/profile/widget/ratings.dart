import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/core/models/ads_model.dart';
import 'package:delivery_seller_white_label/app/core/models/rating_model.dart';
import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
import 'package:delivery_seller_white_label/app/modules/profile/profile_store.dart';
import 'package:delivery_seller_white_label/app/modules/profile/widget/ratings_app_bar.dart';

import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class Ratings extends StatefulWidget {
  Ratings({Key? key}) : super(key: key);

  @override
  State<Ratings> createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  final MainStore mainStore = Modular.get();

  final ProfileStore store = Modular.get();

  final User? _userAuth = FirebaseAuth.instance.currentUser;

  final ScrollController scrollController = ScrollController();

  int limit = 10;

  double lastExtent = 0;

  @override
  void initState() {
    store.clearNewRatings();
    scrollController.addListener(() {
      if (scrollController.offset >
              (scrollController.position.maxScrollExtent - 200) &&
          lastExtent < scrollController.position.maxScrollExtent) {
        setState(() {
          limit += 10;
          lastExtent = scrollController.position.maxScrollExtent;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Observer(
            builder: (context) {
              print("concluded: ${store.concluded}");
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("sellers")
                    .doc(_userAuth!.uid)
                    .collection("ratings")
                    .where("answered", isEqualTo: store.concluded)
                    .orderBy("created_at", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CenterLoadCircular();
                  }
                  List<DocumentSnapshot<Map<String, dynamic>>> ratings =
                      snapshot.data!.docs;
                  print("ratings: ${ratings.length}");
                  if (ratings.isEmpty) {
                    return Container(
                      width: maxWidth(context),
                      height: maxHeight(context),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_border_rounded,
                              size: wXD(200, context),
                              color: getColors(context).onBackground),
                          Observer(
                            builder: (context) {
                              return Text(
                                  store.concluded
                                      ? "Sem avaliações respondidas"
                                      : "Sem avaliações concluídas",
                                  style: textFamily(
                                    context,
                                  ));
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        SizedBox(
                            height: viewPaddingTop(context) + wXD(70, context)),
                        ...ratings.map(
                          (rating) => Rating(
                            ratingModel: RatingModel.fromDocSnapshot(rating),
                          ),
                        ),
                        SizedBox(height: wXD(120, context))
                      ],
                    ),
                  );
                },
              );
            },
          ),
          RatingsAppbar(onTap: (val) {
            // print("val: $val");
            if ((val == 1 && !store.concluded) ||
                (val == 0 && store.concluded)) {
              limit = 10;
              lastExtent = 0;
            }
            // print("concluded: ${store.concluded}");
            store.setConcluded(val == 1);
            // print("concluded: ${store.concluded}");
          }),
        ],
      ),
    );
  }
}

class Rating extends StatefulWidget {
  final RatingModel ratingModel;

  Rating({
    Key? key,
    required this.ratingModel,
  }) : super(key: key);

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  final ProfileStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: wXD(6, context),
              left: wXD(4, context),
              top: wXD(20, context),
            ),
            child: Text(
              getRatingDate(widget.ratingModel.createdAt!.toDate()),
              style: textFamily(
                context,
                fontSize: 14,
                color: getColors(context).onBackground,
              ),
            ),
          ),
          Container(
            height: wXD(105, context),
            width: wXD(352, context),
            padding: EdgeInsets.fromLTRB(
              wXD(19, context),
              wXD(15, context),
              wXD(15, context),
              wXD(7, context),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffF1F1F1)),
              borderRadius: BorderRadius.all(Radius.circular(3)),
              color: getColors(context).surface,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  offset: Offset(0, 3),
                  color: getColors(context).shadow,
                )
              ],
            ),
            alignment: Alignment.center,
            child: FutureBuilder<Map<String, dynamic>>(
                // future: FirebaseFirestore.instance.collection("orders").doc(ratingModel.orderId).get(),
                future: store.getAdsDoc(widget.ratingModel),
                builder: (context, snapshotFuture) {
                  if (snapshotFuture.hasError) {
                    print(snapshotFuture.error);
                  }
                  if (!snapshotFuture.hasData) {
                    return CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(getColors(context).primary),
                    );
                  }

                  Map<String, dynamic> responseMap = snapshotFuture.data!;
                  AdsModel adsModel =
                      AdsModel.fromDoc(responseMap['firstAdsDoc']);

                  return InkWell(
                    onTap: () async {
                      store.orderId = widget.ratingModel.orderId;
                      store.raitingId = widget.ratingModel.id;
                      await Modular.to.pushNamed(
                        '/profile/answer-rating',
                        arguments: responseMap['ratingModelList'],
                      );
                      setState(() {});
                      print('depois da rota');
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: wXD(12, context)),
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl: adsModel.images.first,
                              height: wXD(65, context),
                              width: wXD(62, context),
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, progress) =>
                                      CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    getColors(context).primary),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: wXD(8, context)),
                          width: wXD(220, context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                adsModel.title,
                                style: textFamily(context,
                                    color: getColors(context).onBackground),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: wXD(3, context)),
                              Text(
                                adsModel.description,
                                style: textFamily(context,
                                    color: getColors(context).onSurface,
                                    fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // SizedBox(height: wXD(3, context)),
                              // Text(
                              //   '${grade.toString()} item',
                              //   style: textFamily(context,
                              //       color: getColors(context).onSurface.withOpacity(.7)),
                              //   maxLines: 2,
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                              RatingBar(
                                initialRating:
                                    responseMap['average'].toDouble(),
                                onRatingUpdate: (value) {},
                                ignoreGestures: true,
                                glowColor:
                                    getColors(context).primary.withOpacity(.4),
                                unratedColor:
                                    getColors(context).primary.withOpacity(.4),
                                allowHalfRating: true,
                                itemSize: wXD(25, context),
                                ratingWidget: RatingWidget(
                                  full: Icon(Icons.star_rounded,
                                      color: getColors(context).primary),
                                  empty: Icon(Icons.star_outline_rounded,
                                      color: getColors(context).primary),
                                  half: Icon(Icons.star_half_rounded,
                                      color: getColors(context).primary),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: wXD(10, context)),
                        Icon(
                          Icons.arrow_forward,
                          size: wXD(14, context),
                          color: getColors(context).onSurface.withOpacity(.7),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  // double getRatingMedia() {
  String getRatingDate(DateTime date) {
    String strDate = '';

    String weekDay = DateFormat('EEEE').format(date);
    // print("weekDay: $weekDay");

    String month = DateFormat('MMMM').format(date);
    // print("month: $month");

    strDate =
        "${weekDay.substring(0, 1).toUpperCase()}${weekDay.substring(1, 3)} ${date.day} $month ${date.year}";
    // print("strDate: $strDate");

    return strDate;
  }
}

class StarsCharging extends StatefulWidget {
  const StarsCharging({Key? key}) : super(key: key);

  @override
  _StarsChargingState createState() => _StarsChargingState();
}

class _StarsChargingState extends State<StarsCharging>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 5000),
    );
    animationController.forward();
    animationController.addListener(() {
      // setState(() {
      if (animationController.status == AnimationStatus.completed) {
        animationController.repeat();
      }
      // });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(animationController),
          child: Icon(
            Icons.star_outline_rounded,
            color: getColors(context).primary,
            size: wXD(25, context),
          ),
        ),
      ),
    );
  }
}
