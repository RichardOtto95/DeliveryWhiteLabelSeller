import 'package:delivery_seller_white_label/app/core/models/rating_model.dart';
import 'package:delivery_seller_white_label/app/core/models/time_model.dart';
import 'package:delivery_seller_white_label/app/modules/profile/profile_store.dart';
import 'package:delivery_seller_white_label/app/modules/profile/widget/type_evaluation.dart';

import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AnswerRating extends StatefulWidget {
  final List<Map<String, dynamic>> ratingModelList;

  const AnswerRating({Key? key, required this.ratingModelList})
      : super(key: key);

  @override
  _AnswerRatingState createState() => _AnswerRatingState();
}

class _AnswerRatingState extends State<AnswerRating> {
  final ProfileStore store = Modular.get();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    print('widget.ratingModel: ${widget.ratingModelList.first['model'].id}');
    super.initState();
  }

  @override
  void dispose() {
    print('dispose');
    store.orderId = null;
    store.raitingId = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        wXD(16, context),
                        viewPaddingTop(context) + wXD(60, context),
                        wXD(12, context),
                        wXD(12, context),
                      ),
                      width: maxWidth(context),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: getColors(context)
                                  .onBackground
                                  .withOpacity(.2)),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Responda à avaliação',
                            style: textFamily(
                              context,
                              color: getColors(context).onBackground,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            Time(widget
                                    .ratingModelList.first['model'].createdAt!
                                    .toDate())
                                .dayDate(),
                            style: textFamily(
                              context,
                              color: getColors(context)
                                  .onBackground
                                  .withOpacity(.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // TypeEvaluation(
                    //   focus: productFocus,
                    //   onChanged: (val) {
                    //     productAnswer = val;
                    //   },
                    //   onComplete: () => sellerFocus.requestFocus(),
                    //   rating: widget.ratingModel.productRating!,
                    //   text: widget.ratingModel.productAnswer ?? "",
                    //   title: 'Opinião referente ao produto',
                    //   opinion: widget.ratingModel.productOpnion ?? "",
                    // ),
                    ...List.generate(
                      widget.ratingModelList.length,
                      (int index) {
                        RatingModel ratingModel =
                            widget.ratingModelList[index]['model'];
                        String? adsId = widget.ratingModelList[index]['ads_id'];
                        return TypeEvaluation(
                          adsId: adsId,
                          onChanged: (val) {
                            if (store.answerMap.containsKey(adsId)) {
                              store.answerMap[adsId] = val;
                            } else {
                              store.answerMap.putIfAbsent(adsId, () => val);
                            }
                          },
                          rating: ratingModel.rating!,
                          text: ratingModel.answer ?? "",
                          title: adsId == null
                              ? 'Opinião referente ao atendimento'
                              : 'Opinião referente ao produto',
                          opinion: ratingModel.opnion ?? "",
                        );
                      },
                    ),
                    // TypeEvaluation(
                    //   focus: deliveryFocus,
                    //   onChanged: (val) {
                    //     deliveryAnswer = val;
                    //   },
                    //   onComplete: () => deliveryFocus.unfocus(),
                    //   rating: widget.ratingModel.deliveryRating!,
                    //   text: widget.ratingModel.deliveryAnswer ?? "",
                    //   title: 'Opinião referente a entrega',
                    //   opinion: widget.ratingModel.deliveryOpnion ?? "",
                    // ),
                    SizedBox(height: wXD(35, context)),
                    SideButton(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          // Object ratingEdit = {
                          // 'product_answer': productAnswer,
                          // 'seller_answer': sellerAnswer,
                          // 'delivery_answer': deliveryAnswer,
                          // 'answer': answer,
                          // 'answered': true,
                          // 'id': widget.ratingModel.id,
                          // 'seller_id': widget.ratingModel.sellerId,
                          // 'agent_id': widget.ratingModel.agentId,
                          // 'ads_id': widget.ratingModel.adsId,
                          // };
                          // await store.answerAvaliation(ratingEdit, context);
                          await store.answerAvaliation(
                              store.answerMap, context);
                          print("Validado");
                        }
                      },
                      height: wXD(52, context),
                      width: wXD(150, context),
                      title: 'Responder',
                    ),
                    SizedBox(height: wXD(25, context)),
                  ],
                ),
              ),
            ),
            DefaultAppBar('Avaliação'),
          ],
        ),
      ),
    );
  }

  List<Ball> getBalls() {
    List<Ball> balls = [];
    for (var i = 1; i <= 10; i++) {
      balls.add(Ball(i));
    }
    return balls;
  }
}

class Ball extends StatelessWidget {
  final int number;

  Ball(this.number);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(26, context),
      width: wXD(26, context),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: getColors(context).primary.withOpacity(.15)),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: textFamily(
          context,
          fontSize: 16,
          color: getColors(context).onBackground,
        ),
      ),
    );
  }
}
