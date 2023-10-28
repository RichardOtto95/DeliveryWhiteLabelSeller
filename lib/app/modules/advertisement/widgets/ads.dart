import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_seller_white_label/app/core/models/ads_model.dart';
import 'package:delivery_seller_white_label/app/modules/advertisement/advertisement_store.dart';
import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/confirm_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class Ads extends StatefulWidget {
  final AdsModel ad;
  final String image;
  Ads({
    Key? key,
    required this.ad,
    required this.image,
  }) : super(key: key);

  @override
  _AdsState createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  final MainStore mainStore = Modular.get();
  final AdvertisementStore store = Modular.get();
  OverlayEntry? confirmPauseOverlay;
  LayerLink _layerLink = LayerLink();

  OverlayEntry getOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        height: wXD(140, context),
        width: wXD(130, context),
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(wXD(-115, context), wXD(21, context)),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(left: wXD(12, context)),
              height: wXD(140, context),
              width: wXD(130, context),
              decoration: BoxDecoration(
                color: getColors(context).surface,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    offset: Offset.zero,
                    color: getColors(context).shadow,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        mainStore.menuOverlay!.remove();
                        mainStore.menuOverlay = null;
                        print('onTap: ${widget.ad.toJson()}');
                        // mainStore.setAdsId(widget.ad.id);
                        mainStore.adsId = widget.ad.id;

                        print('onTap: ${mainStore.adsId}');
                        await Modular.to.pushNamed('/product');
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              size: wXD(18, context),
                              color: getColors(context).primary,
                            ),
                            Text(
                              '  Visualizar',
                              style: textFamily(
                                context,
                                color: getColors(context).primary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        store.setAdEdit(widget.ad);
                        store.getFinalPrice(widget.ad.totalPrice);
                        store.setEditingAd(true);
                        if (mainStore.menuOverlay != null &&
                            mainStore.menuOverlay!.mounted) {
                          mainStore.menuOverlay!.remove();
                          mainStore.menuOverlay = null;
                        }
                        await Modular.to.pushNamed('/advertisement/create-ads');
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: wXD(18, context),
                              color: getColors(context).primary,
                            ),
                            Text(
                              '  Editar',
                              style: textFamily(
                                context,
                                color: getColors(context).primary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        confirmPauseOverlay = OverlayEntry(
                          builder: (context) => ConfirmPopup(
                            height: wXD(150, context),
                            text: widget.ad.paused
                                ? "Tem certeza que deseja despausar esta publicação?"
                                : 'Tem certeza que deseja pausar esta publicação?',
                            onConfirm: () async {
                              await store.pauseAds(
                                  adsId: widget.ad.id,
                                  pause: !widget.ad.paused,
                                  context: context);
                              confirmPauseOverlay!.remove();
                              confirmPauseOverlay = null;
                              mainStore.menuOverlay!.remove();
                              mainStore.menuOverlay = null;
                            },
                            onCancel: () {
                              confirmPauseOverlay!.remove();
                              confirmPauseOverlay = null;
                              mainStore.menuOverlay!.remove();
                              mainStore.menuOverlay = null;
                            },
                          ),
                        );
                        Overlay.of(context)!.insert(confirmPauseOverlay!);
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Icon(
                              widget.ad.paused
                                  ? Icons.play_arrow_rounded
                                  : Icons.pause,
                              size: wXD(18, context),
                              color: getColors(context).primary,
                            ),
                            Text(
                              widget.ad.paused ? 'Despausar' : '  Pausar',
                              style: textFamily(
                                context,
                                color: getColors(context).primary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        mainStore.removeMenuOverlay();
                        mainStore.paginateEnable = false;
                        mainStore.setVisibleNav(false);
                        // store.callDelete(ad: widget.ad);
                        confirmPauseOverlay =
                            // OverlayEntry(
                            //   builder: (context) => ConfirmPopup(
                            //     height: wXD(150, context),
                            //     text:
                            //         'Tem certeza que deseja excluir esta publicação?',
                            //     onConfirm: () async {
                            //       store.adDelete = widget.ad;
                            //       await store.deleteAds(context: context);
                            //       confirmPauseOverlay!.remove();
                            //       confirmPauseOverlay = null;
                            //     },
                            //     onCancel: () {
                            //       confirmPauseOverlay!.remove();
                            //       confirmPauseOverlay = null;
                            //     },
                            //   ),
                            // );
                            OverlayEntry(
                          builder: (context) => ConfirmPopup(
                            height: wXD(150, context),
                            text:
                                'Tem certeza que deseja excluir esta publicação?',
                            onConfirm: () async {
                              store.adDelete = widget.ad;
                              await store.deleteAds(context: context);
                              confirmPauseOverlay!.remove();
                              confirmPauseOverlay = null;
                              if (mainStore.menuOverlay != null) {
                                mainStore.menuOverlay!.remove();
                                mainStore.menuOverlay = null;
                              }
                              mainStore.paginateEnable = true;
                              mainStore.setVisibleNav(true);
                            },
                            onCancel: () {
                              confirmPauseOverlay!.remove();
                              confirmPauseOverlay = null;
                              if (mainStore.menuOverlay != null) {
                                mainStore.menuOverlay!.remove();
                                mainStore.menuOverlay = null;
                              }
                              mainStore.paginateEnable = true;
                              mainStore.setVisibleNav(true);
                            },
                          ),
                        );
                        Overlay.of(context)!.insert(confirmPauseOverlay!);
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: wXD(18, context),
                              color: getColors(context).primary,
                            ),
                            Text(
                              '  Excluir',
                              style: textFamily(
                                context,
                                color: getColors(context).primary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            height: wXD(140, context),
            width: wXD(352, context),
            margin: EdgeInsets.only(bottom: wXD(12, context)),
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
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    mainStore.adsId = widget.ad.id;
                    print("ads: ${widget.ad.toJson()}");
                    await Modular.to.pushNamed('/product');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: getColors(context).onBackground.withOpacity(.2),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.only(bottom: wXD(7, context)),
                    margin: EdgeInsets.fromLTRB(
                      wXD(19, context),
                      wXD(17, context),
                      wXD(6, context),
                      wXD(0, context),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          child: widget.image == ''
                              ? Image.asset(
                                  'assets/images/no-image-icon.png',
                                  height: wXD(65, context),
                                  width: wXD(62, context),
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  progressIndicatorBuilder:
                                      (context, url, progress) =>
                                          CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        getColors(context).primary),
                                  ),
                                  imageUrl: widget.image,
                                  height: wXD(65, context),
                                  width: wXD(62, context),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: wXD(8, context)),
                          width: wXD(248, context),
                          height: wXD(70, context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // SizedBox(height: wXD(3, context)),
                              Text(
                                widget.ad.title,
                                style: textFamily(context,
                                    color: getColors(context).onBackground),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: wXD(3, context)),
                              Text(
                                widget.ad.description,
                                style: textFamily(context,
                                    color: getColors(context).onSurface),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // SizedBox(height: wXD(3, context)),
                              Spacer(),
                              Text(
                                'R\$ ${formatedCurrency(widget.ad.totalPrice)}',
                                style: textFamily(context,
                                    color: getColors(context).primary),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                widget.ad.paused
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pause,
                            size: wXD(30, context),
                            color: getColors(context).primary,
                          ),
                          Text(
                            '  Anúncio pausado',
                            style: textFamily(
                              context,
                              fontSize: 18,
                              color: getColors(context).primary,
                            ),
                          ),
                        ],
                      )
                    : widget.ad.highlighted
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                size: wXD(30, context),
                                color: getColors(context).primary,
                              ),
                              Text(
                                '  Anúncio destacado',
                                style: textFamily(
                                  context,
                                  fontSize: 18,
                                  color: getColors(context).primary,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(left: wXD(20, context)),
                                child: Text(
                                  widget.ad.status == "UNDER-ANALYSIS"
                                      ? 'Esperando aprovação do anúncio'
                                      : "Anúncio publicado",
                                  style: textFamily(
                                    context,
                                    color: getColors(context)
                                        .onBackground
                                        .withOpacity(.7),
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Padding(
                              //   padding:
                              //       EdgeInsets.only(left: wXD(20, context)),
                              //   child: Text(
                              //     'Destaque e venda mais rápido',
                              //     style: textFamily(context,
                              //       color: getColors(context).onBackground.withOpacity(.7),
                              //       fontSize: 12,
                              //     ),
                              //     maxLines: 2,
                              //     overflow: TextOverflow.ellipsis,
                              //   ),
                              // ),
                              // GestureDetector(
                              //   onTap: () {
                              //     confirmPauseOverlay = OverlayEntry(
                              //       builder: (context) => ConfirmPopup(
                              //         height: wXD(140, context),
                              //         text:
                              //             'Tem certeza que deseja destacar esta publicação?',
                              //         onConfirm: () async {
                              //           await store.highlightAd(
                              //               adsId: widget.ad.id,
                              //               context: context);
                              //           confirmPauseOverlay!.remove();
                              //           confirmPauseOverlay = null;
                              //         },
                              //         onCancel: () {
                              //           confirmPauseOverlay!.remove();
                              //           confirmPauseOverlay = null;
                              //         },
                              //       ),
                              //     );
                              //     Overlay.of(context)!
                              //         .insert(confirmPauseOverlay!);
                              //   },
                              //   child: Container(
                              //     margin:
                              //         EdgeInsets.only(right: wXD(6, context)),
                              //     height: wXD(32, context),
                              //     width: wXD(87, context),
                              //     decoration: BoxDecoration(
                              //       color: getColors(context).primary,
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(3)),
                              //       boxShadow: [
                              //         BoxShadow(
                              //           blurRadius: 3,
                              //           offset: Offset(0, 3),
                              //           color: getColors(context).shadow,
                              //         ),
                              //       ],
                              //     ),
                              //     alignment: Alignment.center,
                              //     child: Text(
                              //       'Destacar',
                              //       style: textFamily(context,
                              //         fontSize: 12,
                              //         color: getColors(context).surface,
                              //       ),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                Spacer(),
              ],
            ),
          ),
          Positioned(
            top: wXD(0, context),
            right: wXD(0, context),
            child: CompositedTransformTarget(
              link: _layerLink,
              child: IconButton(
                onPressed: () {
                  // print('gerOverlayEntry: ${getOverlayEntry()}');
                  mainStore.setMenuOverlay(getOverlayEntry(), context);
                },
                icon: Icon(
                  Icons.more_vert,
                  size: wXD(20, context),
                  color: getColors(context).primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
