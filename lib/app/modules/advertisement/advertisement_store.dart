import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:delivery_seller_white_label/app/core/models/ads_model.dart';
import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../shared/widgets/redirect_popup.dart';
part 'advertisement_store.g.dart';

class AdvertisementStore = _AdvertisementStoreBase with _$AdvertisementStore;

abstract class _AdvertisementStoreBase with Store {
  final MainStore mainStore = Modular.get();

  @observable
  bool addAds = true;
  @observable
  bool delete = false;
  @observable
  bool takePicture = false;
  @observable
  bool searchType = false;
  @observable
  bool deleteImage = false;
  @observable
  bool adsIsNew = true;
  @observable
  bool categoryValidateVisible = false;
  @observable
  bool typeValidateVisible = false;
  @observable
  bool imagesEmpty = false;
  @observable
  bool circularIndicator = false;
  @observable
  bool charging = true;
  @observable
  bool editingAd = false;
  @observable
  bool removingEditingAd = false;
  @observable
  int imageSelected = 0;
  @observable
  int adsActive = 0;
  @observable
  int adsPending = 0;
  @observable
  int adsExpired = 0;
  @observable
  num? sellerPrice;
  @observable
  String adsTitle = '';
  @observable
  String adsDescription = '';
  @observable
  String adsCategory = '';
  @observable
  String adsType = '';
  @observable
  String adsOption = '';
  @observable
  num adsQntdd = 0;
  @observable
  String adsStatusSelected = 'ACTIVE';
  @observable
  AdsModel adDelete = AdsModel();
  @observable
  AdsModel adEdit = AdsModel();
  @observable
  List<DocumentSnapshot> types = [];
  @observable
  ObservableList<File> images = <File>[].asObservable();
  @observable
  ObservableList<Uint8List> imagesView = <Uint8List>[].asObservable();
  @observable
  ObservableList<AdsModel> activeAds = <AdsModel>[].asObservable();
  @observable
  ObservableList<AdsModel> pendingAds = <AdsModel>[].asObservable();
  @observable
  ObservableList<AdsModel> expiredAds = <AdsModel>[].asObservable();
  // @observable
  // String deliveryType = '';
  // @observable
  // bool deliveryTypeValidate = false;
  @observable
  num totalPrice = 0;
  @observable
  num rateService = 0;
  @observable
  OverlayEntry? redirectOverlay;
  @observable
  ObservableMap<String, bool> checkedAdditionalMap =
      <String, bool>{}.asObservable();
  @observable
  ObservableList<String> checkedAdditionalList = <String>[].asObservable();
  @observable
  Map<String, Map> additionalResponse = {};

  @action
  Future<String> getInitialValue(String additionalId) async {
    String response = "";
    // print('editingAd: $editingAd');

    if (editingAd) {
      DocumentSnapshot additionalDoc = await FirebaseFirestore.instance
          .collection('ads')
          .doc(adEdit.id)
          .collection('additional')
          .doc(additionalId)
          .get();
      String? responseText = additionalDoc['response_text'];
      if (responseText != null) {
        response = responseText;
      }
    }
    // print('response: $response');
    return response;
  }

  @action
  Future<QuerySnapshot<Map<String, dynamic>>> getAdditionalList() async {
    final User user = FirebaseAuth.instance.currentUser!;
    QuerySnapshot<Map<String, dynamic>> additionalQuery =
        await FirebaseFirestore.instance
            .collection("sellers")
            .doc(user.uid)
            .collection("additional")
            .where("status", isEqualTo: "ACTIVE")
            .get();

    for (var additionalDoc in additionalQuery.docs) {
      if (!checkedAdditionalMap.containsKey(additionalDoc.id)) {
        checkedAdditionalMap.putIfAbsent(additionalDoc.id, () => true);
      }
    }

    return additionalQuery;
  }

