import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/core/models/category_model.dart';
import 'package:delivery_seller_white_label/app/modules/categories/categories_store.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/emtpy_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../shared/widgets/floating_circle_button.dart';
import 'add_category_popup.dart';
import 'edit_overlay.dart';

class SubcategoriesPage extends StatefulWidget {
  final String category;
  final String collectionPath;

  SubcategoriesPage(this.category, this.collectionPath, {Key? key})
      : super(key: key);

  @override
  State<SubcategoriesPage> createState() => _SubcategoriesPageState();
}

class _SubcategoriesPageState
    extends ModularState<SubcategoriesPage, CategoriesStore> {
  OverlayEntry? createCategoryOverlay;

  bool showAdd = true;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      // print(
      //     "scrollController.position.userScrollDirection: ${scrollController.position.userScrollDirection}");
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          showAdd) {
        setState(() {
          showAdd = false;
        });
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          !showAdd) {
        setState(() {
          showAdd = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("collectionPath: ${widget.collectionPath}");
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: maxHeight(context),
            width: maxWidth(context),
            child: Column(
              children: [
                SizedBox(height: viewPaddingTop(context) + wXD(60, context)),
                // Container(
                //   // height: wXD(50, context),
                //   width: maxWidth(context),
                //   child: Row(
                //     children: [
                //       Padding(
                //         padding: EdgeInsets.only(
                //           left: wXD(15, context),
                //           right: wXD(20, context),
                //         ),
                //         child: Text("Adicionar\nsubcategoria:"),
                //       ),
                //       Flexible(
                //         child: Form(
                //           key: _formKey,
                //           child: TextFormField(
                //             controller: textController,
                //             autovalidateMode:
                //                 AutovalidateMode.onUserInteraction,
                //             decoration:
                //                 InputDecoration(hintText: "Subcategoria"),
                //             validator: (txt) {
                //               if (txt == null || txt.isEmpty) {
                //                 return "Preencha corretamente";
                //               }
                //               return null;
                //             },
                //           ),
                //         ),
                //       ),
                //       IconButton(
                //         onPressed: () async {
                //           if (_formKey.currentState!.validate()) {
                //             String txt = textController.text;
                //             textController.clear();
                //             store.createSubcategory(
                //               Subcategory(
                //                 id: "",
                //                 label: txt,
                //                 status: "ACTIVE",
                //                 categoryId: widget.category.id,
                //               ),
                //             );
                //           }
                //         },
                //         icon: Icon(
                //           Icons.add_box_rounded,
                //           color: getColors(context).primary,
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                Expanded(
                  child: Listener(
                    onPointerDown: (event) =>
                        FocusScope.of(context).requestFocus(),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection(widget.collectionPath)
                          .where("status", isEqualTo: "ACTIVE")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CenterLoadCircular();
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return EmptyState(
                            text: "Sem subcategorias",
                            icon: Icons.category_outlined,
                          );
                        }
                        return SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          controller: scrollController,
                          child: Column(
                            children: List.generate(
                              snapshot.data!.docs.length,
                              (index) {
                                final doc = snapshot.data!.docs[index];
                                return SubcategoryTile(
                                    subcategory: Subcategory.fromDoc(doc));
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
          DefaultAppBar(widget.category),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
            right: showAdd ? wXD(15, context) : -wXD(70, context),
            bottom: wXD(40, context),
            child: FloatingCircleButton(
              icon: Icons.add_rounded,
              size: wXD(60, context),
              iconColor: getColors(context).primary,
              onTap: () {
                createCategoryOverlay = OverlayEntry(
                  builder: (context) => AddCategoryPopup(
                    label: "Preencha com a subcategoria desejada",
                    onBack: () {
                      createCategoryOverlay!.remove();
                      createCategoryOverlay = null;
                    },
                    onSave: (txt) async => await store.createCategorie(
                      context,
                      txt,
                      widget.collectionPath,
                    ),
                  ),
                );
                Overlay.of(context)!.insert(createCategoryOverlay!);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SubcategoryTile extends StatefulWidget {
  final Subcategory subcategory;

  SubcategoryTile({
    Key? key,
    required this.subcategory,
  }) : super(key: key);

  @override
  State<SubcategoryTile> createState() => _SubcategoryTileState();
}

class _SubcategoryTileState extends State<SubcategoryTile> {
  final CategoriesStore store = Modular.get();

  final TextEditingController textController = TextEditingController();

  late OverlayEntry editCategoryOverlay;

  bool editing = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  getEditSubCategory() {
    editCategoryOverlay = OverlayEntry(
      builder: (context) => EditCategoryOverlay(
        category: widget.subcategory,
        onBack: () => editCategoryOverlay.remove(),
        onDelete: () {
          store.deleteSubCategory(widget.subcategory);
          editCategoryOverlay.remove();
        },
        onEdit: () {
          setState(() {
            textController.text = widget.subcategory.label;
            editing = true;
          });
          editCategoryOverlay.remove();
        },
        onCategories: () {
          editCategoryOverlay.remove();
          Modular.to.pushNamed(
            "/categories/subcategories/",
            arguments: {
              "category": widget.subcategory.label,
              "collectionPath":
                  "${widget.subcategory.collectionPath}/${widget.subcategory.id}/subcategories"
            },
          );
        },
      ),
    );
    Overlay.of(context)?.insert(editCategoryOverlay);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        getEditSubCategory();
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
                        hintText: widget.subcategory.label,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      store.editSubcategory(
                        Subcategory(
                          id: widget.subcategory.id,
                          label: textController.text,
                          status: widget.subcategory.status,
                          collectionPath: widget.subcategory.collectionPath,
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
            : Text(widget.subcategory.label),
      ),
    );
  }
}

// class EditOverlay extends StatefulWidget {
//   final Subcategory subcategory;
//   final void Function() onBack;
//   final void Function() onDelete;
//   final void Function() onEdit;
//   EditOverlay({
//     Key? key,
//     required this.subcategory,
//     required this.onBack,
//     required this.onDelete,
//     required this.onEdit,
//   }) : super(key: key);

//   @override
//   State<EditOverlay> createState() => _EditOverlayState();
// }

// class _EditOverlayState extends State<EditOverlay>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this);
//     _controller.animateTo(1,
//         duration: Duration(milliseconds: 400), curve: Curves.easeOutQuint);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         // print("_controller.value: ${_controller.value}");
//         return Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             BackdropFilter(
//               filter: ImageFilter.blur(
//                 sigmaX: _controller.value,
//                 sigmaY: _controller.value,
//               ),
//               child: GestureDetector(
//                 onTap: () async {
//                   await _controller.animateBack(0,
//                       duration: Duration(milliseconds: 400),
//                       curve: Curves.easeOutQuint);
//                   widget.onBack();
//                 },
//                 child: Container(
//                   height: maxHeight(context),
//                   width: maxWidth(context),
//                   color: getColors(context).shadow,
//                 ),
//               ),
//             ),
//             Positioned(
//               top: maxHeight(context) - (wXD(164, context) * _controller.value),
//               child: Container(
//                 width: maxWidth(context),
//                 height: wXD(164, context),
//                 decoration: BoxDecoration(
//                   color: getColors(context).surface,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
//                   boxShadow: [
//                     BoxShadow(
//                       blurRadius: 8,
//                       offset: Offset(0, -5),
//                       color: Color(0x70000000),
//                     ),
//                   ],
//                 ),
//                 alignment: Alignment.center,
//                 child: Material(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
//                   color: getColors(context).surface,
//                   child: Column(
//                     children: [
//                       SizedBox(height: wXD(16, context)),
//                       Container(
//                         width: wXD(300, context),
//                         alignment: Alignment.center,
//                         child: Text(
//                           widget.subcategory.label,
//                           textAlign: TextAlign.center,
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                           style: textFamily(
//                             context,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 18,
//                             color: getColors(context).onBackground,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: wXD(16, context)),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           WhiteButton(
//                             text: 'Excluir',
//                             icon: Icons.delete_outline,
//                             onTap: widget.onDelete,
//                           ),
//                           WhiteButton(
//                             text: 'Editar',
//                             icon: Icons.edit_outlined,
//                             onTap: widget.onEdit,
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: wXD(13, context)),
//                       InkWell(
//                         onTap: widget.onBack,
//                         child: Text(
//                           'Cancelar',
//                           style: textFamily(context,
//                               fontWeight: FontWeight.w500,
//                               color: getColors(context).error),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//     );
//   }
// }
