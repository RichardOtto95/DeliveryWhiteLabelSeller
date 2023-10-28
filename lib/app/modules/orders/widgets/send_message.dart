import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/utilities.dart';
import '../orders_store.dart';

class SendMessage extends StatelessWidget {
  final String text;
  final void Function() onTap;

  SendMessage({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final OrdersStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: wXD(30, context), right: wXD(3, context)),
          child: Icon(
            Icons.email_outlined,
            color: getColors(context).primary,
            size: wXD(20, context),
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            text,
            style: textFamily(
              context,
              fontSize: 14,
              color: getColors(context).primary,
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(right: wXD(14, context)),
          child: Icon(
            Icons.arrow_forward,
            color: getColors(context).primary,
            size: wXD(20, context),
          ),
        ),
      ],
    );
  }
}