  @action
  Future<bool> getInitialOptions() async {
    if (editingAd) {
      QuerySnapshot additionalQuery = await FirebaseFirestore.instance
          .collection("ads")
          .doc(adEdit.id)
          .collection("additional")
          .orderBy('index')
          .get();
          
      for (var i = 0; i < additionalQuery.docs.length; i++) {
        DocumentSnapshot additionalDoc = additionalQuery.docs[i];
        if (!checkedAdditionalMap.containsKey(additionalDoc.id)) {
          checkedAdditionalMap.putIfAbsent(additionalDoc.id, () => true);
          checkedAdditionalList.add(additionalDoc.id);
        }
      }
    } else {
      final User user = FirebaseAuth.instance.currentUser!;

      QuerySnapshot? additionalQuery = await FirebaseFirestore.instance
          .collection("sellers")
          .doc(user.uid)
          .collection("additional")
          .where('auto_selected', isEqualTo: true)
          .get();
      print('additionalQuery.docs.length: ${additionalQuery.docs.length}');
      for (var i = 0; i < additionalQuery.docs.length; i++) {
        DocumentSnapshot additionalDoc = additionalQuery.docs[i];
        if (!checkedAdditionalMap.containsKey(additionalDoc.id)) {
          checkedAdditionalMap.putIfAbsent(additionalDoc.id, () => true);
          checkedAdditionalList.add(additionalDoc.id);
        }
      }
    }
    return true;
  }

  @action
  Future<List<Map<String, dynamic>>> getCheckboxList(
      String additionalId) async {
    final User user = FirebaseAuth.instance.currentUser!;

    List<Map<String, dynamic>> checkboxArray = [];
    QuerySnapshot checkboxList = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(user.uid)
        .collection('additional')
        .doc(additionalId)
        .collection("checkbox")
        .where("status", isEqualTo: "ACTIVE")
        .orderBy("index")
        .get();

    print('@@@@@@@@@@@@checkboxList.docs.length: ${checkboxList.docs.length}');
    for (DocumentSnapshot checkboxDoc in checkboxList.docs) {
      bool response = false;
      // print('editingAd: $editingAd');
      if (editingAd) {
        // print('adEdit.id: ${adEdit.id}');
        // print('additionalId: $additionalId');
        // print('checkboxDoc.id: ${checkboxDoc.id}');

        DocumentSnapshot checkboxResponse = await FirebaseFirestore.instance
            .collection('ads')
            .doc(adEdit.id)
            .collection('additional')
            .doc(additionalId)
            .collection('checkbox')
            .doc(checkboxDoc.id)
            .get();
        if (checkboxResponse.exists) {
          response = checkboxResponse["response"];
        }
      }
      try {
        checkboxArray[checkboxDoc['index']] = {
          "index": checkboxDoc['index'],
          "label": checkboxDoc['label'],
          "value": checkboxDoc['value'],
          "id": checkboxDoc.id,
          "response": response,
        };
        // print('success');

      } catch (e) {
        // print('failed');
        // print(e);
        checkboxArray.add({
          "index": checkboxDoc['index'],
          "label": checkboxDoc['label'],
          "value": checkboxDoc['value'],
          "id": checkboxDoc.id,
          "response": response,
        });
      }
    }
    return checkboxArray;
  }

  @action
  Future<List<Map<String, dynamic>>> getRadiobuttonList(
      String additionalId) async {
    final User user = FirebaseAuth.instance.currentUser!;

    List<Map<String, dynamic>> radiobuttonArray = [];
    QuerySnapshot radiobuttonList = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(user.uid)
        .collection('additional')
        .doc(additionalId)
        .collection("radiobutton")
        .where("status", isEqualTo: "ACTIVE")
        .orderBy("index")
        .get();

    String? label = "";
    if (editingAd) {
      DocumentSnapshot additionalDoc = await FirebaseFirestore.instance
          .collection('ads')
          .doc(adEdit.id)
          .collection('additional')
          .doc(additionalId)
          .get();

      if(additionalDoc.exists){
        label = additionalDoc['response_label'];
      }
    }

    for (DocumentSnapshot radiobuttonDoc in radiobuttonList.docs) {
      // print('checkboxDoc: ${radiobuttonDoc.data()}');
      bool selected = false;
      if (label == radiobuttonDoc['label']) {
        additionalResponse.putIfAbsent(additionalId, () => {
          "response_label": radiobuttonDoc['label'],
          "response_value": radiobuttonDoc['value'],
          "response_index": radiobuttonDoc['index'],
        });
        selected = true;
      }
      try {
        radiobuttonArray[radiobuttonDoc['index']] = {
          "index": radiobuttonDoc['index'],
          "label": radiobuttonDoc['label'],
          "value": radiobuttonDoc['value'],
          "selected": selected,
        };
        // print('success');

      } catch (e) {
        // print('failed');
        // print(e);
        radiobuttonArray.add({
          "index": radiobuttonDoc['index'],
          "label": radiobuttonDoc['label'],
          "value": radiobuttonDoc['value'],
          "selected": selected,
        });
      }
    }
    return radiobuttonArray;
  }

