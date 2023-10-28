import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  dynamic createdAt;
  String id;
  String label;
  String status;

  Category({
    this.createdAt,
    required this.id,
    required this.label,
    required this.status,
  });

  factory Category.fromDoc(DocumentSnapshot doc) => Category(
        id: doc.id,
        label: doc.get("label"),
        status: doc.get("status"),
        createdAt: doc.get("created_at"),
      );

  Map<String, dynamic> toJson() => {
        "created_at": this.createdAt,
        "id": this.id,
        "label": this.label,
        "status": this.status,
      };
}

class Subcategory extends Category {
  final String collectionPath;

  Subcategory({
    required this.collectionPath,
    required String id,
    required String label,
    required String status,
    dynamic createdAt,
  }) : super(
          id: id,
          label: label,
          status: status,
          createdAt: createdAt,
        );

  factory Subcategory.fromDoc(DocumentSnapshot doc) => Subcategory(
        id: doc.id,
        label: doc.get("label"),
        status: doc.get("status"),
        createdAt: doc.get("created_at"),
        collectionPath: doc.get("collection_path"),
      );

  Map<String, dynamic> toJson() => {
        "created_at": this.createdAt,
        "id": this.id,
        "label": this.label,
        "status": this.status,
        "collection_path": this.collectionPath,
      };
}
