import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/load_circular_overlay.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../core/models/category_model.dart';

part 'categories_store.g.dart';

class CategoriesStore = _CategoriesStoreBase with _$CategoriesStore;

abstract class _CategoriesStoreBase with Store {
  Future<void> createCategorie(
      context, String txt, String collectionPath) async {
    OverlayEntry loadOverlay;

    loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());

    Overlay.of(context)!.insert(loadOverlay);

    CollectionReference colRef =
        FirebaseFirestore.instance.collection(collectionPath);

    DocumentReference docRef = colRef.doc();

    Map<String, dynamic> obj = Category(
      id: docRef.id,
      label: txt,
      status: "ACTIVE",
      createdAt: FieldValue.serverTimestamp(),
    ).toJson();

    if (collectionPath != "categories") {
      obj = Subcategory(
        createdAt: FieldValue.serverTimestamp(),
        id: docRef.id,
        label: txt,
        status: "ACTIVE",
        collectionPath: collectionPath,
      ).toJson();
    }

    await docRef.set(obj);

    loadOverlay.remove();
  }

  Future<void> editCategory(Category category) async {
    await FirebaseFirestore.instance
        .collection("categories")
        .doc(category.id)
        .update({"label": category.label});
  }

  Future<void> deleteCategory(Category category) async =>
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(category.id)
          .update({"status": "DELETED"});

  Future<void> editSubcategory(Subcategory subcategory) async {
    await FirebaseFirestore.instance
        .collection(subcategory.collectionPath)
        .doc(subcategory.id)
        .update({"label": subcategory.label});
  }

  Future<void> deleteSubCategory(Subcategory subcategory) async =>
      await FirebaseFirestore.instance
          .collection(subcategory.collectionPath)
          .doc(subcategory.id)
          .update({"status": "DELETED"});
}
