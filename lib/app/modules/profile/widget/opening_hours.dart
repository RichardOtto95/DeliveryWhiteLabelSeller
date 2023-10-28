import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/core/models/time_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/utilities.dart';
import '../profile_store.dart';

class OpeningHours extends StatefulWidget {
  final void Function() onBack;
  const OpeningHours({Key? key, required this.onBack}) : super(key: key);

  @override
  State<OpeningHours> createState() => _OpeningHoursState();
}

class _OpeningHoursState extends ModularState<OpeningHours, ProfileStore>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _buttonController;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    addScrollListener();
    _buttonController = AnimationController(vsync: this, value: 1);
    _controller = AnimationController(vsync: this);
    _controller.animateTo(1,
        duration: Duration(milliseconds: 400), curve: Curves.easeOutQuint);
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    _buttonController.dispose();
    _controller.dispose();
    // this.dispose();
    super.dispose();
  }

  addScrollListener() {
    scrollController.addListener(() {
      print(
          "ScrollDirection: ${scrollController.position.userScrollDirection}");
      print("value: ${_buttonController.value}");
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          _buttonController.value == 1) {
        _buttonController.animateTo(0,
            duration: Duration(milliseconds: 500), curve: Curves.easeOutQuint);
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          _buttonController.value == 0) {
        _buttonController.animateTo(1,
            duration: Duration(milliseconds: 500), curve: Curves.easeOutQuint);
      }
    });
  }

  getWeekDayColor(int index, Periods period) => getColors(context)
    .onSurface
    .withOpacity(period.weekDays.contains((index + 1).toString()) ? 1 : .4);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Listener(
          onPointerDown: (event) =>
              FocusScope.of(context).requestFocus(FocusNode()),
          child: Stack(
            alignment: Alignment.center,
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _controller.value+0.001,
                  sigmaY: _controller.value+0.001,
                ),
                child: GestureDetector(
                  onTap: () async {
                    _buttonController.animateBack(0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeOutQuint);
                    await _controller.animateBack(0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeOutQuint);
                    widget.onBack();
                  },
                  child: Container(
                    height: maxHeight(context),
                    width: maxWidth(context),
                    color: getColors(context)
                        .shadow
                        .withOpacity(.3 * _controller.value),
                  ),
                ),
              ),
              Material(
                color:
                    getColors(context).surface.withOpacity(_controller.value),
                elevation: 5,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Stack(
                  children: [
                    Container(
                      height: wXD(500, context),
                      width: wXD(330, context),
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("sellers")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("periods")
                            .where("status", isEqualTo: "ACTIVE")
                            .orderBy("created_at")
                            .snapshots(),
                        builder: (context, periodSnap) {
                          if (!periodSnap.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (periodSnap.data!.docs.isEmpty) {
                            return Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: wXD(wXD(80, context), context),
                                    color: getColors(context)
                                        .onSurface
                                        .withOpacity(_controller.value),
                                  ),
                                  Text(
                                    "Sem períodos cadastrados",
                                    style: textFamily(context,
                                        color: getColors(context)
                                            .onSurface
                                            .withOpacity(_controller.value)),
                                  ),
                                ],
                              ),
                            );
                          }

                          return SingleChildScrollView(
                            padding: EdgeInsets.only(bottom: wXD(150, context)),
                            controller: scrollController,
                            physics: AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            child: Column(
                                children: periodSnap.data!.docs
                                    .map(
                                      (e) => Period(
                                        value: _controller.value,
                                        period: Periods.fromDoc(e),
                                        onTap: () {
                                          _buttonController.animateBack(0,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeOutQuint);
                                          _controller.animateBack(0,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeOutQuint);
                                          widget.onBack();
                                          Modular.to.pushNamed(
                                              "/profile/new-period",
                                              arguments: Periods.fromDoc(e));
                                        },
                                        onLongPress: () => store.deletePeriod(
                                            Periods.fromDoc(e), context),
                                      ),
                                    )
                                    .toList()),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      right: wXD(15, context),
                      bottom: wXD(15, context),
                      child: AnimatedBuilder(
                        animation: _buttonController,
                        builder: (context, child) {
                          return AddPeriodButton(
                            value: _buttonController.value,
                            value2: _controller.value,
                            onAdd: () async {
                              widget.onBack();
                              await Modular.to.pushNamed("/profile/new-period");
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class AddPeriodButton extends StatelessWidget {
  const AddPeriodButton({
    Key? key,
    required this.value,
    required this.value2,
    required this.onAdd,
  }) : super(key: key);

  final double value;
  final double value2;
  final void Function() onAdd;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: value != 0,
      child: GestureDetector(
        onTap: onAdd,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: value < .5 ? 0 : 1,
          child: Container(
            height: wXD(50, context),
            width: wXD(50, context),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getColors(context).surface.withOpacity(value2),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6 * value * value2,
                  offset: Offset(0, 3 * value * value2),
                  color: getColors(context)
                      .shadow
                      .withOpacity(.3 * value * value2),
                )
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.add_rounded,
              size: wXD(wXD(25, context), context),
              color: getColors(context).primary.withOpacity(value * value2),
            ),
          ),
        ),
      ),
    );
  }
}

class Periods {
  DateTime? start;
  DateTime? end;
  dynamic createdAt;
  String weekDays;
  String id;
  String status;

  Periods({
    this.start,
    this.end,
    this.createdAt,
    required this.weekDays,
    required this.id,
    required this.status,
  });

  factory Periods.fromDoc(DocumentSnapshot doc) => Periods(
      start: doc["start"].toDate(),
      end: doc["end"].toDate(),
      createdAt: doc["created_at"],
      weekDays: doc["week_days"],
      id: doc["id"],
      status: doc["status"]);

  Map<String, dynamic> toJson() => {
        "start": start,
        "end": end,
        "created_at": createdAt,
        "week_days": weekDays,
        "id": id,
        "status": status,
      };
}

class Period extends StatelessWidget {
  final double value;
  final Periods period;
  final void Function() onTap;
  final void Function() onLongPress;

  const Period({
    Key? key,
    required this.value,
    required this.period,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  getWeekDayColor(context, int index, Periods period) =>
      getColors(context).onSurface.withOpacity(
            ((period.weekDays.contains((index + 1).toString()) ? 1.0 : .4) *
                value),
          );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: wXD(20, context)),
            margin: EdgeInsets.symmetric(horizontal: wXD(10, context)),
            decoration: BoxDecoration(
              color: getColors(context).surface.withOpacity(value),
              border: Border(
                bottom: BorderSide(
                  color: getColors(context).onSurface
                    .withOpacity(.7 * value),
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "De",
                      style: textFamily(context,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color:
                              getColors(context).onSurface.withOpacity(value)),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          Time(period.start!).hour(),
                          style: textFamily(
                            context,
                            fontSize: 35,
                            fontWeight: FontWeight.normal,
                            color:
                                getColors(context).onSurface.withOpacity(value),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(width: wXD(15, context)),
                    Text(
                      "até",
                      style: textFamily(context,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color:
                              getColors(context).onSurface.withOpacity(value)),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          Time(period.end!).hour(),
                          style: textFamily(
                            context,
                            fontSize: 35,
                            fontWeight: FontWeight.normal,
                            color:
                                getColors(context).onSurface.withOpacity(value),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: wXD(10, context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    7,
                    (index) => Container(
                      width: wXD(40, context),
                      padding: EdgeInsets.symmetric(vertical: wXD(5, context)),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: getWeekDayColor(
                              context,
                              index,
                              period,
                            ),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      alignment: Alignment.center,
                      child: Text(
                        Time.shortDay(index + 1),
                        style: textFamily(
                          context,
                          color: getWeekDayColor(
                            context,
                            index,
                            period,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
