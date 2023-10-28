import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/core/models/time_model.dart';
import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
import 'package:delivery_seller_white_label/app/modules/profile/widget/opening_hours.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_seller_white_label/app/core/models/type_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:mobx/mobx.dart';
import '../../constants/.info.dart';
import '../../core/models/rating_model.dart';
part 'profile_store.g.dart';

class ProfileStore = _ProfileStoreBase with _$ProfileStore;

abstract class _ProfileStoreBase with Store {
  _ProfileStoreBase() {
    setProfileEditFromDoc();
    createSupport();
  }

  final MainStore mainStore = Modular.get();

  late OverlayEntry loadOverlay;

  @observable
  ObservableMap profileEdit = {}.asObservable();
  @observable
  bool birthdayValidate = false;
  @observable
  bool bankValidate = false;
  @observable
  bool genderValidate = false;
  @observable
  bool avatarValidate = false;
  @observable
  bool bankCodeValidate = false;
  @observable
  bool canBack = true;
  @observable
  bool concluded = false;
  @observable
  TextEditingController textController = TextEditingController();
  @observable
  List<Uint8List> imagesView = [];
  @observable
  List<File> images = [];
  @observable
  List<String>? imagesName = [];
  @observable
  int imagesPage = 0;
  @observable
  List<DocumentSnapshot>? bankDocs;
  @observable
  List<DocumentSnapshot> bankDocsSearch = [];
  @observable
  bool imagesBool = false;
  @observable
  File? cameraImage;
  @observable
  String? orderId;
  @observable
  String? raitingId;
  @observable
  Map<dynamic, dynamic> answerMap = {};
  @observable
  String dropdownValue = "Campo de texto";
  @observable
  List<Map<String, dynamic>> typesArray = [
    {
      "dropdownValue": "Etiqueta",
      "iconData": Icons.abc_outlined,
      "type": "text",
    },
    {
      "dropdownValue": "Campo de texto",
      "iconData": Icons.text_fields_outlined,
      "type": "text-field",
    },
    {
      "dropdownValue": "Área de texto",
      "iconData": Icons.text_fields_outlined,
      "type": "text-area",
    },
    {
      "dropdownValue": "Contador",
      "iconData": Icons.unfold_more,
      "type": "increment",
    },
    {
      "dropdownValue": "Apenas uma opção",
      "iconData": Icons.radio_button_checked,
      "type": "radio-button",
    },
    {
      "dropdownValue": "Mais de uma opção",
      "iconData": Icons.check_box,
      "type": "check-box",
    },
    {
      "dropdownValue": "Seletor",
      "iconData": Icons.keyboard_arrow_down,
      "type": "combo-box",
    },
  ];
  @observable
  List<Map<String, dynamic>> checkboxArray = [
    {
      "index": 0,
      "label": "",
      "value": 0,
      "id": "",
    },
  ];
  @observable
  bool additionalMandatory = false;
  @observable
  String? textFieldHint;
  @observable
  String titleSession = "";
  @observable
  List<Map<String, dynamic>> radiobuttonArray = [
    {
      "index": 0,
      "label": "",
      "value": 0,
      "id": "",
    },
    {
      "index": 1,
      "label": "",
      "value": 0,
      "id": "",
    },
  ];
  @observable
  num incrementValue = 0;
  @observable
  num incrementMinimum = 1;
  @observable
  num incrementMaximum = 10;
  @observable
  num numberMandatoryFields = 0;
  @observable
  ObservableMap<String, dynamic> editAdditional =
      <String, dynamic>{}.asObservable();
  @observable
  bool short = false;
  @observable
  List<Map<String, dynamic>> dropdownArray = [
    {
      "label": "",
      "value": 0,
      "index": 0,
    }
  ];
  @observable
  String sellerOption = "reading";
  @observable
  String customerOption = "edition";
  @observable
  Periods? _periods;
  @observable
  Periods? _periodEdit;

  // variáveis de tela
  @observable
  num count = 0;
  @observable
  int groupValue = 0;
  @observable
  Map<int, bool> checkedMap = {
    0: true,
  };
  @observable
  String alignment = "left";
  @observable
  num fontSize = 18;
  @observable
  bool autoSelected = false;

  @observable
  OverlayEntry? editAdditionalOverlay;
  @observable
  OverlayEntry? editTypeOverlay;
  @observable
  OverlayEntry? additionalLoadOverlay;

  @action
  deleteAdditional(String additionalId) async {
    final User user = FirebaseAuth.instance.currentUser!;
    QuerySnapshot adsQuery = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(user.uid)
        .collection('ads')
        .get();
    for (DocumentSnapshot adsDoc in adsQuery.docs) {
      DocumentSnapshot additionalDoc = await adsDoc.reference
          .collection('additional')
          .doc(additionalId)
          .get();
      if (additionalDoc.exists) {
        adsDoc.reference.collection('additional').doc(additionalId).delete();
        FirebaseFirestore.instance
            .collection('ads')
            .doc(adsDoc.id)
            .collection('additional')
            .doc(additionalId)
            .delete();
      }
    }
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(user.uid)
        .collection('additional')
        .doc(additionalId)
        .update({"status": "DELETED"});
  }

