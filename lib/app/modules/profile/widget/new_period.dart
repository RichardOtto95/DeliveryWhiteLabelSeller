import 'package:delivery_seller_white_label/app/modules/profile/profile_store.dart';
import 'package:delivery_seller_white_label/app/modules/profile/widget/opening_hours.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/models/time_model.dart';
import '../../../shared/utilities.dart';
import '../../../shared/widgets/confirm_popup.dart';

class NewPeriod extends StatefulWidget {
  final Periods? period;

  const NewPeriod({Key? key, this.period}) : super(key: key);

  @override
  State<NewPeriod> createState() => _NewPeriodState();
}

class _NewPeriodState extends ModularState<NewPeriod, ProfileStore> {
  late Periods period;
  OverlayEntry? confirmDeleteOverlay;

  @override
  initState() {
    period = widget.period ??
        Periods(
          start: null,
          end: null,
          weekDays: "",
          id: "",
          status: "ACTIVE",
        );
    super.initState();
  }

  getWeekDayColor(context, int index, Periods period) =>
      getColors(context).onBackground.withOpacity(
            (period.weekDays.contains((index + 1).toString()) ? 1.0 : .4),
          );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (confirmDeleteOverlay != null) {
          confirmDeleteOverlay!.remove();
          confirmDeleteOverlay = null;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: maxHeight(context),
              width: maxWidth(context),
              child: Column(
                children: [
                  DefaultAppBar(
                    widget.period == null ? "Novo período" : "Editar período",
                  ),
                  Spacer(),
                  Text(
                    "De",
                    style: textFamily(context,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: getColors(context).onBackground),
                  ),
                  TextButton(
                      onPressed: () async {
                        final newTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              period.start ?? DateTime(2000, 01, 01, 00, 00)),
                        );
                        if (newTime != null) {
                          period.start = DateTime(
                            2000,
                            01,
                            01,
                            newTime.hour,
                            newTime.minute,
                          );
                          setState(() {});
                        }
                      },
                      child: Text(
                        period.start != null
                            ? Time(period.start!).hour()
                            : "00:00",
                        style: textFamily(
                          context,
                          fontSize: 65,
                          fontWeight: FontWeight.normal,
                          color: getColors(context).onBackground,
                        ),
                      )),
                  Spacer(),
                  Text(
                    "até",
                    style: textFamily(context,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: getColors(context).onBackground),
                  ),
                  TextButton(
                    onPressed: () async {
                      final newTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            period.end ?? DateTime(2000, 01, 01, 00, 00)),
                      );
                      if (newTime != null) {
                        period.end = DateTime(
                          2000,
                          01,
                          01,
                          newTime.hour,
                          newTime.minute,
                        );
                        setState(() {});
                      }
                    },
                    child: Text(
                      period.end != null ? Time(period.end!).hour() : "00:00",
                      style: textFamily(
                        context,
                        fontSize: 65,
                        fontWeight: FontWeight.normal,
                        color: getColors(context).onBackground,
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      7,
                      (index) => InkWell(
                        onTap: () {
                          setState(() {
                            if (period.weekDays
                                .contains(((index + 1).toString()))) {
                              period.weekDays = period.weekDays
                                  .replaceAll((index + 1).toString(), "");
                            } else {
                              period.weekDays =
                                  period.weekDays + (index + 1).toString();
                            }
                          });
                        },
                        child: Container(
                          width: wXD(40, context),
                          padding:
                              EdgeInsets.symmetric(vertical: wXD(5, context)),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: getWeekDayColor(
                                  context,
                                  index,
                                  period,
                                ),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.center,
                          child: Text(
                            Time.shortDay(index + 1, capitalize: true),
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
                  ),
                  Spacer(),
                  Text(
                    period.start != null &&
                            period.end != null &&
                            period.weekDays != ""
                        ? store.getPeriodString(period)
                        : "",
                    style: textFamily(context),
                  ),
                  Spacer(),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: getColors(context).surface,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          offset: Offset(0, -3),
                          color: getColors(context).shadow.withOpacity(.3),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Modular.to.pop(),
                            child: Container(
                              width: double.infinity,
                              height: wXD(70, context),
                              alignment: Alignment.center,
                              child: Text(
                                "Cancelar",
                                style: textFamily(
                                  context,
                                  color: getColors(context).error,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: wXD(70, context),
                          width: 1,
                          color:
                              getColors(context).onBackground.withOpacity(.6),
                        ),
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              // onTap: () => print("weekDay => ${period.weekDays.characters.toList()}"),
                              onTap: () => widget.period == null
                                  ? store.savePeriod(context, period)
                                  : store.editPeriod(period, context),
                              child: Container(
                                width: double.infinity,
                                height: wXD(70, context),
                                alignment: Alignment.center,
                                child: Text(
                                  "Salvar",
                                  style: textFamily(
                                    context,
                                    color: getColors(context).onBackground,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: widget.period != null,
              child: Positioned(
                top: viewPaddingTop(context) + wXD(65, context),
                right: wXD(15, context),
                child: IconButton(
                  onPressed: () {
                    confirmDeleteOverlay = OverlayEntry(
                      builder: (context) => ConfirmPopup(
                        height: wXD(150, context),
                        text: "Tem certeza que deseja excluir esse período?",
                        onConfirm: () async {
                          await store.deletePeriod(period, context);
                          confirmDeleteOverlay!.remove();
                          confirmDeleteOverlay = null;
                        },
                        onCancel: () {
                          confirmDeleteOverlay!.remove();
                          confirmDeleteOverlay = null;
                        },
                      ),
                    );
                    Overlay.of(context)!.insert(confirmDeleteOverlay!);
                  },
                  icon: Icon(
                    Icons.delete_outline_outlined,
                    color: getColors(context).onBackground,
                    size: wXD(30, context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
