import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_seller_white_label/app/core/models/ads_model.dart';
import 'package:delivery_seller_white_label/app/modules/product/product_store.dart';

import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/floating_circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../shared/color_theme.dart';

class ItemData extends StatelessWidget {
  final AdsModel model;
  ItemData({Key? key, required this.model}) : super(key: key);
  final ProductStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      store.setImageIndex(
        (wXD(scrollController.offset, context) ~/ wXD(130.56, context))
                .toInt() +
            1,
      );
    });
    return Observer(
      builder: (context) {
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: wXD(60, context)),
              height: maxWidth(context),
              width: maxWidth(context),
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                // padding: EdgeInsets.only(right: wXD(10, context)),
                physics:
                    const PageScrollPhysics(parent: BouncingScrollPhysics()),
                child: SizedBox(
                  height: maxWidth(context),
                  width: maxWidth(context),
                  child: PageView(
                    children: List.generate(
                      model.images.length,
                      (index) => CachedNetworkImage(
                        imageUrl: model.images[index],
                        height: maxWidth(context),
                        width: maxWidth(context),
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, str, value) {
                          print(value.progress);
                          return Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              value: value.progress,
                            ),
                          );
                        },
                      ),
                    ),
                    onPageChanged: (page) => store.imageIndex = page + 1,
                  ),
                ),
              ),
            ),
            Container(
              width: maxWidth(context),
              padding: EdgeInsets.symmetric(horizontal: wXD(18.5, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: wXD(300, context),
                            child: Text(
                              model.title,
                              style: textFamily(
                                context,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: getColors(context).onBackground,
                              ),
                            ),
                          ),
                          SizedBox(height: wXD(3, context)),
                          FutureBuilder<Map<String, dynamic>>(
                              future: store.getAverageRating(model.id),
                              builder: (context, snapshotAverageRating) {
                                num lengthRating = 0;
                                num averageRating = 0;
                                if (snapshotAverageRating.hasData) {
                                  Map<String, dynamic> response =
                                      snapshotAverageRating.data!;
                                  lengthRating = response['length-rating'];
                                  averageRating = response['average-rating'];
                                }
                                return Row(
                                  children: [
                                    SizedBox(width: wXD(6, context)),
                                    RatingBar(
                                      initialRating: averageRating.toDouble(),
                                      ignoreGestures: true,
                                      onRatingUpdate: (value) {},
                                      glowColor: getColors(context)
                                          .primary
                                          .withOpacity(.4),
                                      unratedColor: getColors(context)
                                          .primary
                                          .withOpacity(.4),
                                      allowHalfRating: true,
                                      itemSize: wXD(15, context),
                                      ratingWidget: RatingWidget(
                                        full: Icon(Icons.star_rounded,
                                            color: getColors(context).primary),
                                        empty: Icon(Icons.star_outline_rounded,
                                            color: getColors(context).primary),
                                        half: Icon(Icons.star_half_rounded,
                                            color: getColors(context).primary),
                                      ),
                                    ),
                                    SizedBox(width: wXD(14, context)),
                                    Text(
                                      '(${averageRating.toDouble()})',
                                      style: textFamily(
                                        context,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: getColors(context).primary,
                                      ),
                                    ),
                                  ],
                                );
                              })
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          FloatingCircleButton(
                            onTap: () {},
                            size: wXD(29, context),
                            color: getColors(context).surface,
                            child: Padding(
                              padding: EdgeInsets.only(top: wXD(2, context)),
                              child: Icon(
                                Icons.favorite,
                                size: wXD(23, context),
                                color: getColors(context).primary,
                              ),
                            ),
                          ),
                          Text(
                            '${model.likeCount}',
                            style: textFamily(
                              context,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: getColors(context).primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: wXD(22, context)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: wXD(50, context),
                        child: Container(
                          margin: EdgeInsets.only(left: wXD(6, context)),
                          height: wXD(21, context),
                          width: wXD(44, context),
                          decoration: BoxDecoration(
                              color: getColors(context).surface.withOpacity(.4),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3))),
                          alignment: Alignment.center,
                          child: Text(
                            '${store.imageIndex} / ${model.images.length}',
                            style: textFamily(
                              context,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: getColors(context).primary,
                            ),
                          ),
                        ),
                      ),
                      // Container(
                      //   height: maxWidth(context),
                      //   width: wXD(50, context),
                      //   alignment: Alignment.bottomRight,
                      //   child: FloatingCircleButton(
                      //     onTap: () {
                      //       store.share();
                      //     },
                      //     size: wXD(29, context),
                      //     color: getColors(context).surface,
                      //     child: Padding(
                      //       padding: EdgeInsets.only(
                      //           top: wXD(2, context), right: wXD(2, context)),
                      //       child: Icon(
                      //         Icons.share_outlined,
                      //         size: wXD(23, context),
                      //         color: getColors(context).primary,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(
                    width: wXD(317, context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'R\$ ${formatedCurrency(model.totalPrice)}  ',
                              style: textFamily(
                                context,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: getColors(context).primary,
                              ),
                            ),
                            model.oldPrice != null
                                ? model.oldPrice! > model.totalPrice
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            bottom: wXD(3, context)),
                                        child: Text(
                                          '${getPercentOff()}% OFF',
                                          style: textFamily(
                                            context,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: green,
                                          ),
                                        ),
                                      )
                                    : Container()
                                : Container(),
                          ],
                        ),
                        // Text(
                        //   'em 10 x R\$ ${formatedCurrency(model.sellerPrice / 10)} sem juros ',
                        //   style: textFamily(context,
                        //     fontSize: 13,
                        //     fontWeight: FontWeight.w500,
                        //     color: green,
                        //   ),
                        // ),
                        // Option(title: 'Cor', options: ['Preto']),
                        // Option(title: 'Quantidade', options: ['1'], qtd: true),
                        // Option(
                        //   title: 'Armazenamento',
                        //   options: [
                        //     '32 Gb',
                        //     '64 Gb',
                        //     '128 Gb',
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String getPercentOff() {
    int percent = (model.totalPrice / model.oldPrice! * 100).toInt();
    return percent.toString();
  }
}
