import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store {
  final MainStore mainStore = Modular.get();
  @observable
  int value = 0;
  @observable
  DateTime nowDate = DateTime.now();

  @action
  void increment() {
    value++;
  }

  @action
  Future<num> getTotalAmount() async {
    User? _user = FirebaseAuth.instance.currentUser;
    // QuerySnapshot ordersQuery = await FirebaseFirestore.instance.collection('orders').where('status', isEqualTo: "CONCLUDED").get();
    DocumentSnapshot sellerDoc = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_user!.uid)
        .get();

    mainStore.sellerOn = sellerDoc['online'];

    QuerySnapshot ordersQuery = await sellerDoc.reference
        .collection('orders')
        .where('status', isEqualTo: "CONCLUDED")
        .get();
    num totalAmount = 0;
    if (ordersQuery.docs.isNotEmpty) {
      for (var i = 0; i < ordersQuery.docs.length; i++) {
        DocumentSnapshot orderDoc = ordersQuery.docs[i];
        totalAmount += orderDoc['price_total_with_discount'];
      }
    }

    // print('totalAmount: $totalAmount');

    return totalAmount;
  }

  @action
  Future<List<Map<String, dynamic>>> getStatistics(int index) async {
    User? _user = FirebaseAuth.instance.currentUser;
    Timestamp? _start;
    Timestamp? _end;
    num totalAmount = 0;
    double rating = 0;
    List monthsWith30days = [
      4,
      6,
      9,
      11,
    ];
    List monthsWith31days = [
      1,
      3,
      5,
      7,
      8,
      10,
      12,
    ];

    if (index == 0) {
      DateTime startDate =
          DateTime(nowDate.year, nowDate.month, nowDate.day, 0, 0, 0);
      DateTime endDate =
          DateTime(nowDate.year, nowDate.month, nowDate.day, 23, 59, 59);
      _start = Timestamp.fromDate(startDate);
      _end = Timestamp.fromDate(endDate);
    }

    if (index == 1) {
      print('nowDate.weekday: ${nowDate.weekday}');
      print('nowDate.weekday -1: ${nowDate.weekday - 1}');
      print('7 - nowDate.weekday: ${7 - nowDate.weekday}');
      DateTime startDate =
          nowDate.subtract(Duration(days: nowDate.weekday - 1));
      DateTime endDate = nowDate.add(Duration(days: 7 - nowDate.weekday));
      print(
          'weekDayFirst: ${startDate.year} / ${startDate.month} / ${startDate.day}');
      print(
          'weekDayFirst: ${endDate.year} / ${endDate.month} / ${endDate.day}');
      _start = Timestamp.fromDate(startDate);
      _end = Timestamp.fromDate(endDate);
    }

    if (index == 2) {
      print('nowDate.month: ${nowDate.month}');
      if (nowDate.month == 2) {
        DateTime startDate = DateTime(nowDate.year, nowDate.month, 1, 0, 0, 0);
        DateTime endDate =
            DateTime(nowDate.year, nowDate.month, 28, 23, 59, 59);
        _start = Timestamp.fromDate(startDate);
        _end = Timestamp.fromDate(endDate);
      }

      if (monthsWith30days.contains(nowDate.month)) {
        DateTime startDate = DateTime(nowDate.year, nowDate.month, 1, 0, 0, 0);
        DateTime endDate =
            DateTime(nowDate.year, nowDate.month, 30, 23, 59, 59);
        _start = Timestamp.fromDate(startDate);
        _end = Timestamp.fromDate(endDate);
      }

      if (monthsWith31days.contains(nowDate.month)) {
        DateTime startDate = DateTime(nowDate.year, nowDate.month, 1, 0, 0, 0);
        DateTime endDate =
            DateTime(nowDate.year, nowDate.month, 31, 12, 00, 00);
        _start = Timestamp.fromDate(startDate);
        _end = Timestamp.fromDate(endDate);
      }
    }

    QuerySnapshot ordersQuery = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_user!.uid)
        .collection('orders')
        .where('created_at', isGreaterThanOrEqualTo: _start)
        .where('created_at', isLessThanOrEqualTo: _end)
        .get();

      QuerySnapshot concludedOrdersQuery = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_user.uid)
        .collection('orders')
        .where('created_at', isGreaterThanOrEqualTo: _start)
        .where('created_at', isLessThanOrEqualTo: _end)
        .where('status', isEqualTo: "CONCLUDED")
        .get();

    QuerySnapshot ratingsQuery = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_user.uid)
        .collection('ratings')
        .where('created_at', isGreaterThanOrEqualTo: _start)
        .where('created_at', isLessThanOrEqualTo: _end)
        .where('status', isEqualTo: "VISIBLE")
        .get();

    if (concludedOrdersQuery.docs.isNotEmpty) {
      for (var i = 0; i < concludedOrdersQuery.docs.length; i++) {
        DocumentSnapshot orderDoc = concludedOrdersQuery.docs[i];
        totalAmount += orderDoc['price_total_with_discount'];
      }
    }

    if (ratingsQuery.docs.isNotEmpty) {
      for (var i = 0; i < ratingsQuery.docs.length; i++) {
        DocumentSnapshot ratingDoc = ratingsQuery.docs[i];
        rating += ratingDoc['rating'];
      }
      rating = rating / ratingsQuery.docs.length;
    }

    // print('totalAmount: $totalAmount');

    return [
      {
        "ordersLength": ordersQuery.docs.length,
        "isGreaterThan": 3,
        "valid": ordersQuery.docs.length > 3,
      },
      {
        "totalAmount": totalAmount,
        "isGreaterThan": 100,
        "valid": totalAmount > 100,
      },
      {
        "ratings": rating,
        "isGreaterThan": 4,
        "valid": rating > 4,
      },
    ];
  }
}
