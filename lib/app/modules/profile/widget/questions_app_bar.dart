import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/utilities.dart';
import '../../main/main_store.dart';
import '../profile_store.dart';

class QuestionsAppBar extends StatelessWidget {
  final User? _userAuth = FirebaseAuth.instance.currentUser;
  final Function(bool value) onTap;
  QuestionsAppBar({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final MainStore mainStore = Modular.get();
  final ProfileStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).viewPadding.top + wXD(80, context),
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top,
              left: wXD(30, context),
              right: wXD(30, context)),
          width: maxWidth(context),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(3)),
            color: getColors(context).surface,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                offset: Offset(0, 3),
                color: getColors(context).shadow,
              ),
            ],
          ),
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Perguntas',
                style: textFamily(
                  context,
                  fontSize: 20,
                  color: getColors(context).primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: wXD(10, context)),
              DefaultTabController(
                length: 2,
                child: TabBar(
                  onTap: (val) {
                    print("concluded: $val");
                    onTap(val == 1);
                    // store.setAnswered(val == 1);
                    // print("concluded: ${store.concluded}");
                  },
                  indicatorColor: getColors(context).primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.symmetric(vertical: 8),
                  labelColor: getColors(context).primary,
                  labelStyle: textFamily(context, fontWeight: FontWeight.bold),
                  unselectedLabelColor: getColors(context).onBackground,
                  indicatorWeight: 3,
                  tabs: [
                    Text('Pendentes'),
                    Text('Respondidas'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: wXD(30, context),
          top: MediaQuery.of(context).viewPadding.top,
          child: GestureDetector(
            onTap: () async {
              await FirebaseFirestore.instance
                  .collection("sellers")
                  .doc(_userAuth!.uid)
                  .update({"new_questions": 0});
              store.setProfileEditFromDoc();
              Modular.to.pop();
            },
            child: Icon(Icons.arrow_back,
                color: getColors(context).onBackground, size: wXD(25, context)),
          ),
        )
      ],
    );
  }
}
