import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/modules/profile/profile_store.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../core/models/additional_model.dart';
import '../../../shared/widgets/floating_circle_button.dart';
import '../../../shared/widgets/load_circular_overlay.dart';
import '../../../shared/widgets/white_button.dart';

class AdditionalPage extends StatefulWidget {
  AdditionalPage({Key? key}) : super(key: key);

  @override
  State<AdditionalPage> createState() => _AdditionalPageState();
}

class _AdditionalPageState extends State<AdditionalPage> {
  final ProfileStore store = Modular.get();
  final TextEditingController textController = TextEditingController();
  // final _formKey = GlobalKey<FormState>();
  final User _user = FirebaseAuth.instance.currentUser!;
  final ScrollController scrollController = ScrollController();
  bool visibleButton = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          !visibleButton) {
        setState(() {
          visibleButton = true;
        });
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          visibleButton) {
        setState(() {
          visibleButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (store.editAdditionalOverlay != null) {
          if (store.editAdditionalOverlay!.mounted) {
            store.editAdditionalOverlay!.remove();
            return false;
          }
        }
        if (store.additionalLoadOverlay != null) {
          if (store.additionalLoadOverlay!.mounted) {
            return false;
          }
        }

        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Listener(
              onPointerDown: (a) {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: SizedBox(
                height: maxHeight(context),
                width: maxWidth(context),
                child: Column(
                  children: [
                    SizedBox(height: viewPaddingTop(context) + wXD(60, context)),
                    Expanded(
                      child: Listener(
                        onPointerDown: (event) => FocusScope.of(context).requestFocus(),
                        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("sellers")
                              .doc(_user.uid)
                              .collection("additional")
                              .where("status", isEqualTo: "ACTIVE")
                              .orderBy("title")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CenterLoadCircular();
                            }
                            // if (snapshot.data!.docs.isEmpty) {
                            //   return EmptyState(
                            //     text: "Sem adicionais ainda",
                            //     icon: Icons.branding_watermark_outlined,
                            //   );
                            // }
                            QuerySnapshot additionalQuery = snapshot.data!;
                            // print('additionalQuery.docs.length: ${additionalQuery.docs.length}');
                            return SingleChildScrollView(
                              controller: scrollController,
                              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                              child: Column(
                                children: List.generate(
                                  additionalQuery.docs.length,
                                  (index) {
                                    DocumentSnapshot additionalDoc = additionalQuery.docs[index];
                                    return AdditionalTile(
                                      additionalModel: AdditionalModel.fromDoc(additionalDoc),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            DefaultAppBar("Seções"),
            AnimatedPositioned(
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
              bottom: wXD(80, context),
              right: visibleButton ? wXD(17, context) : wXD(-56, context),
              child: FloatingCircleButton(
                onTap: () {
                  Modular.to.pushNamed('/profile/create-additional');
                },
                size: wXD(56, context),
                child: Icon(
                  Icons.add,
                  size: wXD(30, context),
                  color: getColors(context).primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdditionalTile extends StatefulWidget {
  final AdditionalModel additionalModel;

  AdditionalTile({
    Key? key,
    required this.additionalModel,
  }) : super(key: key);

  @override
  State<AdditionalTile> createState() => _AdditionalTileState();
}

class _AdditionalTileState extends State<AdditionalTile> {
  final ProfileStore store = Modular.get();
  final TextEditingController textController = TextEditingController();

  getEditType() {
    store.editAdditionalOverlay = OverlayEntry(
      builder: (context) => EditOverlay(
        additionalModel: widget.additionalModel,
        onBack: () => store.editAdditionalOverlay!.remove(),
        onDelete: () async {
          store.additionalLoadOverlay =
              OverlayEntry(builder: (context) => LoadCircularOverlay());
          Overlay.of(context)!.insert(store.additionalLoadOverlay!);

          await store.deleteAdditional(widget.additionalModel.id);
          store.editAdditionalOverlay!.remove();
          store.additionalLoadOverlay!.remove();
          store.additionalLoadOverlay = null;
          store.editAdditionalOverlay = null;
        },
        onEdit: () {
          Modular.to.pushNamed('/profile/edit-additional',
              arguments: widget.additionalModel);
          store.editAdditionalOverlay!.remove();
          store.editAdditionalOverlay = null;
        },
      ),
    );
    Overlay.of(context)?.insert(store.editAdditionalOverlay!);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        getEditType();
      },
      child: Container(
        // duration: Duration(milliseconds: 300),
        width: maxWidth(context),
        height: wXD(50, context),
        padding: EdgeInsets.symmetric(
          horizontal: wXD(30, context),
          vertical: wXD(15, context),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: wXD(10, context),
          vertical: wXD(7, context),
        ),
        child: Row(
          children: [
            Icon(
              getIcon(),
              color: getColors(context).onBackground,
              size: wXD(22, context),
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.additionalModel.title),
          ],
        ),
      ),
    );
  }

  IconData getIcon() {
    IconData iconData;
    switch (widget.additionalModel.type) {
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

class EditOverlay extends StatefulWidget {
  final AdditionalModel additionalModel;
  final void Function() onBack;
  final void Function() onDelete;
  final void Function() onEdit;
  EditOverlay({
    Key? key,
    required this.additionalModel,
    required this.onBack,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<EditOverlay> createState() => _EditOverlayState();
}

class _EditOverlayState extends State<EditOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.animateTo(
      1,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOutQuint,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _controller.value + 0.001,
                sigmaY: _controller.value + 0.001,
              ),
              child: GestureDetector(
                onTap: () async {
                  await _controller.animateBack(0,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeOutQuint);
                  widget.onBack();
                },
                child: Container(
                  height: maxHeight(context),
                  width: maxWidth(context),
                  color: getColors(context).shadow,
                ),
              ),
            ),
            Positioned(
              top: maxHeight(context) - (wXD(164, context) * _controller.value),
              child: Container(
                width: maxWidth(context),
                height: wXD(164, context),
                decoration: BoxDecoration(
                  color: getColors(context).surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      offset: Offset(0, -5),
                      color: Color(0x70000000),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Material(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                  color: getColors(context).surface,
                  child: Column(
                    children: [
                      SizedBox(height: wXD(16, context)),
                      Container(
                        width: wXD(300, context),
                        alignment: Alignment.center,
                        child: Text(
                          widget.additionalModel.title,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: textFamily(
                            context,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: getColors(context).onBackground,
                          ),
                        ),
                      ),
                      SizedBox(height: wXD(16, context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          !widget.additionalModel.notEdit
                              ? Row(
                                  children: [
                                    WhiteButton(
                                      text: 'Excluir',
                                      icon: Icons.delete_outline,
                                      onTap: widget.onDelete,
                                    ),
                                    SizedBox(width: wXD(21, context)),
                                  ],
                                )
                              : Container(),
                          WhiteButton(
                            text: widget.additionalModel.notEdit ? "Visualizar" : 'Editar',
                            icon: Icons.edit_outlined,
                            onTap: widget.onEdit,
                          ),
                        ],
                      ),
                      SizedBox(height: wXD(13, context)),
                      InkWell(
                        onTap: widget.onBack,
                        child: Text(
                          'Cancelar',
                          style: textFamily(context,
                              fontWeight: FontWeight.w500,
                              color: getColors(context).error),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
