import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:delivery_seller_white_label/app/core/models/address_model.dart';
import 'package:delivery_seller_white_label/app/core/models/customer_model.dart';
import 'package:delivery_seller_white_label/app/core/models/directions_model.dart';
import 'package:delivery_seller_white_label/app/core/models/order_model.dart';
import 'package:delivery_seller_white_label/app/core/models/seller_model.dart';
import 'package:delivery_seller_white_label/app/core/models/time_model.dart';
import 'package:delivery_seller_white_label/app/core/services/directions/directions_repository.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../core/models/agent_model.dart';
import '../../core/services/directions/network_helper.dart';
part 'orders_store.g.dart';

class OrdersStore = _OrdersStoreBase with _$OrdersStore;

abstract class _OrdersStoreBase with Store {
  @observable
  String? deliveryForecast;
  @observable
  String deliveryForecastLabel = "Previsão de entrega";
  // @observable
  // ObservableList viewableOrderStatus = <String>[].asObservable();
  @observable
  GoogleMapController? googleMapController;
  @observable
  Order orderSelected = Order();
  @observable
  Order? order;
  @observable
  Seller? seller;
  @observable
  Customer? customer;
  @observable
  Agent? agent;
  @observable
  String? adsId;
  @observable
  bool canBack = true;
  @observable
  Marker? origin;
  @observable
  Marker? destination;
  @observable
  MapZoomPanBehavior? zoomPanBehavior;
  @observable
  MapTileLayerController? mapTileLayerController;
  @observable
  ObservableList<MapMarker> mapMarkersList = <MapMarker>[].asObservable();
  @observable
  List<MapLatLng> polyPoints = [];
  @observable
  OverlayEntry? overlayCancel;
  @observable
  Address? destinationAddress;
  @observable
  Directions? info;
  @observable
  // ignore: cancel_subscriptions
  StreamSubscription<DocumentSnapshot>? orderSubs;
  @observable
  // ignore: cancel_subscriptions
  StreamSubscription<DocumentSnapshot>? agentSubs;
  @observable
  // ignore: cancel_subscriptions
  StreamSubscription<DocumentSnapshot>? agentListen;
  @observable
  ObservableList steps = [].asObservable();

  @action
  Future<void> addOrderListener(orderId, context) async {
    print('addOrderListener');
    Stream<DocumentSnapshot> orderSnap = FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .snapshots();

    orderSubs = orderSnap.listen((_orderDoc) async {
      print("_orderDoc: ${_orderDoc.get("status")}");
      getShippingDetails(_orderDoc, context);
      deliveryForecast = await getDeliveryForecast(_orderDoc);
    });
  }

  @action
  void sendMessage(String userId, String collection) {
    print("user: $userId, collection: $collection");
    Modular.to.pushNamed('/messages/chat', arguments: {
      "receiverId": userId,
      "receiverCollection": collection,
    });
  }