  @action
  setAddAds(_addAds) => addAds = _addAds;
  @action
  setdelete(_delete) => delete = _delete;
  @action
  settakePicture(_takePicture) => takePicture = _takePicture;
  @action
  setSearchType(_searchType) => searchType = _searchType;
  @action
  setImageSelected(_imageSelected) => imageSelected = _imageSelected;
  @action
  setDeleteImage(_deleteImage) => deleteImage = _deleteImage;
  @action
  setAdDelete(_adDelete) => adDelete = _adDelete;
  @action
  setEditingAd(_editingAd) => editingAd = _editingAd;
  @action
  setRemovingEditingAd(_removingEditingAd) =>
      removingEditingAd = _removingEditingAd;
  @action
  setAdEdit(_adEdit) => adEdit = _adEdit;
  @action
  setAdsTitle(_adsTitle) => adsTitle = _adsTitle;
  @action
  setAdsDescription(_adsDescription) => adsDescription = _adsDescription;
  @action
  setAdsCategory(_adsCategory) => adsCategory = _adsCategory;
  @action
  setAdsOption(_adsOption) => adsOption = _adsOption;
  @action
  setAdsType(_adsType) => adsType = _adsType;
  @action
  setAdsIsNew(_adsIsNew) => adsIsNew = _adsIsNew;
  @action
  setAdsPrice(_adsPrice) => sellerPrice = _adsPrice;
  @action
  setAdsStatusSelected(_adsStatusSelected) =>
      adsStatusSelected = _adsStatusSelected;

  @action
  Future<void> getFinalPrice(num price) async {
    // QuerySnapshot infoQuery =
    //     await FirebaseFirestore.instance.collection('info').get();
    // DocumentSnapshot infoDoc = infoQuery.docs.first;

    // num _rateService =
    //     num.parse((price * infoDoc['rate_service']).toStringAsPrecision(2));

    // num _sellerPrice = num.parse((price - _rateService).toStringAsFixed(2));

    // print('getFinalPrice: $price, $_rateService, $_sellerPrice');
    // if (editingAd) {
    //   adEdit.sellerPrice = _sellerPrice;
    //   adEdit.rateServicePrice = _rateService;
    //   adEdit.totalPrice = price;
    // } else {
    //   setAdsPrice(price);
    // }

    sellerPrice = price;
    rateService = 0;
    totalPrice = price;
  }

  @action
  bool getProgress() => circularIndicator;

  @action
  setAdsValues(QuerySnapshot _qs) {
    activeAds.clear();
    pendingAds.clear();
    expiredAds.clear();

    int _adsActive = 0;
    int _adsPending = 0;
    int _adsExpired = 0;

    List<AdsModel> _activeAds = [];
    List<AdsModel> _pendingAds = [];
    List<AdsModel> _expiredAds = [];

    _qs.docs.forEach((adsDoc) {
      // print(adsDoc.data());
      AdsModel adsModel = AdsModel.fromDoc(adsDoc);

      if (adsModel.status != "DELETED") {
        switch (adsModel.status) {
          case 'ACTIVE':
            _adsActive += 1;
            _activeAds.add(adsModel);
            break;
          case 'PENDING':
            _adsPending += 1;
            _pendingAds.add(adsModel);
            break;
          case 'EXPIRED':
            _adsExpired += 1;
            _expiredAds.add(adsModel);
            break;
          default:
        }
      }
    });

    activeAds = _activeAds.asObservable();
    pendingAds = _pendingAds.asObservable();
    expiredAds = _expiredAds.asObservable();

    adsActive = _adsActive;
    adsPending = _adsPending;
    adsExpired = _adsExpired;

    return false;
  }