  @action
  Future<bool> getCheckboxList(String additionalId) async {
    final User user = FirebaseAuth.instance.currentUser!;
    bool firstTime = false;
    if (checkboxArray.length == 1) {
      if (checkboxArray[0]["label"] == "") {
        firstTime = true;
      }
    }
    print("firstTime: $firstTime");
    if (firstTime) {
      QuerySnapshot checkboxList = await FirebaseFirestore.instance
          .collection('sellers')
          .doc(user.uid)
          .collection('additional')
          .doc(additionalId)
          .collection("checkbox")
          .where("status", isEqualTo: "ACTIVE")
          .orderBy("index")
          .get();

      for (DocumentSnapshot checkboxDoc in checkboxList.docs) {
        print('checkboxDoc: ${checkboxDoc.data()}');

        try {
          checkboxArray[checkboxDoc['index']] = {
            "index": checkboxDoc['index'],
            "label": checkboxDoc['label'],
            "value": checkboxDoc['value'],
            "id": checkboxDoc['id'],
          };
          // print('success');

        } catch (e) {
          // print('failed');
          // print(e);
          checkboxArray.add({
            "index": checkboxDoc['index'],
            "label": checkboxDoc['label'],
            "value": checkboxDoc['value'],
            "id": checkboxDoc['id'],
          });
        }
        checkedMap.putIfAbsent(checkboxDoc['index'], () => false);
      }
    }
    return true;
  }

  @action
  Future<bool> getRadiobuttonList(String additionalId) async {
    final User user = FirebaseAuth.instance.currentUser!;
    bool firstTime = false;
    if (radiobuttonArray.length == 2) {
      if (radiobuttonArray[0]["label"] == "") {
        firstTime = true;
      }
    }
    print("firstTime: $firstTime");
    if (firstTime) {
      QuerySnapshot radiobuttonList = await FirebaseFirestore.instance
          .collection('sellers')
          .doc(user.uid)
          .collection('additional')
          .doc(additionalId)
          .collection("radiobutton")
          .where("status", isEqualTo: "ACTIVE")
          .orderBy("index")
          .get();

      print("radiobuttonList: ${radiobuttonList.docs.length}");

      for (DocumentSnapshot radiobuttonDoc in radiobuttonList.docs) {
        print('radiobuttonDoc: ${radiobuttonDoc.data()}');

        try {
          radiobuttonArray[radiobuttonDoc['index']] = {
            "index": radiobuttonDoc['index'],
            "label": radiobuttonDoc['label'],
            "value": radiobuttonDoc['value'],
            "id": radiobuttonDoc['id'],
          };
          // print('success');

        } catch (e) {
          // print('failed');
          // print(e);
          radiobuttonArray.add({
            "index": radiobuttonDoc['index'],
            "label": radiobuttonDoc['label'],
            "value": radiobuttonDoc['value'],
            "id": radiobuttonDoc['id'],
          });
        }
      }
    }
    return true;
  }

  @action
  Future<bool> getDropdownList(String additionalId) async {
    final User user = FirebaseAuth.instance.currentUser!;
    bool firstTime = false;
    if (dropdownArray.length == 1) {
      if (dropdownArray[0]["label"] == "") {
        firstTime = true;
      }
    }
    print("firstTime: $firstTime");
    if (firstTime) {
      QuerySnapshot dropdownList = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(user.uid)
        .collection('additional')
        .doc(additionalId)
        .collection("dropdown")
        .where("status", isEqualTo: "ACTIVE")
        .orderBy("index")
        .get();

      for (DocumentSnapshot dropdownDoc in dropdownList.docs) {
        print('checkboxDoc: ${dropdownDoc.data()}');

        try {
          dropdownArray[dropdownDoc['index']] = {
            "index": dropdownDoc['index'],
            "label": dropdownDoc['label'],
            "value": dropdownDoc['value'],
            "id": dropdownDoc['id'],
          };
          // print('success');

        } catch (e) {
          // print('failed');
          // print(e);
          dropdownArray.add({
            "index": dropdownDoc['index'],
            "label": dropdownDoc['label'],
            "value": dropdownDoc['value'],
            "id": dropdownDoc['id'],
          });
        }
      }
    }
    return true;
  }

  @action
  clear() {
    alignment = "left";
    fontSize = 18;
    autoSelected = false;
    checkboxArray = [
      {
        "index": 0,
        "label": "",
        "value": 0,
        "id": "",
      },
    ];
    radiobuttonArray = [
      {
        "index": 0,
        "label": "",
        "value": 0,
        "id": "",
      },
      {
        "index": 1,
        "label": "",
        "value": 0,
        "id": "",
      },
    ];
    additionalMandatory = false;
    dropdownValue = "Campo de texto";
    textFieldHint = null;
    titleSession = "";
    incrementValue = 0;
    incrementMinimum = 1;
    incrementMaximum = 10;
    count = 0;
    groupValue = 0;
    checkedMap = {
      0: true,
    };
    numberMandatoryFields = 0;
    editAdditional.clear();
    short = false;
    dropdownArray = [
      {
        "index": 0,
        "label": "",
        "value": 0,
        "id": "",
      }
    ];
    sellerOption = "reading";
    customerOption = "edition";
  }

