import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Order {
  int? totalAmount;
  num? priceRateDelivery;
  num? priceTotal;
  String? status;
  String? customerToken;
  String? agentToken;
  String? id;
  String? customerId;
  String? sellerId;
  String? agentId;
  String? agentStatus;
  String? discontinuedBy;
  String? userIdDiscontinued;
  String? discontinuedReason;
  String? customerAdderessId;
  String? sellerAdderessId;
  String? couponId;
  bool? rated;
  Timestamp? createdAt;
  Timestamp? startDate;
  Timestamp? endDate;
  Timestamp? sendDate;
  num? priceTotalWithDiscount;
  num? change;

  Order({
    this.agentStatus,
    this.agentId,
    this.id,
    this.customerId,
    this.sellerId,
    this.discontinuedBy,
    this.discontinuedReason,
    this.userIdDiscontinued,
    this.startDate,
    this.endDate,
    this.priceRateDelivery,
    this.totalAmount,
    this.rated,
    this.status,
    this.priceTotal,
    this.customerToken,
    this.agentToken,
    this.createdAt,
    this.sendDate,
    this.customerAdderessId,
    this.sellerAdderessId,
    this.couponId,
    this.priceTotalWithDiscount,
    this.change,
  });

  factory Order.fromDoc(DocumentSnapshot doc) {
    Order order = Order(
      id: doc['id'],
      customerId: doc['customer_id'],
      sellerId: doc['seller_id'],
      discontinuedBy: doc['discontinued_by'],
      discontinuedReason: doc['discontinued_reason'],
      userIdDiscontinued: doc['user_id_discontinued'],
      startDate: doc['start_date'],
      endDate: doc['end_date'],
      priceRateDelivery: doc['price_rate_delivery'].toDouble(),
      totalAmount: doc['total_amount'],
      priceTotal: doc['price_total'].toDouble(),
      rated: doc['rated'],
      status: doc['status'],
      customerToken: doc['customer_token'],
      agentToken: doc['agent_token'],
      customerAdderessId: doc['customer_address_id'],
      sellerAdderessId: doc['seller_address_id'],
      createdAt: doc['created_at'],
      sendDate: doc['send_date'],
      agentId: doc["agent_id"],
      agentStatus: doc["agent_status"],
      // change: doc["change"],
      // couponId: doc["coupon_id"],
      // priceTotalWithDiscount: doc["price_total_with_discount"],
    );

    try {
      order.couponId = doc["coupon_id"];
      order.change = doc["change"];
      order.priceTotalWithDiscount = doc["price_total_with_discount"];
      print('order model try');
    } catch (e) {
      print('order model catch');
    }

    return order;
  }

  factory Order.fromJson(Map<String, dynamic> map) => Order(
        id: map['id'],
        customerId: map['customer_id'],
        sellerId: map['seller_id'],
        discontinuedBy: map['discontinued_by'],
        discontinuedReason: map['discontinued_reason'],
        userIdDiscontinued: map['user_id_discontinued'],
        startDate: map['start_date'],
        endDate: map['end_date'],
        priceRateDelivery: map['price_rate_delivery'].toDouble(),
        totalAmount: map['total_amount'],
        priceTotal: map['price_total'].toDouble(),
        rated: map['rated'],
        status: map['status'],
        customerToken: map['customer_token'],
        agentToken: map['agent_token'],
        customerAdderessId: map['customer_address_id'],
        sellerAdderessId: map['seller_address_id'],
        createdAt: map['created_at'],
        sendDate: map['send_date'],
        agentId: map["agent_id"],
        agentStatus: map["agent_status"],
        couponId: map["coupon_id"],
        priceTotalWithDiscount: map["price_total_with_discount"],
        change: map["change"],
      );

  Map<String, dynamic> toJson({Order? order}) => order == null
      ? {
          'id': id,
          'customer_id': customerId,
          'seller_id': sellerId,
          'discontinued_by': discontinuedBy,
          'discontinued_reason': discontinuedReason,
          'start_date': startDate,
          'end_date': endDate,
          'price_rate_delivery': priceRateDelivery,
          'total_amount': totalAmount,
          'rated': rated,
          'status': status,
          'customer_token': customerToken,
          'agent_token ': agentToken,
          'created_at': createdAt,
          'price_total': priceTotal,
          'user_id_discontinued': userIdDiscontinued,
          'send_date': sendDate,
          'agent_id': agentId,
          'agent_status': agentStatus,
          'customer_address_id': customerAdderessId,
          'seller_address_id': sellerAdderessId,
          'coupon_id': couponId,
          'price_total_with_discount': priceTotalWithDiscount,
          'change': change,
        }
      : {
          'id': order.id,
          'customer_id': order.customerId,
          'seller_id': order.sellerId,
          'discontinued_by': order.discontinuedBy,
          'discontinued_reason': order.discontinuedReason,
          'start_date': order.startDate,
          'end_date': order.endDate,
          'price_rate_delivery': order.priceRateDelivery,
          'total_amount': order.totalAmount,
          'rated': order.rated,
          'status': order.status,
          'customer_token': order.customerToken,
          'agent_token ': order.agentToken,
          'created_at': order.createdAt,
          'price_total': order.priceTotal,
          'user_id_discontinued': order.userIdDiscontinued,
          'send_date': order.sendDate,
          'agent_id': order.agentId,
          'agent_status': order.agentStatus,
          'customer_address_id': order.customerAdderessId,
          'seller_address_id': order.sellerAdderessId,
          'coupon_id': order.couponId,
          'price_total_with_discount': order.priceTotalWithDiscount,
          'change': order.change,
        };

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getAds() async {
    QuerySnapshot<Map<String, dynamic>> orderAds = await FirebaseFirestore
        .instance
        .collection("sellers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("orders")
        .doc(id)
        .collection("ads")
        .get();

    // print('getAds: $id - ${orderAds.docs.length}');
    return orderAds.docs;
  }
}
