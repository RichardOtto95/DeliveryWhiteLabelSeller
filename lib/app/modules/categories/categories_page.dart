import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/core/models/category_model.dart';
import 'package:delivery_seller_white_label/app/modules/categories/categories_store.dart';
import 'package:delivery_seller_white_label/app/modules/categories/widgets/add_category_popup.dart';
import 'package:delivery_seller_white_label/app/shared/custom_scroll_behavior.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/emtpy_state.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/floating_circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'widgets/edit_overlay.dart';

class CategoriesPage extends StatefulWidget {
  CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState
    extends ModularState<CategoriesPage, CategoriesStore> {
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
    scrollController.dispose();
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
                //         child: Text("Adicionar\ncategoria:"),
                //       ),
                //       Flexible(
                //         child: Form(
                //           key: _formKey,
                //           child: TextFormField(
                //             controller: textController,
                //             autovalidateMode:
                //                 AutovalidateMode.onUserInteraction,
                //             decoration: InputDecoration(hintText: "Categoria"),
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
                //             store.createCategorie(txt);
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
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("categories")
                        .where("status", isEqualTo: "ACTIVE")
                        .orderBy("label")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CenterLoadCircular();
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return EmptyState(
                          text: "Sem categorias ainda",
                          icon: Icons.category_outlined,
                        );
                      }
                      return ScrollConfiguration(
                        behavior: CustomScrollBehavior(),
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          controller: scrollController,
                          child: Column(
                            children: List.generate(
                              snapshot.data!.docs.length,
                              (index) {
                                final doc = snapshot.data!.docs[index];
                                return CategorieTile(
                                    category: Category.fromDoc(doc));
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          DefaultAppBar("Categorias"),
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
                    onBack: () {
                      createCategoryOverlay!.remove();
                      createCategoryOverlay = null;
                    },
                    onSave: (txt) async =>
                        await store.createCategorie(context, txt, "categories"),
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

class CategorieTile extends StatefulWidget {
  final Category category;

  CategorieTile({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CategorieTile> createState() => _CategorieTileState();
}

class _CategorieTileState extends State<CategorieTile> {
  final CategoriesStore store = Modular.get();

  final TextEditingController textController = TextEditingController();

  late OverlayEntry editCategoryOverlay;

  bool editing = false;

  getEditCategory() {
    editCategoryOverlay = OverlayEntry(
      builder: (context) => EditCategoryOverlay(
        category: widget.category,
        onBack: () => editCategoryOverlay.remove(),
        onDelete: () {
          store.deleteCategory(widget.category);
          editCategoryOverlay.remove();
        },
        onEdit: () {
          setState(() {
            textController.text = widget.category.label;
            editing = true;
          });
          editCategoryOverlay.remove();
        },
        onCategories: () {
          editCategoryOverlay.remove();
          Modular.to.pushNamed(
            "/categories/subcategories/",
            arguments: {
              "category": widget.category.label,
              "collectionPath": "categories/${widget.category.id}/subcategories"
            },
          );
        },
      ),
    );
    Overlay.of(context)?.insert(editCategoryOverlay);
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
        getEditCategory();
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: textController,
                      decoration: InputDecoration.collapsed(
                        hintText: widget.category.label,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      store.editCategory(
                        Category(
                          id: widget.category.id,
                          label: textController.text,
                          status: widget.category.status,
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
            : Text(widget.category.label),
      ),
    );
  }
}