  @action
  addRadiobutton() {
    int length = radiobuttonArray.length;
    print('length: $length');
    radiobuttonArray.add({
      "index": length,
      "label": "",
      "value": 0,
      "id": "",
    });
  }

  @action
  removeRadiobutton(int index) {
    radiobuttonArray.removeAt(index);
  }

  @action
  addDropdownItem() {
    int length = dropdownArray.length;
    print('length: $length');
    dropdownArray.add({
      "index": length,
      "label": "",
      "value": 0,
      "id": "",
    });
  }

  @action
  removeDropdownItem(int index) {
    dropdownArray.removeAt(index);
  }

  @action
  addCheckBox() {
    int length = checkboxArray.length;
    print('length: $length');
    checkedMap.putIfAbsent(length, () => false);
    checkboxArray.add({
      "index": length,
      "label": "",
      "value": 0,
      "id": "",
    });
  }

  @action
  removeCheckBox(int index) {
    checkedMap[index] = false;
    // checkboxArray.removeLast();
    checkboxArray.removeAt(index);
  }

  @action
  CrossAxisAlignment getColumnAlignment({String? editAlignment}) {
    if (editAlignment == null) {
      switch (alignment) {
        case "left":
          return CrossAxisAlignment.start;

        case "center":
          return CrossAxisAlignment.center;

        case "right":
          return CrossAxisAlignment.end;

        default:
          return CrossAxisAlignment.start;
      }
    } else {
      switch (editAlignment) {
        case "left":
          return CrossAxisAlignment.start;

        case "center":
          return CrossAxisAlignment.center;

        case "right":
          return CrossAxisAlignment.end;

        default:
          return CrossAxisAlignment.start;
      }
    }
  }

  @action
  MainAxisAlignment getRowAlignment({String? editAlignment}) {
    if (editAlignment == null) {
      switch (alignment) {
        case "left":
          return MainAxisAlignment.start;

        case "center":
          return MainAxisAlignment.center;

        case "right":
          return MainAxisAlignment.end;

        default:
          return MainAxisAlignment.start;
      }
    } else {
      switch (editAlignment) {
        case "left":
          return MainAxisAlignment.start;

        case "center":
          return MainAxisAlignment.center;

        case "right":
          return MainAxisAlignment.end;

        default:
          return MainAxisAlignment.start;
      }
    }
  }

  @action
  Future<void> saveAdditional() async {
    final User _user = FirebaseAuth.instance.currentUser!;
    DocumentReference additionalRef = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_user.uid)
        .collection('additional')
        .add({});
    await additionalRef.update({
      "created_at": FieldValue.serverTimestamp(),
      "status": "INACTIVE",
      "id": additionalRef.id,
      "not_edit": false,
      "title": titleSession,
      "type": null,
      "mandatory": null,
      "hint": null,
      "increment_value": null,
      "increment_minimum": null,
      "increment_maximum": null,
      "number_mandatory_fields": null,
      "short": null,
      "seller_config": sellerOption,
      "customer_config": customerOption,
      "alignment": alignment,
      "font_size": fontSize,
      "auto_selected": autoSelected,
    });

