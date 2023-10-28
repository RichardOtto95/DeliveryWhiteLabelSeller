import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:delivery_seller_white_label/app/constants/.env.dart';
import 'package:delivery_seller_white_label/app/core/models/address_model.dart';
import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/load_circular_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:mobx/mobx.dart';
import '../../core/services/directions/uuid.dart';
import 'package:http/http.dart';

part 'address_store.g.dart';

class AddressStore = _AddressStoreBase with _$AddressStore;

abstract class _AddressStoreBase with Store {
  final MainStore mainStore = Modular.get();

  @observable
  OverlayEntry? editAddressOverlay;
  @observable
  OverlayEntry? addresEditionOverlay;
  @observable
  bool hasAddress = false;
  // @observable
  // bool addressOverlay = false;
  @observable
  bool canBack = false;
  @observable
  GoogleMapController? mapController;
  @observable
  LatLng latLng = LatLng(-15.787747, -48.008066);
  @observable
  CameraPosition cameraPosition = CameraPosition(
    zoom: 14,
    target: LatLng(-15.787747, -48.008066),
  );
  @observable
  Circle? circle;

  @action
  getCanBack() => canBack;

  @action
  Future<Address?> getLocation(context, Address _address) async {
    loc.Location location = loc.Location();
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    loc.PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return null;
      }
    }

    loc.LocationData _locationData = await location.getLocation();

    if (_locationData.latitude != null && _locationData.longitude != null) {
      latLng = LatLng(_locationData.latitude!, _locationData.longitude!);

      print("getLocation: ${latLng.toJson()}");

      circle = Circle(
        circleId: const CircleId("car"),
        radius: _locationData.accuracy ?? 0,
        zIndex: 1,
        strokeColor: getColors(context).primary,
        center: latLng,
        fillColor: getColors(context).primary.withAlpha(70),
        strokeWidth: 12,
      );

      setLatLng(latLng);
      _address = await setAddressByLatLng(context, latLng, _address);
    }
    return _address;
  }

  @action
  Future<Map<String, dynamic>> searchPlaces(context, String query) async {
    var _sessionToken = Uuid().generateV4();

    String _host =
        'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/place/textsearch/json';

    final url = '$_host?query=$query&region=br&limit=8&key=$googleAPIKey';

    final Response response = await get(Uri.parse(url), headers: {
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer " + _sessionToken,
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    });

    Map<String, dynamic> values = {};
    print(' HAHA: ${response}');
    values =  json.decode(response.body);
    print(' valuesvalues: ${values}');

    return values;
  }

  @action
  Future<Address> getAddressByLocation(context, Address _address) async {
    latLng = await mapController!.getLatLng(ScreenCoordinate(
      x: (maxWidth(context) / 2).truncate(),
      y: (maxHeight(context) / 2).truncate(),
    ));

    GoogleGeocoding googleGeocoding = GoogleGeocoding(googleAPIKey);

    LatLon latLon = LatLon(latLng.latitude, latLng.longitude);

    GeocodingResponse? geoResponse =
        await googleGeocoding.geocoding.getReverse(latLon);

    if (geoResponse != null && geoResponse.results != null) {
      _address = Address.fromGeoResult(geoResponse.results!.first, _address);
      _address.latitude = latLng.latitude;
      _address.longitude = latLng.longitude;
    }
    return _address;
  }

  @action
  Future<Address> setAddressByLatLng(context, LatLng _latLng, Address _address) async {
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());

    Overlay.of(context)!.insert(loadOverlay);

    GoogleGeocoding googleGeocoding = GoogleGeocoding(googleAPIKey);

    LatLon latLon = LatLon(latLng.latitude, latLng.longitude);

    GeocodingResponse? geoResponse =
        await googleGeocoding.geocoding.getReverse(latLon);

    if (geoResponse != null && geoResponse.results != null) {
      _address =
          Address.fromGeoResult(geoResponse.results!.first, _address);
    }

    setLatLng(_latLng);
    loadOverlay.remove();
    return _address;
  }

  @action
  Future<void> setLatLng(LatLng _latLng) async {
    latLng = _latLng;

    cameraPosition = CameraPosition(
      zoom: 20,
      target: latLng,
    );

    print("mapController: ${mapController != null}");

    if (mapController != null) {
      await mapController!.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
    }
  }

  @action
  newAddress(Address address, context, bool editing) async {
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(overlayEntry);

    canBack = false;
    String functionName = "newAddress";

    if (editing) {
      functionName = "editAddress";
    }

    Map<String, dynamic> addressMap = address.toJson();

    if (addressMap.containsKey("created_at")) {
      addressMap.remove("created_at");
    }

    print('addressMap: $addressMap');

    final user = FirebaseAuth.instance.currentUser!;

    await cloudFunction(function: functionName, object: {
      "address": addressMap,
      "collection": "sellers",
      "userId": user.uid,
    });

    overlayEntry.remove();
    canBack = true;
  }

  @action
  setMainAddress(String addressId) async {
    User user = FirebaseAuth.instance.currentUser!;
    print("setMainAddress");
    QuerySnapshot addressQue = await FirebaseFirestore.instance
      .collection("sellers")
      .doc(user.uid)
      .collection("addresses")
      .where("main", isEqualTo: true)
      .get();

    for (var addressDoc in addressQue.docs) {
      await addressDoc.reference.update({"main": false});
    }

    DocumentReference selRef = FirebaseFirestore.instance.collection("sellers").doc(user.uid);

    await selRef.collection("addresses").doc(addressId).update({"main": true});

    await selRef.update({"main_address": addressId});
  }

  @action
  deleteAddress(context, Address address) async {
    canBack = false;
    final User user = FirebaseAuth.instance.currentUser!;
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(overlayEntry);

    DocumentSnapshot _userDoc = await FirebaseFirestore.instance
      .collection("sellers")
      .doc(user.uid)
      .get();

    await _userDoc.reference
      .collection("addresses")
      .doc(address.id)
      .update({
        "status": "DELETED", 
        "main": false
      });

    if (_userDoc.get("main_address") == address.id) {
      String? mainAddress = null;

      QuerySnapshot activeAddresses = await _userDoc.reference
          .collection("addresses")
          .where("status", isEqualTo: "ACTIVE")
          .orderBy("created_at", descending: true)
          .get();

      if (activeAddresses.docs.isNotEmpty) {
        await activeAddresses.docs.first.reference.update({"main": true});
        mainAddress = activeAddresses.docs.first.id;
      }

      await _userDoc.reference.update({"main_address": mainAddress});
    }

    overlayEntry.remove();
    editAddressOverlay!.remove();
    editAddressOverlay = null;
    canBack = true;
  }
}
