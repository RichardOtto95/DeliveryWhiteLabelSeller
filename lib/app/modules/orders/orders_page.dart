import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/emtpy_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'orders_store.dart';
import 'widgets/order_widget.dart';
import 'widgets/orders_app_bar.dart';

class OrdersPage extends StatefulWidget {
  final String title;
  const OrdersPage({Key? key, this.title = 'OrdersPage'}) : super(key: key);
  @override
  OrdersPageState createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> {
  final OrdersStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();
  final User? _userAuth = FirebaseAuth.instance.currentUser;

  int limit = 10;
  double lastExtent = 0;

  @override
  void initState() {
    scrollController = ScrollController();
    addListener();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  addListener() {
    scrollController.addListener(() {
      // print("offSet: ${scrollController.offset}");
      // print("maxExtent: ${scrollController.position.maxScrollExtent}");
      if (scrollController.offset >
              (scrollController.position.maxScrollExtent - 200) &&
          lastExtent < scrollController.position.maxScrollExtent) {
        setState(() {
          limit += 10;
        });
        print("limit: $limit");
        lastExtent = scrollController.position.maxScrollExtent;
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        mainStore.setVisibleNav(false);
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        mainStore.setVisibleNav(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            getPendingList(),
            getInProgressList(),
            getConcludedList(),
          ],
        ),
        OrdersAppBar(
          onTap: (int value) {
            lastExtent = 0;
            setState(() {
              limit = 15;
            });
            pageController.jumpToPage(value);
          },
        ),
      ],
    );
  }

  Widget getPendingList() {
    List viewableOrderStatus = ['REQUESTED'];
    User? _user = FirebaseAuth.instance.currentUser;
    // print('getPendingList store.viewableOrderStatus: $viewableOrderStatus');
    // List<QueryDocumentSnapshot<Map<String, dynamic>>> orders;
    return SingleChildScrollView(
      controller: scrollController,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("sellers")
            .doc(_user!.uid)
            .collection("orders")
            .where("status", whereIn: viewableOrderStatus)
            // .where("paid", isEqualTo: true)
            .orderBy("created_at", descending: true)
            .limit(limit)
            .snapshots(),
        builder: (context, snapshot) {
          // print(' getPendingList snapshot hasdata: ${snapshot.hasData}');
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          if (!snapshot.hasData) {
            return CenterLoadCircular();
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>> orders =
              snapshot.data!.docs;
          // print('getPendingList orders: $orders');
          // print('getPendingList orders.length: ${orders.length}');
          return orders.isEmpty
              ? EmptyState(
                  text: "Sem pedidos pendentes",
                  icon: Icons.file_copy_outlined,
                  height: maxHeight(context),
                )
              // Container(
              //     width: maxWidth(context),
              //     height: maxHeight(context),
              //     alignment: Alignment.center,
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Icon(
              //           Icons.file_copy_outlined,
              //           size: wXD(90, context),
              //         ),
              //         Text(
              //           "Sem pedidos pendentes ainda!",
              //           style: textFamily(context,),
              //         ),
              //       ],
              //     ),
              //   )
              : Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).viewPadding.top +
                            wXD(70, context)),
                    ...orders.map((order) {
                      // print('getPendingList order: ${order.id}');
                      // print(
                      //     'getPendingList order status: ${order.get("status")}');
                      return OrderWidget(
                        orderMap: order.data(),
                        status: order.get("status"),
                      );
                    }),
                    Container(
                      height: wXD(120, context),
                      width: wXD(100, context),
                      alignment: Alignment.center,
                      child: limit == orders.length
                          ? CircularProgressIndicator()
                          : Container(),
                    ),
                  ],
                );
        },
      ),
    );
  }

  Widget getInProgressList() {
    List viewableOrderStatus = [
      "SENDED",
      "PROCESSING",
      "DELIVERY_REQUESTED",
      "DELIVERY_REFUSED",
      "DELIVERY_ACCEPTED",
      "TIMEOUT",
    ];
    // print('getInProgressList store.viewableOrderStatus: $viewableOrderStatus');
    return SingleChildScrollView(
      controller: scrollController,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("sellers")
            .doc(_userAuth!.uid)
            .collection("orders")
            .where("status", whereIn: viewableOrderStatus)
            .orderBy("created_at", descending: true)
            .limit(limit)
            .snapshots(),
        builder: (context, snapshot) {
          // print('snapshot hasdata: ${snapshot.hasData}');

          if (!snapshot.hasData) {
            return CenterLoadCircular();
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>> orders =
              snapshot.data!.docs;
          // print('orders: $orders');
          // print('orders.length: ${orders.length}');
          return orders.isEmpty
              ? EmptyState(
                  text: "Sem pedidos em andamento",
                  icon: Icons.file_copy_outlined,
                  height: maxHeight(context),
                )
              : Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).viewPadding.top +
                            wXD(70, context)),
                    ...orders.map((order) {
                      // print('order: ${order.id}');
                      // print('order status: ${order.get("status")}');
                      return OrderWidget(
                        orderMap: order.data(),
                        status: order.get("status"),
                      );
                    }),
                    Container(
                      height: wXD(120, context),
                      width: wXD(100, context),
                      alignment: Alignment.center,
                      child: limit == orders.length
                          ? CircularProgressIndicator()
                          : Container(),
                    ),
                  ],
                );
        },
      ),
    );
  }

  Widget getConcludedList() {
    List viewableOrderStatus = [
      "CANCELED",
      "REFUSED",
      "CONCLUDED",
    ];
    // print('getConcludedList store.viewableOrderStatus: $viewableOrderStatus');
    return SingleChildScrollView(
      controller: scrollController,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("sellers")
            .doc(_userAuth!.uid)
            .collection("orders")
            .where("status", whereIn: viewableOrderStatus)
            .orderBy("created_at", descending: true)
            .limit(limit)
            .snapshots(),
        builder: (context, snapshot) {
          // print('snapshot hasdata: ${snapshot.hasData}');

          if (!snapshot.hasData) {
            return CenterLoadCircular();
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>> orders =
              snapshot.data!.docs;
          // print('orders: $orders');
          // print('orders.length: ${orders.length}');
          return orders.isEmpty
              ? EmptyState(
                  text: "Sem pedidos concluídos",
                  icon: Icons.file_copy_outlined,
                  height: maxHeight(context),
                )
              : Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).viewPadding.top +
                            wXD(70, context)),
                    ...orders.map((order) {
                      print('order: ${order.id}');
                      print('order status: ${order.get("status")}');
                      return OrderWidget(
                        orderMap: order.data(),
                        status: order.get("status"),
                      );
                    }),
                    Container(
                      height: wXD(120, context),
                      width: wXD(100, context),
                      alignment: Alignment.center,
                      child: limit == orders.length
                          ? CircularProgressIndicator()
                          : Container(),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
