import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../core/models/additional_model.dart';
import 'utilities.dart';

class TextFieldScoreModel extends StatefulWidget {
  final AdditionalModel model;
  final Map? response;

  TextFieldScoreModel({Key? key, required this.model, this.response}) : super(key: key);

  @override
  State<TextFieldScoreModel> createState() => _TextFieldScoreModelState();
}

class _TextFieldScoreModelState extends State<TextFieldScoreModel> {
  final MainStore mainStore = Modular.get();
  String? initialValue;

  @override
  Widget build(BuildContext context) {
    if(widget.response != null){
      initialValue = widget.response!['text'];
    }
    return Column(
      crossAxisAlignment: mainStore.getColumnAlignment(widget.model.alignment),
      children: [
        Padding(
          padding: EdgeInsets.only(
            // left: wXD(15, context),
            top: wXD(15, context),
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
          // width: maxWidth(context),
          // alignment: Alignment.centerLeft,
          child: Container(
            width: widget.model.short == false ? maxWidth(context) /2 : maxWidth(context),
            // margin: EdgeInsets.symmetric(
            //     horizontal: wXD(15, context)),
            padding: EdgeInsets.symmetric(
                horizontal: wXD(8, context),
                vertical: wXD(5, context)),
            // height: wXD(200, context),
            decoration: BoxDecoration(
              border:
                  Border.all(color: getColors(context).primary),
              borderRadius:
                  BorderRadius.all(Radius.circular(12)),
            ),
            child: TextFormField(
              enabled: false,
              maxLines: 1,
              initialValue: initialValue,
              decoration: InputDecoration.collapsed(
                  hintText: widget.model.hint),
            ),
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