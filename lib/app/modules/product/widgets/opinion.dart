import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Option extends StatefulWidget {
  final String title;
  final List<String> options;
  final bool qtd;

  Option({
    Key? key,
    required this.title,
    required this.options,
    this.qtd = false,
  }) : super(key: key);

  @override
  _OptionState createState() => _OptionState();
}

class _OptionState extends State<Option> {
  String optionSelected = '';

  @override
  void initState() {
    optionSelected = widget.options.first;
    super.initState();
  }

  @override
  Widget build(context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: wXD(17, context)),
        padding: EdgeInsets.symmetric(horizontal: wXD(21, context)),
        height: wXD(41, context),
        width: wXD(316, context),
        decoration: BoxDecoration(
            color: getColors(context).primary.withOpacity(.2),
            borderRadius: BorderRadius.all(Radius.circular(3))),
        child: Row(
          children: [
            Text(
              '${widget.title}: ',
              style: textFamily(
                context,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: getColors(context).onSurface,
              ),
            ),
            Text(
              '${widget.options.first}',
              style: textFamily(
                context,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: getColors(context).onBackground,
              ),
            ),
            widget.qtd ? Spacer() : Container(),
            widget.qtd
                ? Text(
                    '(${widget.options.last} disponíveis)',
                    style: textFamily(
                      context,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: getColors(context).onSurface.withOpacity(.5),
                    ),
                  )
                : Container(),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(top: wXD(2, context)),
              child: Transform.rotate(
                angle: math.pi * 1.5,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: getColors(context).primary,
                  size: wXD(22, context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
