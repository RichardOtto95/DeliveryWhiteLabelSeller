import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/emtpy_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import '../../core/models/message_model.dart';
import '../../core/models/time_model.dart';
import 'messages_store.dart';
import 'widgets/conversation.dart';
import 'widgets/search_messages.dart';

class MessagesPage extends StatefulWidget {
  @override
  MessagesPageState createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage> {
  final MessagesStore store = Modular.get();
  bool searching = false;
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    store.clearNewMessages();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        store.disposeMessages();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("chats")
                    .where("seller_id",
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .orderBy("updated_at", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CenterLoadCircular();
                  }

                  List<QueryDocumentSnapshot<Map<String, dynamic>>>
                      conversations = snapshot.data!.docs;

                  return Column(
                    children: [
                      SizedBox(
                          height: viewPaddingTop(context) + wXD(60, context)),
                      Stack(
                        children: [
                          Container(
                            width: maxWidth(context),
                            height: wXD(41, context),
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: wXD(29, context)),
                              child: Text(
                                'Minhas conversas',
                                style: textFamily(
                                  context,
                                  fontSize: 17,
                                  color: getColors(context).onBackground,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: wXD(8, context),
                            child: SearchMessages(
                              onChanged: (txt) =>
                                  store.searchMessages(txt, snapshot.data!),
                            ),
                          ),
                        ],
                      ),
                      Listener(
                        onPointerDown: (_) =>
                            FocusScope.of(context).requestFocus(FocusNode()),
                        child: Observer(
                          builder: (context) {
                            // print(
                            //     "store.searchedChats: ${store.searchedChats}");
                            // print(
                            //     "store.searchedMessages: ${store.searchedMessages}");
                            if (store.searchText.isNotEmpty) {
                              if (store.searchedChats == null &&
                                  store.searchedMessages == null) {
                                return CenterLoadCircular(
                                  height: maxHeight(context) -
                                      (viewPaddingTop(context) +
                                          wXD(110, context)),
                                );
                              }
                              if (store.searchedChats!.isEmpty &&
                                  store.searchedMessages!.isEmpty) {
                                return EmptyState(
                                  text:
                                      "Nenhuma mensagem ou conversa encontrada",
                                  icon: Icons.message,
                                  height: maxHeight(context) -
                                      (viewPaddingTop(context) +
                                          wXD(200, context)),
                                );
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (store.searchedChats!.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: wXD(10, context),
                                        top: wXD(10, context),
                                      ),
                                      child: Text(
                                        "Conversas",
                                        style:
                                            textFamily(context, fontSize: 17),
                                      ),
                                    ),
                                  ...store.searchedChats!
                                      .map(
                                        (chat) => Conversation(
                                          conversationData: chat.data()!,
                                        ),
                                      )
                                      .toList(),
                                  if (store.searchedMessages!.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: wXD(10, context),
                                        top: wXD(10, context),
                                      ),
                                      child: Text(
                                        "Mensagens",
                                        style:
                                            textFamily(context, fontSize: 17),
                                      ),
                                    ),
                                  ...store.searchedMessages!.map(
                                    (messageTitle) => MessageSearched(
                                      messageTitle: messageTitle,
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (conversations.isEmpty) {
                              return Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: wXD(90, context)),
                                    Icon(
                                      Icons.email_outlined,
                                      size: wXD(130, context),
                                      color: getColors(context).onSurface,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: wXD(20, context)),
                                      child: Text(
                                        "Você não possui conversas ainda",
                                        style: textFamily(
                                          context,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Column(
                              children: conversations.map((conversation) => Conversation(
                                conversationData: conversation.data()),
                              ).toList(),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: wXD(70, context))
                    ],
                  );
                },
              ),
            ),
            DefaultAppBar(
              'Mensagens',
              onPop: () {
                store.disposeMessages();
                Modular.to.pop();
              },
            )
          ],
        ),
      ),
    );
  }
}

class MessageSearched extends StatelessWidget {
  final SearchMessage messageTitle;

  const MessageSearched({
    Key? key, 
    required this.messageTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // FirebaseFirestore.instance.collection('chats').doc(messageTitle.chatId).update({
        //   "seller_notifications": 0,
        // });
        Modular.to.pushNamed('/messages/chat', arguments: {
          "receiverId": messageTitle.receiverId,
          "receiverCollection": messageTitle.receiverCollection,
          "messageId": messageTitle.message.id,
        });
      },
      child: Container(
        width: maxWidth(context),
        padding: EdgeInsets.symmetric(
          horizontal: wXD(8, context),
          vertical: wXD(10, context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  messageTitle.title,
                  style: textFamily(context, fontSize: 15),
                ),
                Text(
                  Time(messageTitle.message.createdAt!.toDate()).chatTime(),
                  style: textFamily(context, fontSize: 11),
                )
              ],
            ),
            SizedBox(height: wXD(3, context)),
            Text(
              messageTitle.message.text != null
                  ? messageTitle.message.text!
                  : "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textFamily(context, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
