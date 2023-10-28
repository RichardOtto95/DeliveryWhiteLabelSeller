import 'package:cloud_firestore/cloud_firestore.dart';

class Type {
  final dynamic createdAt;
  final String type;
  final String id;
  final String status;

  Type({
    this.createdAt,
    required this.type,
    required this.id,
    required this.status,
  });

  factory Type.fromDoc(DocumentSnapshot doc) => Type(
        type: doc.get("type"),
        id: doc.get("id"),
        status: doc.get("status"),
        createdAt: doc.get("created_at"),
      );

  Map<String, dynamic> toJson() => {
        "type": this.type,
        "id": this.id,
        "status": this.status,
        "created_at": this.createdAt,
      };
}
