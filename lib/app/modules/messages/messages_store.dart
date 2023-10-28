import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mime/mime.dart';
import 'package:mobx/mobx.dart';
import '../../core/models/agent_model.dart';
import '../../core/models/customer_model.dart';
import '../../core/models/message_model.dart';
import '../../core/models/seller_model.dart';
import '../../shared/widgets/load_circular_overlay.dart';
import '../profile/profile_store.dart';
part 'messages_store.g.dart';

class MessagesStore = _MessagesStoreBase with _$MessagesStore;

abstract class _MessagesStoreBase with Store {
  final ProfileStore profileStore = Modular.get();
  @observable
  String chatId = "";
  @observable
  String receiverName = "";
  @observable
  String recColl = "";
  @observable
  String text = "";
  @observable
  String searchText = "";
  @observable
  Customer? customer;
  @observable
  Seller? seller;
  @observable
  Agent? agent;
  @observable
  TextEditingController? textChatController;
  @observable
  List<String> messageIds = [];
  @observable
  File? cameraImage;
  @observable
  ObservableList<File> images = <File>[].asObservable();
  @observable
  ObservableList<Uint8List> imagesView = <Uint8List>[].asObservable();
  @observable
  int imagesPage = 0;
  // @observable
  // bool imagesBool = false;
  @observable
  List<DocumentSnapshot<Map<String, dynamic>>>? searchedChats;
  @observable
  List<SearchMessage>? searchedMessages;
  @observable
  ObservableList<Message> messages = <Message>[].asObservable();
  @observable
  // ignore: cancel_subscriptions
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? messagesSubscription;

  bool getShowUserData(int i) => messages[i].author != messages[i - 1].author;

  bool getIsAuthor(int i) => messages[i].userType == "SELLER";

  @action
  void clearNewMessages() {
    User? _user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('sellers').doc(_user!.uid).update({
      "new_messages": 0,
    });

    // FirebaseFirestore.instance
    //     .collection("chats")
    //     .where("seller_id", isEqualTo: _user.uid)
    //     .orderBy("updated_at", descending: true)
    //     .get()
    //     .then((value) {
    //   value.docs.forEach((chatDoc) {
    //     chatDoc.reference.update({
    //       "seller_notifications": 0,
    //     });
    //   });
    // });

    profileStore.setProfileEditFromDoc();
  }

  @action
  searchMessages(
    String _text,
    QuerySnapshot<Map<String, dynamic>> chatQue,
  ) async {
    print("searchMessages: $searchMessages");
    searchText = _text;
    if (_text == "") {
      searchedChats = null;
      searchedMessages = null;
      return;
    }

    List<DocumentSnapshot<Map<String, dynamic>>> _chats = [];
    List<SearchMessage> _messages = [];

    for (DocumentSnapshot<Map<String, dynamic>> chatDoc in chatQue.docs) {
      DocumentSnapshot userDoc;
      String receiverId = "";
      String receiverCollection = "";
      if (chatDoc["customer_id"] != null) {
        final cusDoc = await FirebaseFirestore.instance
            .collection("customers")
            .doc(chatDoc["customer_id"])
            .get();
        userDoc = cusDoc;
        receiverCollection = "customers";
        receiverId = chatDoc["customer_id"];
        if (cusDoc["username"]
            .toString()
            .toLowerCase()
            .contains(_text.toLowerCase())) {
          _chats.add(chatDoc);
        }
      } else {
        final emiDoc = await FirebaseFirestore.instance
            .collection("agents")
            .doc(chatDoc["agent_id"])
            .get();
        userDoc = emiDoc;
        receiverCollection = "agents";
        receiverId = chatDoc["agent_id"];
        if (emiDoc["username"]
            .toString()
            .toLowerCase()
            .contains(_text.toLowerCase())) {
          _chats.add(emiDoc);
        }
      }

      final mesQue = await chatDoc.reference.collection("messages").get();

      for (DocumentSnapshot mesDoc in mesQue.docs) {
        if (mesDoc["text"]
            .toString()
            .toLowerCase()
            .contains(_text.toLowerCase())) {
          _messages.add(
            SearchMessage(
              Message.fromDoc(mesDoc),
              mesDoc["user_type"] == "SELLER" ? "Você" : userDoc["username"],
              receiverId,
              receiverCollection,
              chatDoc.id,
            ),
          );
        }
      }
    }

    searchedChats = _chats;
    searchedMessages = _messages;
  }

