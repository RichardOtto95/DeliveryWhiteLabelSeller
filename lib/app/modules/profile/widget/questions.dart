import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
import 'package:delivery_seller_white_label/app/modules/product/widgets/question.dart';

import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/emtpy_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../profile_store.dart';
import 'questions_app_bar.dart';

class Questions extends StatefulWidget {
  const Questions({Key? key}) : super(key: key);

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  final ProfileStore store = Modular.get();

  final MainStore mainStore = Modular.get();

  final User? _userAuth = FirebaseAuth.instance.currentUser;

  final ScrollController scrollController = ScrollController();

  int limit = 10;

  double lastExtent = 0;

  @override
  void initState() {
    store.clearNewQuestions();
    scrollController.addListener(() {
      if (scrollController.offset >
              (scrollController.position.maxScrollExtent - 200) &&
          lastExtent < scrollController.position.maxScrollExtent) {
        setState(() {
          limit += 10;
          lastExtent = scrollController.position.maxScrollExtent;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }

  bool answered = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!store.getCanBack()) {
          return false;
        }
        await FirebaseFirestore.instance
            .collection("sellers")
            .doc(_userAuth!.uid)
            .update({"new_questions": 0});
        store.setProfileEditFromDoc();
        return true;
      },
      child: Listener(
        onPointerDown: (_) => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: getStream(),
                  builder: (context, snapshot) {
                    print('snapshot.hasData: ${snapshot.hasData}');
                    if (!snapshot.hasData) return Container();
                    // if (!snapshot.hasData) return LoadCircularOverlay();
                    if (snapshot.data!.docs.isEmpty) {
                      return EmptyState(
                        text: "Sem perguntas ainda",
                        icon: Icons.question_answer_outlined,
                        height: maxHeight(context),
                      );
                      // return Container(
                      //   height: maxHeight(context),
                      //   width: maxWidth(context),
                      //   alignment: Alignment.center,
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Icon(
                      //         Icons.question_answer_outlined,
                      //         size: wXD(200, context),
                      //         color: getColors(context).primary,
                      //       ),
                      //       Text("Sem perguntas para serem exibidas"),
                      //     ],
                      //   ),
                      // );
                    }
                    print(
                        'snapshot.data!.docs.length: ${snapshot.data!.docs.length}');
                    return SingleChildScrollView(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(
                          vertical: viewPaddingTop(context) + wXD(80, context)),
                      child: Column(
                        children: snapshot.data!.docs
                            .map((questionDoc) => QuestionToAnswer(
                                  adsId: questionDoc['ads_id'],
                                  answer: questionDoc['answer'],
                                  answeredAt: questionDoc['answered_at'],
                                  createdAt: questionDoc['created_at'],
                                  onTap: (txt) {
                                    print("answer: $txt");
                                    store.answerQuestion(
                                        questionDoc.id, txt, context);
                                  },
                                  question: questionDoc['question'],
                                  username: questionDoc['author_name'],
                                ))
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
              QuestionsAppBar(
                onTap: (bool value) {
                  if (value != answered) {
                    setState(() {
                      limit = 10;
                      lastExtent = 0;
                      answered = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    print('answered: $answered');

    if (answered) {
      return FirebaseFirestore.instance
          .collection("sellers")
          .doc(_userAuth!.uid)
          .collection("questions")
          .where("answered", isEqualTo: true)
          .orderBy("created_at", descending: true)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection("sellers")
          .doc(_userAuth!.uid)
          .collection("questions")
          .where("answered", isEqualTo: false)
          .orderBy("created_at", descending: true)
          .snapshots();
    }
  }
}