  @action
  String getCategoryValidateText() {
    // print('val price: $val');
    if (adsCategory == '' && adsOption != '') {
      // print('Categoria 1');
      return 'Escolha uma categoria';
    }
    if (adsCategory != '' && adsOption == '') {
      // print('Categoria 2');
      return 'Escolha uma opção';
    }
    if (adsCategory == '' && adsOption == '') {
      // print('Categoria 3');
      return 'Escolha uma categoria e uma opção';
    }
    return 'Algo de errado não está certo';
  }

  @action
  callDelete({bool removeDelete = false, AdsModel? ad}) {
    if (removeDelete) {
      setdelete(false);
    } else {
      adDelete = ad!;
      setdelete(true);
    }
  }

  @action
  uploadImage() async {
    bool permission =
        kIsWeb ? true : await Permission.storage.request().isGranted;
    if (permission) {
      final picker = ImagePicker();
      // print('@@@@@@@@@@@@ images.length: ${images.length}  @@@@@@@@@ ');

      final List<XFile>? pickedFile = await picker.pickMultiImage();

      if (pickedFile != null) {
        int filesLength = pickedFile.length;
        // print(${images.length}');
        if ((filesLength + images.length + adEdit.images.length) > 20) {
          showToast('Somente 6 imagens são permitidas');

          int imagensAMais =
              filesLength + images.length + adEdit.images.length - 6;

          pickedFile.removeRange(
            pickedFile.length - imagensAMais,
            pickedFile.length,
          );
        }

        ObservableList<File> _images = images;
        ObservableList<Uint8List> _imagesView = imagesView;

        for (var xFile in pickedFile) {
          _images.add(File(xFile.path));
          _imagesView.add(await xFile.readAsBytes());
        }

        images = _images;
        imagesView = _imagesView;

        settakePicture(false);
      }
    }
  }