  @action
  Future<String> loadChatData(
    String receiverId,
    String receiverCollection,
  ) async {
    User user = FirebaseAuth.instance.currentUser!;
    recColl = receiverCollection;
    QuerySnapshot chatQue;
    print("loadChatData step 1");
    DocumentSnapshot recDoc = await FirebaseFirestore.instance
        .collection(receiverCollection)
        .doc(receiverId)
        .get();
    print("loadChatData step 2");
    print("receiverCollection: $receiverCollection");

    if (receiverCollection == "customers") {
      chatQue = await FirebaseFirestore.instance
          .collection("chats")
          .where("seller_id", isEqualTo: user.uid)
          .where("customer_id", isEqualTo: receiverId)
          .get();
      customer = Customer.fromDoc(recDoc);
    } else {
      chatQue = await FirebaseFirestore.instance
          .collection("chats")
          .where("seller_id", isEqualTo: user.uid)
          .where("agent_id", isEqualTo: receiverId)
          .get();
      agent = Agent.fromDoc(recDoc);
    }
    print("loadChatData step 3");

    final selDoc = await FirebaseFirestore.instance
        .collection("sellers")
        .doc(user.uid)
        .get();
    print("loadChatData step 4");

    seller = Seller.fromDoc(selDoc);

    if (chatQue.docs.isEmpty) {
      await createChat(selDoc, recDoc);
      return recDoc["username"];
    }
    print("loadChatData step 5");

    final chatDoc = chatQue.docs.first;

    chatId = chatDoc.id;

    final chatStream = chatDoc.reference
        .collection("messages")
        .orderBy("created_at")
        .snapshots();
    print("loadChatData step 6");

    messagesSubscription = chatStream.listen((event) async {
      event.docChanges.forEach((element) {
        if (!messageIds.contains(element.doc.id) &&
            element.doc["created_at"] != null) {
          messages.insert(messages.length, Message.fromDoc(element.doc));
          messageIds.add(element.doc.id);
        }
      });
    });
    print("loadChatData step 7");
    return recDoc["username"];
  }

  @action
  Future<void> createChat(
    DocumentSnapshot selDoc,
    DocumentSnapshot recDoc,
  ) async {
    User user = FirebaseAuth.instance.currentUser!;
    final chatRef = FirebaseFirestore.instance.collection("chats").doc();

    if (recColl == "customers") {
      await chatRef.set({
        "created_at": FieldValue.serverTimestamp(),
        "customer_id": recDoc.id,
        "seller_id": user.uid,
        "agent_id": null,
        "updated_at": FieldValue.serverTimestamp(),
        "last_update": "",
        "id": chatRef.id,
        "seller_notifications": 0,
        "customer_notifications": 0,
        "agent_notifications": 0,
      });
    } else {
      chatRef.set({
        "created_at": FieldValue.serverTimestamp(),
        "customer_id": null,
        "seller_id": user.uid,
        "agent_id": recDoc.id,
        "updated_at": FieldValue.serverTimestamp(),
        "last_update": "",
        "id": chatRef.id,
        "seller_notifications": 0,
        "customer_notifications": 0,
        "agent_notifications": 0,
      });
    }

    chatId = chatRef.id;

    Stream<QuerySnapshot<Map<String, dynamic>>> messQue =
        chatRef.collection("messages").orderBy("created_at").snapshots();

    messagesSubscription = messQue.listen((event) async {
      event.docChanges.forEach((element) {
        if (!messageIds.contains(element.doc.id) &&
            element.doc["created_at"] != null) {
          messages.insert(messages.length, Message.fromDoc(element.doc));
          messageIds.add(element.doc.id);
        }
      });
    });
  }

