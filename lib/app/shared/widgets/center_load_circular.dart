import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class CenterLoadCircular extends StatelessWidget {
  final double? height;
  const CenterLoadCircular({Key? key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? maxHeight(context),
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(getColors(context).primary),
      ),
    );
  }
}
