import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class Characteristic extends StatelessWidget {
  final String title, data;
  Characteristic({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: wXD(15, context)),
        child: RichText(
          text: TextSpan(
            style: textFamily(
              context,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: getColors(context).onSurface,
            ),
            children: [
              TextSpan(text: '$title: '),
              TextSpan(
                text: data,
                style: textFamily(
                  context,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: getColors(context).onBackground,
                ),
              ),
            ],
          ),
        )

        // Wrap(
        //   children: [
        //     Text(
        //       '$title: ',
        //       style: textFamily(context,
        //         fontSize: 13,
        //         fontWeight: FontWeight.w500,
        //         color: getColors(context).onSurface,
        //       ),
        //     ),
        //     Text(
        //       data,
        //       style: textFamily(context,
        //         fontSize: 13,
        //         fontWeight: FontWeight.w500,
        //         color: getColors(context).onBackground,
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}