  @action
  Future<Map<String, dynamic>> getRoute(String orderId, context) async {
    print('getRoutegetRoutegetRoutegetRoutegetRoute');
    // PermissionStatus locationPermissionStatis =
    //     await Permission.location.request();
    // print('locationPermissionStatis: $locationPermissionStatis');
    // MapMarker? _agentMapMarker, _destinyMapMarker;
    DocumentSnapshot orderDoc = await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .get();

    Order _order = Order.fromDoc(orderDoc);

    steps = [
      {
        'title': 'Aguardando confirmação',
        'sub_title': 'Aguarde a confirmação da loja',
      },
      {
        'title': 'Em preparação',
        'sub_title': 'O vendedor está preparando o seu pacote.',
      },
      {
        'title': 'A caminho',
        'sub_title': 'Seu pacote está a caminho',
      },
      {
        'title': 'Entregue',
        'sub_title': '',
      },
    ].asObservable();

    if (_order.status == "REQUESTED") {
      deliveryForecast = "Nenhuma";
    }

    if (_order.status == "REFUSED") {
      steps[0]["title"] = "Pedido recusado";
      steps[0]["sub_title"] = "O vendedor recusou o seu pedido";
    }

    if (_order.status! == "CANCELED") {
      steps[1]["title"] = "Pedido cancelado";
      steps[1]["sub_title"] = "O seu pedido foi cancelado";
    }

    if (_order.status! == "DELIVERY_REFUSED") {
      steps[1]["title"] = "Envio recusado";
      steps[1]["sub_title"] = "O agente recusou a entrega";
    }

    if (_order.status! == "DELIVERY_CANCELED") {
      steps[2]["title"] = "Envio cancelado";
      steps[2]["sub_title"] = "O agente cancelou a entrega";
    }

    if (_order.status! == "CONCLUDED") {
      String _hour = Time(_order.endDate!.toDate()).hour();
      String _period = "PM";
      if (int.parse(_hour.substring(0, 2)) <= 12) {
        _period = "AM";
      }
      steps[3]["sub_title"] = "Seu pedido foi entregue às $_hour $_period";
    }

    print('_order.status ${_order.status}');
    print('_order.agentId ${_order.agentId}');

    if (_order.status == "CANCELED") {
      deliveryForecastLabel = "Pedido cancelado";
      deliveryForecast = "Sem previsão de entrega";
    } else if (_order.status == "CONCLUDED") {
      deliveryForecastLabel = "Pedido concluído";
      deliveryForecast = "Entregue";
    }

    if (_order.agentId != null &&
        _order.status != "CONCLUDED" &&
        _order.status != "CANCELED") {
      Address _destinyAddress;

      if (_order.status == "DELIVERY_ACCEPTED") {
        print('_order.sellerId: ${_order.sellerId}');
        print('_order.sellerAdderessId: ${_order.sellerAdderessId}');
        Address _sellerAddress = Address.fromDoc(await FirebaseFirestore
            .instance
            .collection("sellers")
            .doc(_order.sellerId)
            .collection("addresses")
            .doc(_order.sellerAdderessId)
            .get());

        print('_sellerAddress: $_sellerAddress');

        _destinyAddress = _sellerAddress;
      } else {
        Address _customerAddress = Address.fromDoc(await FirebaseFirestore
            .instance
            .collection("customers")
            .doc(_order.customerId)
            .collection("addresses")
            .doc(_order.customerAdderessId)
            .get());

        _destinyAddress = _customerAddress;
      }

      destinationAddress = _destinyAddress;

      double? _latitude = _destinyAddress.latitude!;
      double? _longitude = _destinyAddress.longitude!;

      MapMarker _destinyMapMarker = MapMarker(
        latitude: _latitude,
        longitude: _longitude,
        child: Icon(
          _order.status == "DELIVERY_ACCEPTED"
              ? Icons.store
              : Icons.location_on,
          color: getColors(context).primary,
        ),
      );
      print('step 1111111111111');

      mapMarkersList.add(_destinyMapMarker);
      mapTileLayerController!.insertMarker(0);
      print('step 1111111111111.2222222222222');

      Agent agentM = Agent.fromDoc(await FirebaseFirestore.instance
          .collection("agents")
          .doc(_order.agentId)
          .get());

      print('step 1111111111111.555555555555');

      Stream<DocumentSnapshot> agentStream = FirebaseFirestore.instance
          .collection("agents")
          .doc(_order.agentId)
          .snapshots();

      print('step wwwww2222222222222');

      MapMarker agentMapMarker = MapMarker(
        latitude: agentM.position!["latitude"],
        longitude: agentM.position!["longitude"],
        child: Icon(
          Icons.motorcycle,
          color: getColors(context).primary,
        ),
      );

      mapMarkersList.add(agentMapMarker);
      mapTileLayerController!.insertMarker(1);

      NetworkHelper network = NetworkHelper(
        startLat: agentM.position!["latitude"],
        startLng: agentM.position!["longitude"],
        endLat: _destinyMapMarker.latitude,
        endLng: _destinyMapMarker.longitude,
      );

      print('step 33333333333333333333');

      try {
        Map response = await network.getData();

        DirectionsOSMap _destinyDirection = response['direction'];

        polyPoints = _destinyDirection.polyPoints;
        zoomPanBehavior!.latLngBounds = _destinyDirection.bounds;

        DateTime _deliveryForecast = DateTime.now().add(
          Duration(
            seconds: _destinyDirection.durationValue.toInt() +
                _destinyDirection.durationValue.toInt() +
                600,
          ),
        );
        print('step 44444444444444444');

        String period = " PM";
        if (_deliveryForecast.hour < 12) {
          period = " AM";
        }

        deliveryForecast = Time(_deliveryForecast).hour() + period;
      } catch (e) {
        print("error on try");
        print(e);
      }

      agentListen = agentStream.listen((_agentDoc) async {
        Agent _agent = Agent.fromDoc(_agentDoc);

        double _agentLatitude = _agent.position!["latitude"];
        double _agentLongitude = _agent.position!["longitude"];

        MapMarker _agentMapMarker = MapMarker(
          latitude: _agentLatitude,
          longitude: _agentLongitude,
          child: Icon(
            Icons.motorcycle,
            color: getColors(context).primary,
          ),
        );

        if (mapTileLayerController != null) {
          if (mapTileLayerController!.markersCount == 1) {
            mapMarkersList.add(_agentMapMarker);
            mapTileLayerController!.insertMarker(1);
          } else {
            mapMarkersList[1] = _agentMapMarker;
            mapTileLayerController!.updateMarkers([1]);
          }
        }

        NetworkHelper network = NetworkHelper(
          startLat: _agentLatitude,
          startLng: _agentLongitude,
          endLat: _destinyMapMarker.latitude,
          endLng: _destinyMapMarker.longitude,
        );

        try {
          Map response = await network.getData();

          DirectionsOSMap _destinyDirection = response['direction'];

          polyPoints = _destinyDirection.polyPoints;
          zoomPanBehavior!.latLngBounds = _destinyDirection.bounds;

          DateTime _deliveryForecast = DateTime.now().add(
            Duration(
              seconds: _destinyDirection.durationValue.toInt() +
                  _destinyDirection.durationValue.toInt() +
                  600,
            ),
          );

          String period = " PM";
          if (_deliveryForecast.hour < 12) {
            period = " AM";
          }

          deliveryForecast = Time(_deliveryForecast).hour() + period;
        } catch (e) {
          print("error on try");
          print(e);
        }
      });

      // Position _position = await Geolocator.getCurrentPosition();

      return {
        // "user-current-position": _position,
        "status": "SUCCESS",
        "error-code": null,
      };
    } else {
      Address _customerAddress = Address.fromDoc(await FirebaseFirestore
          .instance
          .collection("customers")
          .doc(_order.customerId)
          .collection("addresses")
          .doc(_order.customerAdderessId)
          .get());

      destinationAddress = _customerAddress;

      MapLatLng _customerLatLng =
          MapLatLng(_customerAddress.latitude!, _customerAddress.longitude!);

      MapMarker _customerMapMarker = MapMarker(
        latitude: _customerLatLng.latitude,
        longitude: _customerLatLng.longitude,
        child: Icon(
          Icons.location_on,
          color: getColors(context).primary,
        ),
      );

      Address _sellerAddress = Address.fromDoc(await FirebaseFirestore.instance
          .collection("sellers")
          .doc(_order.sellerId)
          .collection("addresses")
          .doc(_order.sellerAdderessId)
          .get());

      MapLatLng _sellerLatLng =
          MapLatLng(_sellerAddress.latitude!, _sellerAddress.longitude!);

      MapMarker _sellerMapMarker = MapMarker(
        latitude: _sellerLatLng.latitude,
        longitude: _sellerLatLng.longitude,
        child: Icon(
          Icons.store,
          color: getColors(context).primary,
        ),
      );

      mapMarkersList.addAll([
        _customerMapMarker,
        _sellerMapMarker,
      ]);

      NetworkHelper network = NetworkHelper(
        startLat: _sellerLatLng.latitude,
        startLng: _sellerLatLng.longitude,
        endLat: _customerLatLng.latitude,
        endLng: _customerLatLng.longitude,
      );

      try {
        Map response = await network.getData();

        DirectionsOSMap _destinyDirection = response['direction'];

        polyPoints = _destinyDirection.polyPoints;
        zoomPanBehavior!.latLngBounds = _destinyDirection.bounds;

        DateTime _deliveryForecast = DateTime.now().add(
          Duration(
            seconds: _destinyDirection.durationValue.toInt() +
                _destinyDirection.durationValue.toInt() +
                600,
          ),
        );

        String period = " PM";
        if (_deliveryForecast.hour < 12) {
          period = " AM";
        }

        deliveryForecast = Time(_deliveryForecast).hour() + period;
      } catch (e) {
        print("error network getData");

        print(e);
      }

      // Position _position = await Geolocator.getCurrentPosition();
      return {
        // "user-current-position": _position,'
        "status": "SUCCESS",
        "error-code": null,
      };
    }
  }

