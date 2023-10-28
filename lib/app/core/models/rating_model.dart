import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  Timestamp? createdAt;
  // double? productRating;
  // double? sellerRating;
  // double? deliveryRating;
  // String? productOpnion;
  // String? productAnswer;
  // String? sellerAnswer;
  // String? sellerOpnion;
  // String? deliveryOpnion;
  // String? deliveryAnswer;
  // String? sellerId;
  String? status;
  String? id;
  String? orderId;
  bool? answered;
  // int? scorefyRating;
  // String? agentId;

  //novas 
  String? answer;
  String? evaluatedCollection;
  String? evaluatedId;
  String? opnion;
  num? rating;

  RatingModel({
    // this.productAnswer,
    // this.sellerAnswer,
    // this.deliveryAnswer,
    this.answered,
    this.createdAt,
    // this.deliveryOpnion,
    // this.deliveryRating,
    this.id,
    this.orderId,
    // this.productOpnion,
    // this.productRating,
    // this.scorefyRating,
    // this.sellerId,
    // this.sellerOpnion,
    // this.sellerRating,
    this.status,
    // this.agentId,
    // novas
    this.answer,
    this.evaluatedCollection,
    this.evaluatedId,
    this.opnion,
    this.rating,
  });

  factory RatingModel.fromDocSnapshot(DocumentSnapshot doc) => RatingModel(
        createdAt: doc['created_at'],
        // deliveryOpnion: doc['delivery_opnion'],
        // deliveryRating: doc['delivery_rating'].toDouble(),
        id: doc['id'],
        // productOpnion: doc['product_opnion'],
        // productRating: doc['product_rating'].toDouble(),
        // scorefyRating: doc['scorefy_rating'],
        // sellerId: doc['seller_id'],
        // sellerOpnion: doc['seller_opnion'],
        // sellerRating: doc['seller_rating'].toDouble(),
        status: doc['status'],
        orderId: doc['order_id'],
        answered: doc['answered'],
        // deliveryAnswer: doc['delivery_answer'],
        // sellerAnswer: doc['seller_answer'],
        // productAnswer: doc['product_answer'],
        // agentId: doc['agent_id'],

        answer: doc['answer'],
        evaluatedCollection: doc['evaluated_collection'],
        evaluatedId: doc['evaluated_id'],
        rating: doc['rating'],
        opnion: doc['opnion'],
      );

  Map<String, dynamic> toJson({RatingModel? model}) => model != null
      ? {
          "created_at": model.createdAt,
          // "delivery_opnion": model.deliveryOpnion,
          // "delivery_rating": model.deliveryRating,
          "id": model.id,
          // "product_opnion": model.productOpnion,
          // "product_rating": model.productRating,
          // "scorefy_rating": model.scorefyRating,
          // "seller_id": model.sellerId,
          // "seller_opnion": model.sellerOpnion,
          // "seller_rating": model.sellerRating,
          "status": model.status,
          "order_id": model.orderId,
          "answered": model.answered,
          // "product_answer": model.productAnswer,
          // "seller_answer": model.sellerAnswer,
          // "delivery_answer": model.deliveryAnswer,
          // "agent_id": model.agentId,
          "answer": model.answer,
          "evaluated_collection": model.evaluatedCollection,
          "evaluated_id": model.evaluatedId,
          "opnion": model.opnion,
          "rating": model.rating,
        }
      : {
          "created_at": createdAt,
          // "delivery_opnion": deliveryOpnion,
          // "delivery_rating": deliveryRating,
          "id": id,
          // "product_opnion": productOpnion,
          // "product_rating": productRating,
          // "scorefy_rating": scorefyRating,
          // "seller_id": sellerId,
          // "seller_opnion": sellerOpnion,
          // "seller_rating": sellerRating,
          "status": status,
          "order_id": orderId,
          "answered": answered,
          // "product_answer": productAnswer,
          // "seller_answer": sellerAnswer,
          // "delivery_answer": deliveryAnswer,
          // "agent_id": agentId,
          "answer": answer,
          "evaluatedCollection": evaluatedCollection,
          "evaluatedId": evaluatedId,
          "opnion": opnion,
          "rating": rating,
        };
}
