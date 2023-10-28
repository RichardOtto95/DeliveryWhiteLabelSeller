import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../core/models/additional_model.dart';
import 'utilities.dart';

class CheckBoxArrayModel extends StatelessWidget {
  final MainStore store = Modular.get();
  final AdditionalModel model;
  final Map? response;

  CheckBoxArrayModel({Key? key, required this.model, this.response}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: wXD(15, context),
        top: wXD(15, context),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: store.getCheckboxList(model.id),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return LinearProgressIndicator();
          }
          List<Map<String, dynamic>> checkboxArray = snapshot.data!;
          // print('checkboxArray: ${checkboxArray.length}');
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [       
              Padding(
                padding: EdgeInsets.only(
                  // left: wXD(15, context),
                ),
                child: Text(
                  model.title,
                  style: textFamily(context,
                    fontSize: 15,
                    color: getColors(context).onBackground,
                  ),
                ),
              ),       
              Column(
                children: List.generate(
                  checkboxArray.length, 
                  (i) {
                    Map<String, dynamic> checkboxMap = checkboxArray[i];
                    String signal = "";
                    if(checkboxMap['value'] != 0){
                      signal = checkboxMap['value'] > 0 ? "" : "-";
                    }
                    return Row(
                      children: [
                        Checkbox(
                          activeColor: colors.primary,
                          value: response == null ? false : response![checkboxMap['id']] != null ? response![checkboxMap['id']] : false,
                          onChanged: (bool? value){},
                        ),
                        Expanded(child: Text(checkboxMap['label'])),
                        SizedBox(width: wXD(15, context),),
                        Container(
                          width: wXD(100, context),
                          child: Text(signal + "R\$ ${formatedCurrency(checkboxMap['value'])}"),
                          alignment: Alignment.centerLeft,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}