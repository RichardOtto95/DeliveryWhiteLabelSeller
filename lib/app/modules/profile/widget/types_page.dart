import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/core/models/type_model.dart';
import 'package:delivery_seller_white_label/app/modules/profile/profile_store.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/emtpy_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../shared/widgets/white_button.dart';

class TypesPage extends StatefulWidget {
  TypesPage({Key? key}) : super(key: key);

  @override
  State<TypesPage> createState() => _TypesPageState();
}

class _TypesPageState extends State<TypesPage> {
  final ProfileStore store = Modular.get();
  final TextEditingController textController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: maxHeight(context),
            width: maxWidth(context),
            child: Column(
              children: [
                SizedBox(height: viewPaddingTop(context) + wXD(60, context)),
                Container(
                  // height: wXD(50, context),
                  width: maxWidth(context),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: wXD(15, context),
                          right: wXD(20, context),
                        ),
                        child: Text("Adicionar\ntipo:"),
                      ),
                      Flexible(
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: textController,
                            decoration: InputDecoration(hintText: "Tipo"),
                            validator: (txt) {
                              if (txt == null || txt.isEmpty) {
                                return "Preencha corretamente";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: textController,
                            decoration: InputDecoration(hintText: "Tipo"),
                            validator: (txt) {
                              if (txt == null || txt.isEmpty) {
                                return "Preencha corretamente";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String txt = textController.text;
                            textController.clear();
                            store.createType(txt);
                          }
                        },
                        icon: Icon(
                          Icons.add_box_rounded,
                          color: getColors(context).primary,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Listener(
                    onPointerDown: (event) =>
                        FocusScope.of(context).requestFocus(),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("types")
                          .where("status", isEqualTo: "ACTIVE")
                          .orderBy("type")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CenterLoadCircular();
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return EmptyState(
                            text: "Sem tipos ainda",
                            icon: Icons.branding_watermark_outlined,
                          );
                        }
                        return SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              snapshot.data!.docs.length,
                              (index) {
                                final doc = snapshot.data!.docs[index];
                                return TypeTile(type: Type.fromDoc(doc));
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
          DefaultAppBar("Tipos"),
        ],
      ),
    );
  }
}

class TypeTile extends StatefulWidget {
  final Type type;

  TypeTile({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<TypeTile> createState() => _TypeTileState();
}

class _TypeTileState extends State<TypeTile> {
  final ProfileStore store = Modular.get();
  final TextEditingController textController = TextEditingController();
  bool editing = false;

  getEditType() {
    store.editTypeOverlay = OverlayEntry(
      builder: (context) => EditOverlay(
        type: widget.type,
        onBack: () => store.editTypeOverlay!.remove(),
        onDelete: () {
          store.deleteType(widget.type);
          store.editTypeOverlay!.remove();
        },
        onEdit: () {
          setState(() {
            textController.text = widget.type.type;
            editing = true;
          });
          store.editTypeOverlay!.remove();
        },
      ),
    );
    Overlay.of(context)?.insert(store.editTypeOverlay!);
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
          horizontal: editing ? wXD(15, context) : wXD(30, context),
          vertical: editing ? wXD(5, context) : wXD(15, context),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: wXD(10, context),
          vertical: wXD(7, context),
        ),
        child: editing
            ? Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() => editing = false),
                    icon: Icon(
                      Icons.close_rounded,
                      color: getColors(context).error,
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      autofocus: true,
                      controller: textController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration.collapsed(
                        hintText: widget.type.type,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      store.editType(
                        Type(
                          id: widget.type.id,
                          type: textController.text,
                          status: widget.type.status,
                        ),
                      );
                      setState(() => editing = false);
                    },
                    icon: Icon(
                      Icons.check_rounded,
                      color: getColors(context).primary,
                    ),
                  ),
                ],
              )
            : Text(widget.type.type),
      ),
    );
  }
}

class EditOverlay extends StatefulWidget {
  final Type type;
  final void Function() onBack;
  final void Function() onDelete;
  final void Function() onEdit;
  EditOverlay({
    Key? key,
    required this.type,
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
    _controller.animateTo(1,
        duration: Duration(milliseconds: 400), curve: Curves.easeOutQuint);
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
        // print("_controller.value: ${_controller.value}");
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _controller.value+0.001,
                sigmaY: _controller.value+0.001,
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
                  color: Colors.black.withOpacity(.3 * _controller.value),
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
                          widget.type.type,
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
                          WhiteButton(
                            text: 'Excluir',
                            icon: Icons.delete_outline,
                            onTap: widget.onDelete,
                          ),
                          SizedBox(width: wXD(21, context)),
                          WhiteButton(
                            text: 'Editar',
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
