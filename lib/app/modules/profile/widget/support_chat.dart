import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../core/models/message_model.dart';
import '../../../shared/color_theme.dart';
import '../../../shared/utilities.dart';
import '../../../shared/widgets/center_load_circular.dart';
import '../../../shared/widgets/default_app_bar.dart';
import '../../../shared/widgets/floating_circle_button.dart';
import '../../main/main_store.dart';
import '../../messages/widgets/message.dart';
import '../../messages/widgets/message_bar.dart';
import '../profile_store.dart';

class SupportChat extends StatefulWidget {
  @override
  State<SupportChat> createState() => _SupportChatState();
}

class _SupportChatState extends State<SupportChat> {
  final MainStore mainStore = Modular.get();
  final ProfileStore store = Modular.get();
  final User? _user = FirebaseAuth.instance.currentUser;
  final PageController pageController = PageController();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (store.imagesBool || store.cameraImage != null) {
          store.images.clear();
          store.imagesBool = false;
          store.cameraImage = null;
          return false;
        }
        return true;
      },
      child: Listener(
        onPointerDown: (_) => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          body: Observer(builder: (context) {
            print("store.cameraImage: ${store.cameraImage}");
            return Stack(
              children: [
                SizedBox(
                  height: maxHeight(context),
                  width: maxWidth(context),
                  child: SingleChildScrollView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(vertical: wXD(80, context)),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("supports")
                          .where("user_id", isEqualTo: _user!.uid)
                          .where("user_collection", isEqualTo: "SELLERS")
                          .snapshots(),
                      builder: (context, supportSnap) {
                        if (!supportSnap.hasData) {
                          return CenterLoadCircular();
                        }

                        if (supportSnap.data!.docs.isEmpty) {
                          return Container();
                        }

                        final supportDoc = supportSnap.data!.docs.first;

                        return StreamBuilder<
                            QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("supports")
                              .doc(supportDoc.id)
                              .collection("messages")
                              .orderBy("created_at")
                              .snapshots(),
                          builder: (context, messagesSnap) {
                            if (!messagesSnap.hasData) {
                              return CenterLoadCircular();
                            }
                            List<Message> messages = [];
                            messagesSnap.data!.docs.forEach((messageDoc) {
                              messages.add(Message.fromDoc(messageDoc));
                            });

                            return Column(
                              children: List.generate(messages.length, (index) {
                                Message _message = messages[index];
                                Message? _previousMessage;
                                if (index > 0) {
                                  _previousMessage = messages[index - 1];
                                }

                                print('_message: ${_message.createdAt}');

                                return MessageWidget(
                                  isAuthor: _message.author == _user!.uid,
                                  rightName: store.profileEdit["username"],
                                  leftName: "Suporte",
                                  rightAvatar: store.profileEdit["avatar"],
                                  leftAvatar: null,
                                  messageData: _message,
                                  showUserData: index == 0
                                      ? true
                                      : _message.author !=
                                          _previousMessage!.author,
                                  messageBold: false,
                                );
                              }),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                DefaultAppBar('Suporte'),
                Positioned(
                  bottom: 0,
                  child: MessageBar(
                    focus: focusNode,
                    controller: store.textController,
                    onSend: () => store.sendSupportMessage(),
                    onEditingComplete: () => store.sendSupportMessage(),
                    takePictures: () async {
                      List? response = await pickMultiImageWithName();
                      if (response != null) {
                        // print('response: ${response[0]}');
                        // print('response: ${response[1]}');
                        // List<File> images = response[0];
                        store.images = response[0];
                        store.imagesName = response[1];
                        store.imagesBool = response[0].isNotEmpty;
                      }
                    },
                    getCameraImage: () async {
                      List? response = await pickCameraImageWithName();
                      if (response != null) {
                        store.cameraImage = response[0];
                        store.imagesName = response[1];
                        store.imagesView = response[2];
                        store.sendImage(context);
                      }
                    },
                  ),
                ),
                Visibility(
                  visible: store.images.isNotEmpty,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        color: getColors(context).surface,
                        height: maxHeight(context),
                        width: maxWidth(context),
                        child: Container(
                          height: wXD(800, context),
                          width: maxWidth(context),
                          margin:
                              EdgeInsets.symmetric(vertical: wXD(58, context)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                          ),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            child: Observer(builder: (context) {
                              return PageView(
                                children: List.generate(
                                  store.imagesView.length,
                                  (index) => Image.memory(
                                    store.imagesView[index],
                                  ),
                                ),
                                onPageChanged: (page) =>
                                    store.imagesPage = page,
                                controller: pageController,
                              );
                            }),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: SizedBox(
                          width: maxWidth(context),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  right: wXD(10, context),
                                  bottom: wXD(10, context),
                                ),
                                alignment: Alignment.centerRight,
                                child: FloatingCircleButton(
                                  onTap: () => store.sendImage(context),
                                  icon: Icons.send_outlined,
                                  iconColor: getColors(context).primary,
                                  size: wXD(55, context),
                                  iconSize: 30,
                                ),
                              ),
                              Observer(
                                builder: (context) {
                                  return SizedBox(
                                    width: maxWidth(context),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          store.images.length,
                                          (index) => InkWell(
                                            onTap: () => pageController
                                                .jumpToPage(index),
                                            child: Container(
                                              height: wXD(70, context),
                                              width: wXD(70, context),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                width: 2,
                                                color: index == store.imagesPage
                                                    ? getColors(context).primary
                                                    : Colors.transparent,
                                              )),
                                              child: Image.memory(
                                                store.imagesView[index],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: wXD(10, context) +
                            MediaQuery.of(context).viewPadding.top,
                        child: Container(
                          width: maxWidth(context),
                          padding: EdgeInsets.symmetric(
                              horizontal: wXD(10, context)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  store.cancelImages();
                                },
                                icon: Icon(Icons.close_rounded,
                                    size: wXD(30, context)),
                              ),
                              IconButton(
                                onPressed: () => store.removeImage(),
                                icon: Icon(Icons.delete_outline_rounded,
                                    size: wXD(30, context)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
