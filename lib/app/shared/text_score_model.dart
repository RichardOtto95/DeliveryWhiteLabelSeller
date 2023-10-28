import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../core/models/additional_model.dart';
import '../modules/main/main_store.dart';
import 'utilities.dart';

class TextScoreModel extends StatelessWidget {
  final AdditionalModel model;
  final MainStore mainStore = Modular.get();

  TextScoreModel({Key? key, required this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: mainStore.getColumnAlignment(model.alignment),
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: wXD(15, context),
            top: wXD(15, context),
            bottom: wXD(15, context),
          ),
          child: Text(
            model.title,
            style: textFamily(context,
              fontSize: model.fontSize.toDouble(),
              color: getColors(context).onBackground,
            ),
          ),
        ),
      ],
    );
  }
}