  @action
  pickImage() async {
    bool permission =
        kIsWeb ? true : await Permission.storage.request().isGranted;
    if (permission) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
          source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
      if (pickedFile != null) {
        print('Images.length: ${images.length}');
        if (images.length < 6) {
          images.add(File(pickedFile.path));
        } else {
          Fluttertoast.showToast(msg: 'Somente 6 imagens são permitidas');
        }
      }
    }
  }

  @action
  removeImage() {
    // print("removingEditingAd: $removingEditingAd");
    if (removingEditingAd) {
      adEdit.images.removeAt(imageSelected);
    } else {
      images.removeAt(imageSelected);
      imagesView.removeAt(imageSelected);
    }
  }

  @action
  bool getValidate() {
    print(
        'option == "$adsOption" || adsCategory == "$adsCategory" || adsType == "$adsType"');
    if (editingAd) {
      if (adEdit.option == '') {}
      if (adEdit.category == '') {}
      if (adEdit.type == '') {}
    } else if (adsOption == '' ||
        adsCategory == '' ||
        adsType == '' ||
        // images.isEmpty ||
        // deliveryType.isEmpty) {
        images.isEmpty) {
      if (adsOption == '' || adsCategory == '') {
        categoryValidateVisible = true;
        print('categoryValidate: $categoryValidateVisible');
      }
      if (adsType == '') {
        typeValidateVisible = true;
      }
      if (images.isEmpty && adEdit.images.isEmpty) {
        imagesEmpty = true;
      }

      // if (deliveryType.isEmpty) {
      //   deliveryTypeValidate = true;
      // }
      return false;
    }
    imagesEmpty = false;
    categoryValidateVisible = false;
    typeValidateVisible = false;
    // deliveryTypeValidate = false;
    return true;
  }

  @action
  Future<List<String>> getImagesLink(
      {required List<File> imageFiles,
      required String uid,
      required docId}) async {
    print("getImagesLink1");
    List<String> imagesLink = [];
    print("getImagesLink2");

    for (var i = 0; i < imageFiles.length; i++) {
      print("getImagesLink3");
      XFile xfile = XFile(imageFiles[i].path);
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('sellers/$uid/ads/$docId/image$i/${xfile.name}');
      print("getImagesLink4");
      Uint8List uint8list = await xfile.readAsBytes();
      UploadTask uploadTask = firebaseStorageRef.putData(uint8list);
      print("getImagesLink5");
      TaskSnapshot taskSnapshot = await uploadTask;
      print("getImagesLink6");
      String imageString = await taskSnapshot.ref.getDownloadURL();
      print("getImagesLink7");

      // print("ImageString: $imageString");
      imagesLink.add(imageString);
      // print("imagesLink: $imagesLink");
    }
    print("getImagesLink3");
    return imagesLink;
  }

  @action
  createAds(BuildContext context) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)?.insert(overlayEntry);
    try {
      circularIndicator = true;
      final User? _user = FirebaseAuth.instance.currentUser;
      print('createAds: ${_user!.uid}');

      DocumentReference adsRef =
          FirebaseFirestore.instance.collection("ads").doc();
      print('adsRef: ${adsRef.id}');

      List<String> imagesDowloadLink = await getImagesLink(
          imageFiles: images, uid: _user.uid, docId: adsRef.id);
      print('imagesDowloadLink: ${imagesDowloadLink.length}');

      AdsModel adsModel = AdsModel(
        // deliveryType: deliveryType,
        id: adsRef.id,
        title: adsTitle,
        description: adsDescription,
        category: adsCategory,
        option: adsOption,
        type: adsType,
        isNew: adsIsNew,
        // price: adsPrice!,
        sellerPrice: sellerPrice!,
        rateServicePrice: rateService,
        totalPrice: totalPrice,
        paused: false,
        status: 'ACTIVE',
        images: imagesDowloadLink,
        sellerId: _user.uid,
        onlineSeller: true,
        amount: adsQntdd,
      );

      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable("createAds");
      HttpsCallableResult? result;
      try {
        List newList = [];
        additionalResponse.forEach((key, value) {
          newList.add({
            "id": key,
            "object": value,
          });
        });
        result = await callable.call({
          "adsJson": adsModel.toJson(),
          "additionalArray": checkedAdditionalList,
          "responseJson": newList,
        });
        print('result: ${result.data}');

        if (result.data['status'] == "success") {
          circularIndicator = false;
          overlayEntry.remove();
          Modular.to.pop();
          cleanVars();

          await Modular.to.pushNamed('/advertisement/ads-confirm', arguments: {
            'title': adsTitle,
            'id': adsRef.id,
          });
        } else {
          if (result.data['error-code'] == "without-opening-hours") {
            overlayEntry.remove();

            circularIndicator = false;
            redirectOverlay = OverlayEntry(
              builder: (context) => RedirectPopup(
                height: wXD(165, context),
                text:
                    'Você ainda não tem um horário de funcionamento, deseja adicionar um?',
                onConfirm: () async {
                  redirectOverlay!.remove();
                  redirectOverlay = null;

                  Modular.to.pushNamed('/profile/edit-profile');
                  // await Modular.to.pushNamed("/add-card");
                },
                onCancel: () {
                  redirectOverlay!.remove();
                  redirectOverlay = null;
                },
              ),
            );

            Overlay.of(context)?.insert(redirectOverlay!);
          } else {
            print("result.data: ${result.data}");
            showToast(result.data['message']);
          }
          overlayEntry.remove();
        }
      } catch (e) {
        overlayEntry.remove();
        print("Error on function: $e");
        print(e);
        // return null;
      }
    } catch (e) {
      print("E: $e");
      overlayEntry.remove();
    }
  }

  @action
  editAds(BuildContext context) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)?.insert(overlayEntry);
    circularIndicator = true;
    final User? _user = FirebaseAuth.instance.currentUser;

    List<String> imagesDowloadLink = await getImagesLink(
        imageFiles: images, uid: adEdit.sellerId, docId: adEdit.id);

    adEdit.images = adEdit.images + imagesDowloadLink;
    QuerySnapshot additionalQuery = await FirebaseFirestore.instance
        .collection('ads')
        .doc(adEdit.id)
        .collection("additional")
        .get();

    for (var i = 0; i < additionalQuery.docs.length; i++) {
      DocumentSnapshot additionalDoc = additionalQuery.docs[i];
      await FirebaseFirestore.instance
          .collection('ads')
          .doc(adEdit.id)
          .collection("additional")
          .doc(additionalDoc.id)
          .delete();

      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(_user!.uid)
          .collection('ads')
          .doc(adEdit.id)
          .collection("additional")
          .doc(additionalDoc.id)
          .delete();
    }

    for (int i = 0; i < checkedAdditionalList.length; i++) {
      String additionalId = checkedAdditionalList[i];
      await FirebaseFirestore.instance
          .collection('ads')
          .doc(adEdit.id)
          .collection("additional")
          .doc(additionalId)
          .set({
        "index": i,
        "id": additionalId,
        "response_label": null,
        "response_count": null,
        "response_text": null,
        "response_value": null,
      });
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(_user!.uid)
          .collection('ads')
          .doc(adEdit.id)
          .collection("additional")
          .doc(additionalId)
          .set({
        "index": i,
        "id": additionalId,
        "response_label": null,
        "response_count": null,
        "response_text": null,
        "response_value": null,
      });
    }

    List newList = [];
    additionalResponse.forEach((key, value) {
      newList.add({
        "id": key,
        "object": value,
      });
    });

    print("newList.length: ${newList.length}");
    for (var i = 0; i < newList.length; i++) {
      var element = newList[i];
      print("element: $element");
      print("element: ${element['id']}");
      print("element: ${element['object']}");
      DocumentSnapshot additionalDoc = await FirebaseFirestore.instance
          .collection('sellers')
          .doc(_user!.uid)
          .collection('additional')
          .doc(element['id'])
          .get();
      print("additionalDoc: ${additionalDoc['type']}");

      switch (additionalDoc['type']) {
        case "check-box":
          Map checkboxMap = element['object'];
          print('checkboxMap: $checkboxMap');
          int lengthMinimum = additionalDoc['number_mandatory_fields'];
          int count = 0;

          checkboxMap.forEach((key, value) {
            if (value == true) {
              count++;
            }
          });
          if (count >= lengthMinimum) {
            checkboxMap.forEach((key, value) {
              print('checkboxMap key: $key');
              print('checkboxMap value: $value');
              FirebaseFirestore.instance
                  .collection('ads')
                  .doc(adEdit.id)
                  .collection("additional")
                  .doc(element['id'])
                  .collection('checkbox')
                  .doc(key)
                  .update({"response": value});

              FirebaseFirestore.instance
                  .collection('sellers')
                  .doc(_user.uid)
                  .collection('ads')
                  .doc(adEdit.id)
                  .collection("additional")
                  .doc(element['id'])
                  .collection('checkbox')
                  .doc(key)
                  .update({"response": value});
            });
          } else {
            showToast(
                "Falta escolher mais  ${lengthMinimum - count} ${additionalDoc.get("title")}");
            overlayEntry.remove();

            circularIndicator = false;
            return;
          }

          break;

        case "radio-button":
          Map obj = element['object'];
          await FirebaseFirestore.instance
              .collection('ads')
              .doc(adEdit.id)
              .collection("additional")
              .doc(element['id'])
              .update({
            "response_label": obj['response_label'],
            "response_value": obj['response_value'],
          });

          await FirebaseFirestore.instance
              .collection('sellers')
              .doc(_user.uid)
              .collection('ads')
              .doc(adEdit.id)
              .collection("additional")
              .doc(element['id'])
              .update({
            "response_label": element['object']['reponse_label'],
            "response_value": element['object']['reponse_value'],
          });

          break;

        case "combo-box":
          Map obj = element['object'];
          await FirebaseFirestore.instance
              .collection('ads')
              .doc(adEdit.id)
              .collection("additional")
              .doc(element['id'])
              .update({
            "response_label": obj['response_label'],
            "response_value": obj['response_value'],
          });

          await FirebaseFirestore.instance
              .collection('sellers')
              .doc(_user.uid)
              .collection('ads')
              .doc(adEdit.id)
              .collection("additional")
              .doc(element['id'])
              .update({
            "response_label": element['object']['reponse_label'],
            "response_value": element['object']['reponse_value'],
          });

          break;

        case "increment":
          Map obj = element['object'];
          await FirebaseFirestore.instance
              .collection('ads')
              .doc(adEdit.id)
              .collection("additional")
              .doc(element['id'])
              .update({
            "response_count": obj['response_count'],
          });

          await FirebaseFirestore.instance
              .collection('sellers')
              .doc(_user.uid)
              .collection('ads')
              .doc(adEdit.id)
              .collection("additional")
              .doc(element['id'])
              .update({
            "response_count": obj['response_count'],
          });

          break;

        default:
          Map obj = element['object'];
          await FirebaseFirestore.instance
              .collection('ads')
              .doc(adEdit.id)
              .collection("additional")
              .doc(element['id'])
              .update({
            "response_text": obj['response_text'],
          });

          await FirebaseFirestore.instance
              .collection('sellers')
              .doc(_user.uid)
              .collection('ads')
              .doc(adEdit.id)
              .collection("additional")
              .doc(element['id'])
              .update({
            "response_text": element['object']['reponse_text'],
          });
          print("default");
          break;
      }
    }

    await FirebaseFirestore.instance
        .collection('ads')
        .doc(adEdit.id)
        .update(adEdit.toJson());

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(adEdit.sellerId)
        .collection('ads')
        .doc(adEdit.id)
        .update(adEdit.toJson());

    overlayEntry.remove();

    circularIndicator = false;
    cleanVars();

    Modular.to.pop();
    return;
  }

  @action
  cleanVars() {
    adsDescription = '';
    adsCategory = '';
    adsOption = '';
    adsTitle = '';
    adsType = '';
    // deliveryType = '';
    // deliveryTypeValidate = false;
    editingAd = false;
    totalPrice = 0;
    adsQntdd = 0;
    // rateService = 0;
    adsIsNew = true;
    // sellerPrice = null;
    images.clear();
    imagesView.clear();
    imagesEmpty = false;
    categoryValidateVisible = false;
    typeValidateVisible = false;
    adEdit = AdsModel();
    checkedAdditionalMap.clear();
    checkedAdditionalList.clear();
  }

  @action
  pauseAds({
    required String adsId,
    required bool pause,
    required BuildContext context,
  }) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)?.insert(overlayEntry);

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('ads')
        .doc(adsId)
        .update({'paused': pause});

    await FirebaseFirestore.instance
        .collection('ads')
        .doc(adsId)
        .update({'paused': pause});

    overlayEntry.remove();
  }

  @action
  highlightAd({
    required String adsId,
    required BuildContext context,
  }) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)?.insert(overlayEntry);

    await FirebaseFirestore.instance
        .collection('ads')
        .doc(adsId)
        .update({'highlighted': true});

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('ads')
        .doc(adsId)
        .update({'highlighted': true});

    overlayEntry.remove();

    Fluttertoast.showToast(msg: 'Anúncio destacado com sucesso');
  }

  @action
  deleteAds({
    required BuildContext context,
  }) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)?.insert(overlayEntry);

    await FirebaseFirestore.instance.collection('ads').doc(adDelete.id).update({
      'status': 'DELETED',
    });

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('ads')
        .doc(adDelete.id)
        .update({
      'status': 'DELETED',
    });

    overlayEntry.remove();
  }
}