  @action
  Future getShippingDetails(DocumentSnapshot orderDoc, context) async {
    print("getShippingDetails");

    order = Order.fromDoc(orderDoc);

    print("order!.status: ${order!.status}");

    steps = [
      {
        'title': 'Aguardando confirmação',
        'sub_title': 'Aguarde a confirmação da loja',
      },
      {
        'title': 'Em preparação',
        'sub_title': 'O vendedor está preparando o seu pacote.',
      },
      {
        'title': 'A caminho',
        'sub_title': 'Seu pacote está a caminho',
      },
      {
        'title': 'Entregue',
        'sub_title': 'O seu pedido foi entregue',
      },
      // 'sub_title': 'Seu pedido foi entregue às 13:00 PM',
    ].asObservable();

    if (order!.status == "REFUSED") {
      steps[0]["title"] = "Pedido recusado";
      steps[0]["sub_title"] = "O vendedor recusou o seu pedido";
    }

    if (order!.status! == "CANCELED") {
      steps[1]["title"] = "Pedido cancelado";
      steps[1]["sub_title"] = "O seu pedido foi cancelado";
    }

    if (order!.status! == "DELIVERY_REFUSED") {
      steps[1]["title"] = "Envio recusado";
      steps[1]["sub_title"] = "O agente recusou a entrega";
    }

    if (order!.status! == "DELIVERY_CANCELED") {
      steps[2]["title"] = "Envio cancelado";
      steps[2]["sub_title"] = "O agente cancelou a entrega";
    }

    if (order!.status! == "CONCLUDED") {
      String _hour = Time(order!.endDate!.toDate()).hour();
      String _period = "PM";
      if (int.parse(_hour.substring(0, 2)) <= 12) {
        _period = "AM";
      }
      steps[3]["sub_title"] = "Seu pedido foi entregue às $_hour $_period";
    }

    print('order!.sellerId: ${order!.sellerId}');
    DocumentSnapshot sellerDoc = await FirebaseFirestore.instance
        .collection("sellers")
        .doc(order!.sellerId)
        .get();
    print('sellerDoc id ${sellerDoc.id}');

    seller = Seller.fromDoc(sellerDoc);

    print('order!.sellerId: ${order!.customerId}');
    DocumentSnapshot customerDoc = await FirebaseFirestore.instance
        .collection("customers")
        .doc(order!.customerId)
        .get();
    print('customerDoc id ${customerDoc.id}');

    customer = Customer.fromDoc(customerDoc);

    if (order!.status == "DELIVERY_ACCEPTED") {
      destinationAddress = Address.fromDoc(await FirebaseFirestore.instance
          .collection("sellers")
          .doc(order!.sellerId)
          .collection("addresses")
          .doc(order!.sellerAdderessId)
          .get());
    } else {
      print('else: ${order!.customerAdderessId}');
      destinationAddress = Address.fromDoc(await FirebaseFirestore.instance
          .collection("customers")
          .doc(order!.customerId)
          .collection("addresses")
          .doc(order!.customerAdderessId)
          .get());
      // print('destinationAddress: ${destinationAddress!.toJson()}');
    }

    print(
        'destinationAddress!.latitude! ${destinationAddress!.latitude!} - destinationAddress!.longitude! ${destinationAddress!.longitude!}');

    destination = Marker(
      markerId: MarkerId("destination"),
      infoWindow: InfoWindow(title: "destination"),
      icon: await bitmapDescriptorFromSvgAsset(
          context, "./assets/svg/location.svg"),
      position:
          LatLng(destinationAddress!.latitude!, destinationAddress!.longitude!),
    );

    print('order!.agentId ${order!.agentId}');
    if (order!.agentId != null && order!.status != "CONCLUDED") {
      print('if');
      Stream<DocumentSnapshot> agentStream = FirebaseFirestore.instance
          .collection("agents")
          .doc(order!.agentId)
          .snapshots();

      agentSubs = agentStream.listen((_agentDoc) async {
        agent = Agent.fromDoc(_agentDoc);

        info = await DirectionRepository().getDirections(
          origin: LatLng(
              agent!.position!["latitude"], agent!.position!["longitude"]),
          destination: destination!.position,
        );

        origin = Marker(
          markerId: MarkerId("origin"),
          infoWindow: InfoWindow(title: "origin"),
          icon: await bitmapDescriptorFromSvgAsset(
              context, "./assets/svg/location.svg"),
          position: LatLng(
            agent!.position!["latitude"],
            agent!.position!["longitude"],
          ),
        );
        if (googleMapController != null)
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            googleMapController!.animateCamera(
                CameraUpdate.newLatLngBounds(info!.bounds, wXD(10, context)));
          });
      });
    } else {
      origin = null;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (googleMapController != null)
          googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: destination!.position, zoom: 14)));
      });
    }
  }

  @action
  Future<String> getDeliveryForecast(_orderDoc) async {
    String? deliveryForecast;

    Order _order = Order.fromDoc(_orderDoc);

    // Position _currentPosition = await determinePosition();

    Address _storeAddress;

    Directions? _storeDirection;

    Address _customerAddress = Address.fromDoc(await FirebaseFirestore.instance
        .collection("customers")
        .doc(_order.customerId)
        .collection("addresses")
        .doc(_order.customerAdderessId)
        .get());

    Directions? _customerDirection;

    _storeAddress = Address.fromDoc(await FirebaseFirestore.instance
        .collection("sellers")
        .doc(_order.sellerId)
        .collection("addresses")
        .doc(_order.sellerAdderessId)
        .get());

    if (_order.status == "DELIVERY_ACCEPTED") {
      _storeDirection = await DirectionRepository().getDirections(
        origin: LatLng(_storeAddress.latitude!, _storeAddress.longitude!),
        destination: LatLng(_storeAddress.latitude!, _storeAddress.longitude!),
      );

      _customerDirection = await DirectionRepository().getDirections(
        origin: LatLng(_storeAddress.latitude!, _storeAddress.longitude!),
        destination:
            LatLng(_customerAddress.latitude!, _customerAddress.longitude!),
      );

      String getDeliveryAcceptedText() {
        if (_storeDirection != null && _customerDirection != null) {
          print("Now: ${DateTime.now()}");
          print(
              "_storeDirection.durationValue: ${_storeDirection.durationValue}");
          print(
              "_customerDirection.durationValue: ${_customerDirection.durationValue}");
          DateTime _deliveryForecast = DateTime.now().add(Duration(
              seconds: _storeDirection.durationValue +
                  _customerDirection.durationValue +
                  600));
          print("_deliveryForecast: $_deliveryForecast");

          String period = " PM";
          if (_deliveryForecast.hour < 12) {
            period = " AM";
          }
          return Time(_deliveryForecast).hour() + period;
        } else {
          return "Sem previsão";
        }
      }

      return getDeliveryAcceptedText();
    } else if (_order.status == "SENDED") {
      _customerDirection = await DirectionRepository().getDirections(
        origin: LatLng(_storeAddress.latitude!, _storeAddress.longitude!),
        destination:
            LatLng(_customerAddress.latitude!, _customerAddress.longitude!),
      );
      String getDeliverySendText() {
        if (_customerDirection != null) {
          print("Now: ${DateTime.now()}");
          print(
              "_customerDirection.durationValue: ${_customerDirection.durationValue}");
          DateTime _deliveryForecast = DateTime.now()
              .add(Duration(seconds: _customerDirection.durationValue));
          print("DeliveryForecast: $_deliveryForecast");
          String period = " PM";
          if (_deliveryForecast.hour < 12) {
            period = " AM";
          }
          return Time(_deliveryForecast).hour() + period;
        } else {
          return "Sem previsão";
        }
      }

      return getDeliverySendText();
    } else {
      return deliveryForecast ?? "- - -";
    }
  }

  @action
  void clearShippingDetails() {
    if (googleMapController != null) googleMapController!.dispose();
    if (agentSubs != null) agentSubs!.cancel();
    if (orderSubs != null) orderSubs!.cancel();
    order = null;
    seller = null;
    customer = null;
    agent = null;
    origin = null;
    destination = null;
    destinationAddress = null;
    info = null;
    deliveryForecast = null;
  }

  // @action
  // setOrderStatusView(ObservableList _viewableOrderStatus) =>
  //     viewableOrderStatus = _viewableOrderStatus;

  @action
  setOrderSelected(Order _order) => orderSelected = _order;

  @action
  Future changeOrderStatus(Order model, String status, String token, context,
      Function? callBack) async {
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());

    Overlay.of(context)!.insert(loadOverlay);

    String function = "";

    Map<String, dynamic> object = {
      "id": model.id,
      "sellerId": model.sellerId,
      "customerId": model.customerId,
      // "orderId": model.id,
      "agentId": model.agentId,
      "token": token,
      "uid": model.sellerId,
      "userCollection": "sellers"
    };

    print("status: $status - orderId: ${model.id}");

    switch (status) {
      case "PROCESSING":
        function = "acceptOrder";
        break;

      case "REFUSED":
        function = "refuseOrder";
        break;

      case "DELIVERY_REQUESTED":
        print('case DELIVERY_REQUESTED: ${model.id}');
        function = "requestDelivery";
        // object = {
        //   "orderId": model.id,
        // };
        break;

      case "SENDED":
        function = "sendOrder";
        // object = {
        //   "order": {
        //     "order_id": model.id,
        //     "seller_id": model.sellerId,
        //     "customer_id": model.customerId,
        //     "agent_id": model.agentId,
        //   },
        //   "token": token,
        // };
        // print("object: $object");
        break;

      case "CANCELED":
        function = "cancelOrder";
        print("agentId: ${model.agentId}");
        // object = {
        //   "order": {
        //     "order_id": model.id,
        //     "seller_id": model.sellerId,
        //     "customer_id": model.customerId,
        //   },
        //   "userId": model.sellerId,
        //   "userCollection": "sellers"
        // };
        break;

      default:
        print("sem caso para o status: $status");
        break;
    }

    print("function: $function, Object: $object");
    if (function == '') {
      showToast("Erro ao alterar status");
      loadOverlay.remove();
      return false;
    }

    // print('function: $function');
    // FirebaseFunctions.instance.useFunctionsEmulator("localhost", 5001);
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(function);
    try {
      HttpsCallableResult callableResult = await callable.call(object);
      var response = callableResult.data;
      print("result != null: ${callableResult.data}");
      // if (response['status'] != "success") {
      showToast(response['message']);
      loadOverlay.remove();
      if (callBack != null) {
        callBack();
      }
      // showToast("Erro ao atualizar o pedido", error: true);
      // }
    } catch (e) {
      print("Erro: $e");
      loadOverlay.remove();
      showToast("Erro ao atualizar o pedido", error: true);
    }
  }

  @action
  Future<void> cancelOrder(context, DocumentSnapshot orderDoc) async {
    late OverlayEntry loadOverlay;
    canBack = false;
    loadOverlay = OverlayEntry(builder: (_) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);

    await cloudFunction(function: "cancelOrder", object: {
      "order": {
        "order_id": orderDoc['id'],
        "seller_id": orderDoc['seller_id'],
        "customer_id": orderDoc['customer_id'],
      },
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "userCollection": "customers",
    });
    canBack = true;
    loadOverlay.remove();
  }
}
