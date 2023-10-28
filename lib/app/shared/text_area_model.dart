import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';

import '../core/models/additional_model.dart';

class TextAreaModel extends StatefulWidget {
  final AdditionalModel model;
  final Map? response;

  TextAreaModel({Key? key, required this.model, this.response}) : super(key: key);

  @override
  State<TextAreaModel> createState() => _TextAreaModelState();
}

class _TextAreaModelState extends State<TextAreaModel> {
  String? initialValue;

  @override
  Widget build(BuildContext context) {
    if(widget.response != null){
      initialValue = widget.response!['text'];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            // left: wXD(15, context),
            // top: wXD(15, context),
          ),
          child: Text(
            getText(widget.model.title, widget.model.mandatory),
            style: textFamily(context,
              fontSize: 15,
              color: getColors(context).onBackground,
            ),
          ),
        ),
        SizedBox(height: wXD(5, context),),
        Container(
          width: maxWidth(context),
          // margin: EdgeInsets.symmetric(
          //     horizontal: wXD(15, context)),
          padding: EdgeInsets.symmetric(
              horizontal: wXD(8, context),
              vertical: wXD(5, context)),
          height: wXD(200, context),
          decoration: BoxDecoration(
            border:
                Border.all(color: getColors(context).primary),
            borderRadius:
                BorderRadius.all(Radius.circular(12)),
          ),
          child: TextFormField(
            enabled: false,
            initialValue: initialValue,
            maxLines: 5,
            decoration: InputDecoration.collapsed(
                hintText: widget.model.hint),
            // maxLength: 500,
            // onChanged: (val) => store.textFieldHint = val,
          ),
        ), 
      ],
    );
  }

  getText(String title, bool? mandatory){
    if(mandatory == null || mandatory == false){
      return title;
    } else {
      return title + "*";
    }
  }
}