  @action
  Future sendMessage() async {
    if (text == "") return;
    textChatController!.clear();
    String _text = text;
    text = "";
    User user = FirebaseAuth.instance.currentUser!;

    DocumentSnapshot<Map<String, dynamic>> chatDoc =
        await FirebaseFirestore.instance.collection("chats").doc(chatId).get();

    final tstRef = chatDoc.reference.collection("messages").doc();

    await tstRef.set({
      "created_at": FieldValue.serverTimestamp(),
      "author": user.uid,
      "text": _text,
      "id": tstRef.id,
      "file": null,
      "file_type": null,
      "user_type": "SELLER",
    });

    // Map<String, dynamic> chatUpd = {
    //   "updated_at": FieldValue.serverTimestamp(),
    //   "last_update": _text,
    // };

    if (recColl == "customers") {
      // chatUpd["customer_notifications"] = chatDoc["customer_notifications"] + 1;
      FirebaseFirestore.instance
          .collection("customers")
          .doc(chatDoc["customer_id"])
          .update({
        "new_messages": FieldValue.increment(1),
      });
      chatDoc.reference.update({
        "customer_notifications": FieldValue.increment(1),
      });
    } else {
      // chatUpd["agent_notifications"] = chatDoc["agent_notifications"] + 1;
      FirebaseFirestore.instance
          .collection("agents")
          .doc(chatDoc["agent_id"])
          .update({
        "new_messages": FieldValue.increment(1),
      });
      chatDoc.reference.update({
        "agent_notifications": FieldValue.increment(1),
      });
    }

    // await chatDoc.reference.update(chatUpd);
    await chatDoc.reference.update({
      "updated_at": FieldValue.serverTimestamp(),
      "last_update": _text,
    });
  }

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

  @action
  Future sendImage(context) async {
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);
    print('sendImage');
    List<Uint8List> _images =
        cameraImage == null ? imagesView : [await cameraImage!.readAsBytes()];
    print('sendImage1');
    DocumentSnapshot<Map<String, dynamic>> chatDoc =
        await FirebaseFirestore.instance.collection("chats").doc(chatId).get();
    print('sendImage2');

    for (int i = 0; i < _images.length; i++) {
      final msgRef = chatDoc.reference.collection("messages").doc();

      User user = FirebaseAuth.instance.currentUser!;

      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('sellers/${user.uid}/chats/${chatDoc.id}/${msgRef.id}');
      UploadTask uploadTask = firebaseStorageRef.putData(_images[i]);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageString = await taskSnapshot.ref.getDownloadURL();

      String? mimeType = lookupMimeType(images[i].path);

      await msgRef.set({
        "created_at": FieldValue.serverTimestamp(),
        "author": user.uid,
        "text": null,
        "id": msgRef.id,
        "file": imageString,
        "file_type": mimeType,
        "user_type": "SELLER",
      });
    }
    print('sendImage3');

    Map<String, dynamic> chatUpd = {
      "updated_at": FieldValue.serverTimestamp(),
      "last_update": "[imagem]",
    };

    if (recColl == "customers") {
      chatUpd["customer_notifications"] =
          chatDoc["customer_notifications"] + _images.length;
      FirebaseFirestore.instance
          .collection("customers")
          .doc(chatDoc["customer_id"])
          .update({
        "new_messages": FieldValue.increment(
            chatDoc["customer_notifications"] + _images.length),
      });
    } else {
      chatUpd["agent_notifications"] =
          chatDoc["agent_notifications"] + _images.length;
      FirebaseFirestore.instance
          .collection("agents")
          .doc(chatDoc["agent_id"])
          .update({
        "new_messages": FieldValue.increment(
            chatDoc["agent_notifications"] + _images.length),
      });
    }

    await chatDoc.reference.update(chatUpd);

    // imagesBool = false;
    cameraImage = null;
    await Future.delayed(Duration(milliseconds: 500), () => images.clear());
    imagesView.clear();
    loadOverlay.remove();
  }

  void disposeChat() {
    // print("dispose do chat");
    textChatController!.dispose();
    if (messagesSubscription != null) messagesSubscription!.cancel();
    if (chatId != "") {
      FirebaseFirestore.instance.collection('chats').doc(chatId).update({
        "seller_notifications": 0,
      });
      chatId = "";
    }
    messagesSubscription = null;
    customer = null;
    agent = null;
    messages.clear();
    messageIds.clear();
  }

  void disposeMessages() {
    searchedChats = null;
    searchedMessages = null;
  }
}
