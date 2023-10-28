import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/core/models/ads_model.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../core/models/additional_model.dart';
import '../../../shared/checkbox_array_model.dart';
import '../../../shared/dropdown_array_model.dart';
import '../../../shared/increment_field_model.dart';
import '../../../shared/radiobutton_array_model.dart';
import '../../../shared/text_area_model.dart';
import '../../../shared/text_field_score.dart';
import '../../../shared/text_score_model.dart';
import '../product_store.dart';

class Additional extends StatelessWidget {
  final ProductStore store = Modular.get();
  final AdsModel adsModel;
  final List<DocumentSnapshot> additionalQuery;
  Additional({
    Key? key, 
    required this.adsModel, 
    required this.additionalQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: getColors(context).onSurface.withOpacity(.2),
          ),
          bottom: BorderSide(
            color: getColors(context).onSurface.withOpacity(.2),
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: wXD(24, context), right: 24),
            width: maxWidth(context),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: wXD(20, context), top: wXD(15, context)),
                  child: Text(
                    'Informações adicionais',
                    style: textFamily(
                      context,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: getColors(context).onBackground,
                    ),
                  ),
                ),
                Container(
                  // padding: EdgeInsets.only(left: wXD(3, context)),
                  child: Column(
                    children: additionalQuery.map((DocumentSnapshot additionalDoc) {
                      switch (additionalDoc['type']) {
                        case "text-field":
                          return TextFieldScoreModel(
                            model: AdditionalModel.fromDoc(additionalDoc),
                          );
          
                        case "text-area":
                          return TextAreaModel(
                            model: AdditionalModel.fromDoc(additionalDoc),
                          );
          
                        case "increment":
                          return IncrementFieldModel(
                            model: AdditionalModel.fromDoc(additionalDoc),
                          );
          
                        case "text":
                          return TextScoreModel(
                            model: AdditionalModel.fromDoc(additionalDoc),
                          );
          
                        case "check-box":
                          return CheckBoxArrayModel(
                            model: AdditionalModel.fromDoc(additionalDoc),
                          );
          
                        case "radio-button":
                          return RadioButtonArrayModel(
                            model: AdditionalModel.fromDoc(additionalDoc),
                          );
          
                        case "combo-box":
                          return DropdownArrayModel(
                            model: AdditionalModel.fromDoc(additionalDoc),
                          );
          
                        default:
                          return Container();
                      }
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: wXD(30, context)),
        ],
      ),
    );
  }
}