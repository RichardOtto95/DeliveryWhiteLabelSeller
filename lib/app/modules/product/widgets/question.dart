import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/core/models/ads_model.dart';
import 'package:delivery_seller_white_label/app/core/models/time_model.dart';
import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';

import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class Question extends StatelessWidget {
  final String question;
  final Timestamp? answeredAt;
  final String? answer;

  Question({
    Key? key,
    required this.question,
    required this.answeredAt,
    this.answer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: wXD(18, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: textFamily(
              context,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: getColors(context).onSurface,
            ),
          ),
          answer != null
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: wXD(3, context),
                        top: wXD(7, context),
                      ),
                      height: wXD(12, context),
                      width: wXD(12, context),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: getColors(context).onSurface),
                          bottom:
                              BorderSide(color: getColors(context).onSurface),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: wXD(8, context),
                        left: wXD(3, context),
                      ),
                      width: wXD(316, context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            answer!,
                            style: textFamily(
                              context,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color:
                                  getColors(context).onSurface.withOpacity(.5),
                            ),
                          ),
                          Text(
                            Time(answeredAt!.toDate()).dayDate(),
                            style: textFamily(
                              context,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color:
                                  getColors(context).onSurface.withOpacity(.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}

class QuestionToAnswer extends StatefulWidget {
  final String question;
  final String username;
  final String adsId;
  final Timestamp? answeredAt;
  final Timestamp? createdAt;
  final String? answer;
  final void Function(String txt) onTap;

  QuestionToAnswer({
    Key? key,
    required this.onTap,
    required this.question,
    required this.username,
    required this.answeredAt,
    required this.createdAt,
    required this.adsId,
    this.answer,
  }) : super(key: key);

  @override
  _QuestionToAnswerState createState() => _QuestionToAnswerState();
}

class _QuestionToAnswerState extends State<QuestionToAnswer> {
  final MainStore mainStore = Modular.get();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  String _answer = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.only(
          top: wXD(18, context),
          left: wXD(20, context),
          right: wXD(20, context),
          bottom: wXD(10, context)),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: getColors(context).onSurface.withOpacity(.5)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("ads")
                  .doc(widget.adsId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    height: wXD(90, context),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation(getColors(context).primary)),
                  );
                }
                AdsModel ad = AdsModel.fromDoc(snapshot.data!);
                return InkWell(
                  onTap: () async {
                    mainStore.adsId = ad.id;
                    await Modular.to.pushNamed('/product');
                  },
                  child: Container(
                    // decoration: BoxDecoration(
                    //     border: Border(
                    //         bottom: BorderSide(
                    //             color: getColors(context).onBackground.withOpacity(.2)))),
                    padding: EdgeInsets.only(bottom: wXD(7, context)),
                    margin: EdgeInsets.fromLTRB(
                      wXD(0, context),
                      wXD(17, context),
                      wXD(6, context),
                      wXD(0, context),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          child: CachedNetworkImage(
                            progressIndicatorBuilder:
                                (context, url, progress) =>
                                    CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                  getColors(context).primary),
                            ),
                            imageUrl: ad.images.first,
                            height: wXD(65, context),
                            width: wXD(62, context),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: wXD(8, context)),
                          width: wXD(248, context),
                          height: wXD(70, context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // SizedBox(height: wXD(3, context)),
                              Text(
                                ad.title,
                                style: textFamily(context,
                                    color: getColors(context).onBackground),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: wXD(3, context)),
                              Text(
                                ad.description,
                                style: textFamily(context,
                                    color: getColors(context).onSurface),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // SizedBox(height: wXD(3, context)),
                              // Spacer(),
                              // Text(
                              //   'R\$${formatedCurrency(ad.price)}',
                              //   style:
                              //       textFamily(context,color: getColors(context).primary),
                              //   maxLines: 2,
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          Row(
            children: [
              Container(
                width: wXD(255, context),
                child: Text(
                  widget.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textFamily(
                    context,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: getColors(context).onBackground,
                  ),
                ),
              ),
              Spacer(),
              Text(
                Time(widget.createdAt!.toDate()).dayDate(),
                style: textFamily(
                  context,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: getColors(context).onSurface.withOpacity(.5),
                ),
              ),
            ],
          ),
          SizedBox(height: wXD(5, context)),
          Text(
            widget.question,
            style: textFamily(
              context,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: getColors(context).onSurface,
            ),
          ),
          widget.answer != null
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: wXD(3, context),
                        top: wXD(7, context),
                      ),
                      height: wXD(12, context),
                      width: wXD(12, context),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: getColors(context).onSurface),
                          bottom:
                              BorderSide(color: getColors(context).onSurface),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: wXD(8, context),
                        left: wXD(3, context),
                      ),
                      width: wXD(316, context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.answer!,
                            style: textFamily(
                              context,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color:
                                  getColors(context).onSurface.withOpacity(.5),
                            ),
                          ),
                          Text(
                            Time(widget.answeredAt!.toDate()).dayDate(),
                            style: textFamily(
                              context,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color:
                                  getColors(context).onSurface.withOpacity(.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Form(
                  key: _formKey,
                  child: Center(
                    child: Container(
                      width: wXD(350, context),
                      // height: wXD(40, context),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: wXD(11, context)),
                      margin: EdgeInsets.only(top: wXD(8, context)),
                      decoration: BoxDecoration(
                          border: Border.all(color: getColors(context).primary),
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      child: Row(
                        children: [
                          Container(
                            // height: wXD(40, context),
                            width: wXD(270, context),
                            padding:
                                EdgeInsets.symmetric(vertical: wXD(9, context)),
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: textController,
                              style: textFamily(context, fontSize: 15),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration.collapsed(
                                  hintText: "Digite aqui sua resposta",
                                  hintStyle: textFamily(context,
                                      fontSize: 15,
                                      color: getColors(context)
                                          .onSurface
                                          .withOpacity(.6))),
                              validator: (txt) {
                                if (txt == null || txt == '') {
                                  return "Sua resposta não pode estar vazia";
                                }

                                // else if (txt.length < 15) {
                                //   return "Sua resposta deve ter no mínimo 15 caracteres";
                                // }

                                return null;
                              },
                              onChanged: (txt) => _answer = txt,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                widget.onTap(_answer);
                                textController.clear();
                              } else {
                                showToast("Preencha o campo corretamente");
                              }
                            },
                            child: Container(
                              height: wXD(30, context),
                              width: wXD(40, context),
                              margin: EdgeInsets.only(right: wXD(5, context)),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      getColors(context).primary,
                                      getColors(context).primary.withOpacity(.7)
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3))),
                              alignment: Alignment.center,
                              child: Icon(Icons.send_outlined,
                                  color: getColors(context).surface,
                                  size: wXD(20, context)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