    switch (dropdownValue) {
      case "Mais de uma opção":
        for (var i = 0; i < checkboxArray.length; i++) {
          Map<String, dynamic> checkboxMap = checkboxArray[i];
          DocumentReference checkboxDoc =
              await additionalRef.collection('checkbox').add(checkboxMap);
          await checkboxDoc.update({
            "created_at": FieldValue.serverTimestamp(),
            "id": checkboxDoc.id,
            "status": "ACTIVE",
          });
          // checkboxList.add(checkboxMap[i]);
        }
        if (numberMandatoryFields > checkboxArray.length) {
          numberMandatoryFields = checkboxArray.length;
        }
        await additionalRef.update({
          "status": "ACTIVE",
          "type": "check-box",
          "number_mandatory_fields": numberMandatoryFields,
        });

        // clear();
        // Modular.to.pop();
        break;

      case "Campo de texto":
        await additionalRef.update({
          "status": "ACTIVE",
          "type": "text-field",
          "hint": textFieldHint,
          "mandatory": additionalMandatory,
          "short": short,
        });

        // clear();
        // Modular.to.pop();
        break;

      case "Contador":
        if (incrementMinimum > incrementMaximum) {
          incrementMinimum = incrementMaximum - 1;
        }
        await additionalRef.update({
          "status": "ACTIVE",
          "type": "increment",
          "increment_value": incrementValue,
          "increment_minimum": incrementMinimum,
          "increment_maximum": incrementMaximum,
        });

        // clear();
        // Modular.to.pop();
        break;

      case "Apenas uma opção":
        for (var i = 0; i < radiobuttonArray.length; i++) {
          Map<String, dynamic> radiobuttonMap = radiobuttonArray[i];
          DocumentReference radiobuttonDoc =
              await additionalRef.collection('radiobutton').add(radiobuttonMap);
          await radiobuttonDoc.update({
            "created_at": FieldValue.serverTimestamp(),
            "id": radiobuttonDoc.id,
            "status": "ACTIVE",
          });
          // checkboxList.add(checkboxMap[i]);
        }
        await additionalRef.update({
          "status": "ACTIVE",
          "type": "radio-button",
        });

        // clear();
        // Modular.to.pop();
        break;

      case "Etiqueta":
        await additionalRef.update({
          "status": "ACTIVE",
          "type": "text",
        });
        break;

      case "Área de texto":
        await additionalRef.update({
          "status": "ACTIVE",
          "type": "text-area",
          "hint": textFieldHint,
          "mandatory": additionalMandatory,
        });
        break;

      case "Seletor":
        for (var i = 0; i < dropdownArray.length; i++) {
          Map<String, dynamic> dropdownMap = dropdownArray[i];
          DocumentReference dropdownDoc =
              await additionalRef.collection('dropdown').add(dropdownMap);
          await dropdownDoc.update({
            "created_at": FieldValue.serverTimestamp(),
            "id": dropdownDoc.id,
            "status": "ACTIVE",
          });
        }
        await additionalRef.update({
          "status": "ACTIVE",
          "type": "combo-box",
        });
        break;

      default:
        break;
    }
    clear();
    Modular.to.pop();
  }

  @action
  saveEditAdditional() async {
    final User _user = FirebaseAuth.instance.currentUser!;
    // DocumentReference additionalRef = FirebaseFirestore.instance.collection('sellers').doc(_user.uid).collection('additional').doc(editAdditional['id']);
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_user.uid)
        .collection('additional')
        .doc(editAdditional['id'])
        .update(editAdditional.cast());
    DocumentSnapshot additionalDoc = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_user.uid)
        .collection('additional')
        .doc(editAdditional['id'])
        .get();
    switch (additionalDoc['type']) {
      case "check-box":
        QuerySnapshot checkboxQuery = await additionalDoc.reference
            .collection('checkbox')
            .where('status', isEqualTo: "ACTIVE")
            .orderBy("index")
            .get();
        Map checkboxMap = {};
        for (var i = 0; i < checkboxArray.length; i++) {
          Map<String, dynamic> element = checkboxArray[i];
          checkboxMap.putIfAbsent(element['id'], () => element);
          if (element['id'] == "") {
            DocumentReference checkboxRef = await additionalDoc.reference
                .collection("checkbox")
                .add(element);

            await checkboxRef.update({
              "created_at": FieldValue.serverTimestamp(),
              "id": checkboxRef.id,
              "status": "ACTIVE",
            });
          }
        }

        for (var i = 0; i < checkboxQuery.docs.length; i++) {
          DocumentSnapshot checkboxDoc = checkboxQuery.docs[i];
          if (checkboxMap.containsKey(checkboxDoc.id)) {
            await checkboxDoc.reference.update(checkboxMap[checkboxDoc.id]);
          } else {
            await checkboxDoc.reference.update({
              "status": "DELETED",
            });
          }
        }

        num numberMandatoryFields =
            editAdditional['number_mandatory_fields'] != null
                ? editAdditional['number_mandatory_fields']
                : 0;
        if (numberMandatoryFields > checkboxArray.length) {
          numberMandatoryFields = checkboxArray.length;

          await additionalDoc.reference.update({
            "number_mandatory_fields": numberMandatoryFields,
          });
        }

        break;

      case "radio-button":
        QuerySnapshot radiobuttonQuery = await additionalDoc.reference
            .collection('radiobutton')
            .where('status', isEqualTo: "ACTIVE")
            .orderBy("index")
            .get();
        Map radiobuttonMap = {};
        for (var i = 0; i < radiobuttonArray.length; i++) {
          Map<String, dynamic> element = radiobuttonArray[i];
          radiobuttonMap.putIfAbsent(element['id'], () => element);
          if (element['id'] == "") {
            DocumentReference radiobuttonRef = await additionalDoc.reference
                .collection("radiobutton")
                .add(element);

            await radiobuttonRef.update({
              "created_at": FieldValue.serverTimestamp(),
              "id": radiobuttonRef.id,
              "status": "ACTIVE",
            });
          }
        }

        for (var i = 0; i < radiobuttonQuery.docs.length; i++) {
          DocumentSnapshot radiobuttonDoc = radiobuttonQuery.docs[i];
          if (radiobuttonMap.containsKey(radiobuttonDoc.id)) {
            await radiobuttonDoc.reference
                .update(radiobuttonMap[radiobuttonDoc.id]);
          } else {
            await radiobuttonDoc.reference.update({
              "status": "DELETED",
            });
          }
        }
        break;

      case "combo-box":
        QuerySnapshot dropdownQuery = await additionalDoc.reference
            .collection('dropdown')
            .where('status', isEqualTo: "ACTIVE")
            .orderBy("index")
            .get();
        Map dropdownMap = {};
        for (var i = 0; i < dropdownArray.length; i++) {
          Map<String, dynamic> element = dropdownArray[i];
          dropdownMap.putIfAbsent(element['id'], () => element);
          if (element['id'] == "") {
            DocumentReference dropdownRef = await additionalDoc.reference
                .collection("dropdown")
                .add(element);

            await dropdownRef.update({
              "created_at": FieldValue.serverTimestamp(),
              "id": dropdownRef.id,
              "status": "ACTIVE",
            });
          }
        }

        for (var i = 0; i < dropdownQuery.docs.length; i++) {
          DocumentSnapshot dropdownDoc = dropdownQuery.docs[i];
          if (dropdownMap.containsKey(dropdownDoc.id)) {
            await dropdownDoc.reference.update(dropdownMap[dropdownDoc.id]);
          } else {
            await dropdownDoc.reference.update({
              "status": "DELETED",
            });
          }
        }
        break;

      default:
        break;
    }
    Modular.to.pop();
    clear();
  }

  @action
  setCanBack(_canBack) => canBack = _canBack;
  @action
  bool getCanBack() => canBack;

  @action
  setConcluded(bool _concluded) => concluded = _concluded;

  // @action
  // setAnswered(bool _answered) => answered = _answered;

  Future<void> getBanks() async {
    bankDocs = (await FirebaseFirestore.instance
            .collection("info")
            .doc(infoId)
            .collection("banks")
            .orderBy("label")
            .get())
        .docs;
  }

  void searchBank(String? txt) {
    bankDocsSearch.clear();
    if (txt == null || txt == "") {
      return;
    }
    if (bankDocs != null) {
      List<DocumentSnapshot> search = [];
      for (final bank in bankDocs!) {
        if (bank.get("label").toString().toLowerCase().contains(txt)) {
          search.add(bank);
        }
      }
      bankDocsSearch = search;
    }
  }

  Future<void> savePeriod(context, Periods period) async {
    if (period.start == null) {
      showToast("Defina a hora inicial", error: true);
      return;
    } else if (period.end == null) {
      showToast("Defina a hora final", error: true);
      return;
    } else if (period.weekDays == "") {
      showToast("Selecione ao menos um dia da semana", error: true);
      return;
    }
    _periods = period;
    profileEdit["opening_hours"] = await resetOpeningHours(period);

    // OverlayEntry loadOverlay;

    // loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());

    // Overlay.of(context)!.insert(loadOverlay);

    // final perRef = FirebaseFirestore.instance
    //     .collection("sellers")
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .collection("periods")
    //     .doc();

    // period.id = perRef.id;

    // List stringLista = period.weekDays.characters.toList();

    // stringLista.sort((a, b) => a.compareTo(b));

    // period.weekDays = stringLista.join();

    // period.createdAt = FieldValue.serverTimestamp();

    // await perRef.set(period.toJson());

    // profileEdit["opening_hours"] = await resetOpeningHours(null);

    // loadOverlay.remove();

    Modular.to.pop();
  }

  /// O campo weekDays deve estar em ordem crescente
  @action
  getPeriodString(Periods period) {
    final List stringLista = period.weekDays.characters.toList();

    stringLista.sort();

    period.weekDays = stringLista.join();

    String str = "";

    int? freIndSta;
    int? freIndEnd;

    for (int i = 0; i < period.weekDays.length; i++) {
      if (i + 1 != period.weekDays.length) {
        if (int.parse(stringLista[i]) + 1 == int.parse(stringLista[i + 1]) &&
            freIndSta == null) {
          freIndSta = int.parse(stringLista[i]);
        } else if (int.parse(stringLista[i]) + 1 !=
                (int.parse(stringLista[i + 1])) &&
            freIndEnd == null &&
            freIndSta != null) {
          freIndEnd = int.parse(stringLista[i]);
        }
      } else {
        freIndEnd = int.parse(stringLista[i]);
      }

      bool isLast =
          i == period.weekDays.length - 1 && period.weekDays.length > 1;

      if (freIndSta == null) {
        str =
            "${str != "" ? isLast ? '$str e ' : '$str, ' : ''}${Time.shortDay(int.parse(stringLista[i]), capitalize: true)}";
      }

      if (freIndSta != null && freIndEnd != null) {
        int dif = freIndEnd - freIndSta;
        str =
            "${str != "" ? isLast && dif > 1 ? '$str e ' : '$str, ' : ''}${Time.shortDay(freIndSta, capitalize: true)}${dif > 1 ? ' à ' : isLast ? ' e ' : ', '}${Time.shortDay(freIndEnd, capitalize: true)}";

        freIndSta = null;
        freIndEnd = null;
      }
      // print(
      //     "i: $i weekDay: ${period.weekDays[i]}, stringLista: ${stringLista[i]}, str: $str, freIndSta: $freIndSta, freIndEnd: $freIndEnd");
    }

    str = str +
        ", das ${Time(period.start!).hour()} às ${Time(period.end!).hour()}";

    return str;
  }

  @action
  Future<String> resetOpeningHours(Periods? period) async {
    final _user = FirebaseAuth.instance.currentUser!;

    final selRef =
        FirebaseFirestore.instance.collection("sellers").doc(_user.uid);

    final periods = await selRef
        .collection("periods")
        .where("status", isEqualTo: "ACTIVE")
        .orderBy("created_at")
        .get();

    String str = "";

    for (DocumentSnapshot perDoc in periods.docs) {
      Periods _period = Periods.fromDoc(perDoc);
      if (str == "") {
        str = getPeriodString(_period);
      } else {
        str = "$str, ${getPeriodString(_period)}";
      }
    }

    if (period != null) {
      str = "${str != "" ? "$str. " : ""}${getPeriodString(period)}.";
    } else {
      str = "$str.";
    }

    await selRef.update({"opening_hours": str});

    return str;
  }

  Future<void> editPeriod(period, context) async {
    if (period.weekDays == "") {
      showToast("Selecione ao menos um dia da semana", error: true);
      return;
    }

    // OverlayEntry loadOverlay;

    // loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());

    // Overlay.of(context)!.insert(loadOverlay);

    _periodEdit = period;
    profileEdit["opening_hours"] = await resetOpeningHours(period);
    // final perRef = FirebaseFirestore.instance
    //     .collection("sellers")
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .collection("periods")
    //     .doc(period.id);

    // await perRef.update(period.toJson());

    // profileEdit["opening_hours"] = await resetOpeningHours(null);

    // loadOverlay.remove();

    Modular.to.pop();
  }

  Future<void> deletePeriod(period, context) async {
    if (period.weekDays == "") {
      showToast("Selecione ao menos um dia da semana", error: true);
      return;
    }

    OverlayEntry loadOverlay;

    loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());

    Overlay.of(context)!.insert(loadOverlay);

    final perRef = FirebaseFirestore.instance
        .collection("sellers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("periods")
        .doc(period.id);

    await perRef.update({"status": "DELETED"});

    profileEdit["opening_hours"] = await resetOpeningHours(null);

    loadOverlay.remove();

    Modular.to.pop();
  }

  @action
  Future<void> clearNewRatings() async {
    print('clearNewRatings');
    User? _user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_user!.uid)
        .update({
      "new_ratings": 0,
    });
    setProfileEditFromDoc();
  }

  @action
  Future<void> clearNewQuestions() async {
    print('clearNewQuestions');
    User? _user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_user!.uid)
        .update({
      "new_questions": 0,
    });
    setProfileEditFromDoc();
  }

  @action
  Future<void> clearNewSupportMessages() async {
    print('clearNewSupportMessages');
    User? _user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_user!.uid)
        .update({
      "new_support_messages": 0,
    });
    setProfileEditFromDoc();
  }

  @action
  Future<void> pickAvatar() async {
    final User? _userAuth = FirebaseAuth.instance.currentUser;
    profileEdit['avatar'] = '';

    XFile? _imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_imageFile != null) {
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('sellers/${_userAuth!.uid}/avatar/${_imageFile.name}');

      Uint8List uint8list = await _imageFile.readAsBytes();

      UploadTask uploadTask = firebaseStorageRef.putData(uint8list);

      TaskSnapshot taskSnapshot = await uploadTask;

      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      profileEdit['avatar'] = downloadURL;
      avatarValidate = false;
    }
  }

  @action
  Future<void> saveProfile(context) async {
    final User? _userAuth = FirebaseAuth.instance.currentUser;
    loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);

    if(_periods != null){
      final perRef = FirebaseFirestore.instance
        .collection("sellers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("periods")
        .doc();

      _periods!.id = perRef.id;

      List stringLista = _periods!.weekDays.characters.toList();

      stringLista.sort((a, b) => a.compareTo(b));

      _periods!.weekDays = stringLista.join();

      _periods!.createdAt = FieldValue.serverTimestamp();

      await perRef.set(_periods!.toJson());

      // profileEdit["opening_hours"] = await resetOpeningHours(_periods);
    }

    if(_periodEdit != null){
      final perRef = FirebaseFirestore.instance
        .collection("sellers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("periods")
        .doc(_periodEdit!.id);

      await perRef.update(_periodEdit!.toJson());

      // profileEdit["opening_hours"] = await resetOpeningHours(_periodEdit);
    }

    Map<String, dynamic> _profileMap = profileEdit.cast();
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_userAuth!.uid)
        .update(_profileMap);

        // OverlayEntry loadOverlay;

    // loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());

    // Overlay.of(context)!.insert(loadOverlay);


    // loadOverlay.remove();

    loadOverlay.remove();
    Modular.to.pop();
  }

  @action
  bool getValidate() {
    if (profileEdit['birthday'] == null) {
      birthdayValidate = true;
    } else {
      birthdayValidate = false;
    }

    if (profileEdit['bank'] == null || profileEdit['bank'] == '') {
      bankValidate = true;
    } else {
      bankValidate = false;
    }

    if (profileEdit['gender'] == null || profileEdit['gender'] == '') {
      genderValidate = true;
    } else {
      genderValidate = false;
    }

    if (profileEdit['avatar'] == null || profileEdit['avatar'] == '') {
      avatarValidate = true;
    } else {
      avatarValidate = false;
    }

    if (profileEdit['bank'] == null || profileEdit['bank'] == '') {
      bankCodeValidate = true;
    } else {
      bankCodeValidate = false;
    }

    if (profileEdit["agency_digit"] == null ||
        profileEdit["account_digit"] == null ||
        profileEdit["agency_digit"] == "" ||
        profileEdit["account_digit"] == "") {
      return false;
    }

    return !birthdayValidate &&
        !bankValidate &&
        !genderValidate &&
        !avatarValidate &&
        !bankCodeValidate;
  }

  @action
  changeNotificationEnabled(bool change) async {
    print('changeNotificationEnabled $change');
    profileEdit['notification_enabled'] = change;
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(profileEdit['id'])
        .update({'notification_enabled': change});
  }

  @action
  setProfileEditFromDoc() async {
    final User? _userAuth = FirebaseAuth.instance.currentUser;

    DocumentSnapshot _ds = await FirebaseFirestore.instance
        .collection("sellers")
        .doc(_userAuth?.uid)
        .get();
    Map<String, dynamic> map = _ds.data() as Map<String, dynamic>;
    map['linked_to_cnpj'] = map['linked_to_cnpj'] ?? false;
    map['savings_account'] = map['savings_account'] ?? false;
    map['is_juridic_person'] = map['is_juridic_person'] ?? false;
    ObservableMap<String, dynamic> sellerMap = map.asObservable();
    profileEdit = sellerMap;
    // print("Seller Map: $sellerMap");
    // print("Username: ${sellerMap['username']}");
  }

  @action
  setBirthday(context, Function callBack) async {
    DateTime? _birthday;
    // await selectDate(context,
    //     initialDate: profileEdit['birthday'] != null
    //         ? profileEdit['birthday'].toDate()
    //         : DateTime.now());
    await pickDate(
      context,
      onConfirm: (_date) {
        _birthday = _date;
        print('setBirthday: $_birthday - ${profileEdit['birthday']}');
        if (_birthday != null && _birthday != profileEdit['birthday']) {
          profileEdit['birthday'] = Timestamp.fromDate(_birthday!);
          birthdayValidate = false;
          callBack();
        }
      },
      initialDate: profileEdit['birthday'] != null
          ? profileEdit['birthday'].toDate()
          : DateTime.now(),
    );
  }

  Future<void> setTokenLogout() async {
    if(!kIsWeb){
      final User? _userAuth = FirebaseAuth.instance.currentUser;
      DocumentSnapshot _user = await FirebaseFirestore.instance
          .collection('sellers')
          .doc(_userAuth!.uid)
          .get();

      String? token = await FirebaseMessaging.instance.getToken();
      print('user token: $token');
      _user.reference.update({'token_id': FieldValue.arrayRemove([token])});      
    }
  }

  @action
  Future<void> answerAvaliation(
      Map<dynamic, dynamic> mapAnswer, context) async {
    User? _user = FirebaseAuth.instance.currentUser;
    print('answerAvaliation $mapAnswer');
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);
    canBack = false;
    List<Object> rating = [];
    mapAnswer.forEach((key, value) {
      rating.add({
        "ads_id": key,
        "answer": value,
      });
    });

    await cloudFunction(function: "answerAvaliation", object: {
      "rating": rating,
      "orderId": orderId,
      // "sellerId": 'dlEJdrp6q9YF6uphwaS5zRtQ4Yi2',
      "sellerId": _user!.uid,
    });

    Modular.to.pop();
    loadOverlay.remove();
    answerMap = {};
    canBack = true;
  }

  @action
  Future answerQuestion(String questionId, String answer, context) async {
    final User? _userAuth = FirebaseAuth.instance.currentUser;

    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);
    canBack = false;

    await cloudFunction(function: "toAnswer", object: {
      "questionId": questionId,
      "answer": answer,
      "sellerId": _userAuth!.uid,
    });

    loadOverlay.remove();
    canBack = true;
  }

  @action
  Future<void> createSupport() async {
    User? _user = FirebaseAuth.instance.currentUser;

    QuerySnapshot supportQuery = await FirebaseFirestore.instance
        .collection("supports")
        .where("user_id", isEqualTo: _user!.uid)
        .where("user_collection", isEqualTo: "SELLERS")
        .get();

    // print("create support: ${supportQuery.docs.isEmpty}");

    if (supportQuery.docs.isEmpty) {
      DocumentReference suporteRef =
          await FirebaseFirestore.instance.collection("supports").add({
        "user_id": _user.uid,
        "id": null,
        "created_at": FieldValue.serverTimestamp(),
        "updated_at": FieldValue.serverTimestamp(),
        "support_notification": 0,
        "last_update": "",
        "user_collection": "SELLERS",
      });
      await suporteRef.update({"id": suporteRef.id});
    }
  }

  @action
  Future<void> sendSupportMessage() async {
    if (textController.text == "") return;
    User? _user = FirebaseAuth.instance.currentUser;
    QuerySnapshot supportQuery = await FirebaseFirestore.instance
        .collection("supports")
        .where("user_id", isEqualTo: _user!.uid)
        .where("user_collection", isEqualTo: "SELLERS")
        .get();

    // print('supportQuery.docs.isNotEmpty: ${supportQuery.docs.isNotEmpty}');
    if (supportQuery.docs.isNotEmpty) {
      DocumentReference messageRef =
          await supportQuery.docs.first.reference.collection("messages").add({
        "id": null,
        "author": _user.uid,
        "text": textController.text,
        "created_at": FieldValue.serverTimestamp(),
        "file": null,
        "file_type": null,
      });

      await messageRef.update({
        "id": messageRef.id,
      });

      await supportQuery.docs.first.reference.update({
        "last_update": textController.text,
        "support_notification": FieldValue.increment(1),
      });
    }
    textController.clear();
  }

  @action
  Future sendImage(context) async {
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);

    User? _user = FirebaseAuth.instance.currentUser;

    List<File> _images = cameraImage == null ? images : [cameraImage!];

    QuerySnapshot supportQuery = await FirebaseFirestore.instance
        .collection("supports")
        .where("user_id", isEqualTo: _user!.uid)
        .where("user_collection", isEqualTo: "SELLERS")
        .get();

    if (supportQuery.docs.isNotEmpty) {
      DocumentSnapshot supportDoc = supportQuery.docs.first;
      for (int i = 0; i < _images.length; i++) {
        File _imageFile = _images[i];
        String _imageName = imagesName![i];

        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('supports/${_user.uid}/images/$_imageName');

        UploadTask uploadTask = firebaseStorageRef.putData(imagesView[i]);

        TaskSnapshot taskSnapshot = await uploadTask;

        String imageString = await taskSnapshot.ref.getDownloadURL();

        String? mimeType = lookupMimeType(_imageFile.path);

        DocumentReference messageRef =
            await supportDoc.reference.collection('messages').add({
          "created_at": FieldValue.serverTimestamp(),
          "author": _user.uid,
          "text": null,
          "id": null,
          "file": imageString,
          "file_type": mimeType,
        });

        await messageRef.update({
          "id": messageRef.id,
        });
      }

      Map<String, dynamic> chatUpd = {
        "updated_at": FieldValue.serverTimestamp(),
        "last_update": "[imagem]",
        "support_notification": FieldValue.increment(1 + _images.length),
      };

      await supportDoc.reference.update(chatUpd);
    }

    imagesBool = false;
    cameraImage = null;
    await Future.delayed(Duration(milliseconds: 500), () => images.clear());
    imagesView.clear();
    loadOverlay.remove();
  }

  @action
  Future<Map<String, dynamic>> getAdsDoc(RatingModel ratingModel) async {
    DocumentSnapshot orderDoc = await FirebaseFirestore.instance
        .collection("orders")
        .doc(ratingModel.orderId)
        .get();
    QuerySnapshot adsQuery = await orderDoc.reference.collection("ads").get();
    DocumentSnapshot firstAdsDoc = await FirebaseFirestore.instance
        .collection('ads')
        .doc(adsQuery.docs.first.id)
        .get();
    num ratings = 0;
    List<Map<String, dynamic>> ratingModelList = [
      {
        'ads_id': null,
        'model': ratingModel,
      },
    ];
    for (int i = 0; i < adsQuery.docs.length; i++) {
      DocumentSnapshot adsDocx = adsQuery.docs[i];
      DocumentSnapshot adsDoc = await FirebaseFirestore.instance
          .collection("ads")
          .doc(adsDocx.id)
          .get();
      QuerySnapshot ratingQuery = await adsDoc.reference
          .collection("ratings")
          .where("order_id", isEqualTo: ratingModel.orderId)
          .get();
      DocumentSnapshot ratingDoc = ratingQuery.docs.first;
      ratingModelList.add(
        {
          'ads_id': adsDoc.id,
          'model': RatingModel.fromDocSnapshot(ratingDoc),
        },
      );
      ratings += ratingDoc['rating'];
    }
    ;

    num average = (ratings + ratingModel.rating!) / 2;
    return {
      "firstAdsDoc": firstAdsDoc,
      "average": average,
      "ratingModelList": ratingModelList,
    };
  }

  // Types Functions

  Future<void> createType(String txt) async {
    final ref = await FirebaseFirestore.instance.collection("types").doc();

    await ref.set({
      "created_at": FieldValue.serverTimestamp(),
      "type": txt,
      "id": ref.id,
      "status": "ACTIVE"
    });
  }

  Future<void> editType(Type type) async => await FirebaseFirestore.instance
      .collection("types")
      .doc(type.id)
      .update({"type": type.type});

  Future<void> deleteType(Type type) async => await FirebaseFirestore.instance
      .collection("types")
      .doc(type.id)
      .update({"status": "DELETED"});

  @action
  void removeImage() {
    images.removeAt(imagesPage);
    imagesView.removeAt(imagesPage);
    if (imagesPage == images.length && imagesPage != 0) {
      imagesPage = images.length - 1;
    }
    print(imagesPage);
  }

  @action
  void cancelImages() {
    images.clear();
    imagesView.clear();
    imagesPage = 0;
    cameraImage = null;
  }
}
