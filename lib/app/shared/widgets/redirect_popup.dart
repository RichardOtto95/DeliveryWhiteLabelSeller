import 'dart:ui';
import 'package:flutter/material.dart';

import '../utilities.dart';

class RedirectPopup extends StatelessWidget {
  final String text;
  final void Function() onConfirm, onCancel;
  final double? height;
  const RedirectPopup({
    Key? key,
    required this.text,
    required this.onConfirm,
    required this.onCancel,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool loadCircular = false;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: GestureDetector(
        onTap: onCancel,
        child: Container(
          height: maxHeight(context),
          width: maxWidth(context),
          color: getColors(context).shadow,
          alignment: Alignment.center,
          child: Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(3),
              topRight: Radius.circular(3),
            ),
            child: Container(
              height: height ?? wXD(156, context),
              width: wXD(327, context),
              padding: EdgeInsets.all(wXD(24, context)),
              decoration: BoxDecoration(
                color: getColors(context).surface,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(3),
                  topRight: Radius.circular(3),
                ),
                boxShadow: [
                  BoxShadow(blurRadius: 18, color: getColors(context).shadow)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: textFamily(context, fontSize: 17),
                  ),
                  Spacer(),
                  StatefulBuilder(builder: (context, setState) {
                    return Row(
                      mainAxisAlignment: loadCircular
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.spaceEvenly,
                      children: loadCircular
                          ? [
                              CircularProgressIndicator(
                                color: getColors(context).primary,
                              )
                            ]
                          : [
                              BlackButton(text: 'Não', onTap: onCancel),
                              BlackButton(
                                  text: 'Sim',
                                  onTap: () {
                                    setState(() {
                                      loadCircular = true;
                                      onConfirm();
                                    });
                                  }),
                            ],
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BlackButton extends StatelessWidget {
  final String text;
  final void Function() onTap;
  const BlackButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: wXD(47, context),
          width: wXD(82, context),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(3)),
              color: getColors(context).surface,
              boxShadow: [
                BoxShadow(blurRadius: 8, color: getColors(context).shadow)
              ]),
          alignment: Alignment.center,
          child: Text(
            text,
            style: textFamily(context,
                color: getColors(context).primary, fontSize: 17),
          )),
    );
  }
}
