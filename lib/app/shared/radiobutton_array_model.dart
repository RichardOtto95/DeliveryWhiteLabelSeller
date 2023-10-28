import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../core/models/additional_model.dart';
import 'utilities.dart';

class RadioButtonArrayModel extends StatefulWidget {
  final AdditionalModel model;
  final Map? response;

  RadioButtonArrayModel({Key? key, required this.model, this.response}) : super(key: key);

  @override
  State<RadioButtonArrayModel> createState() => _RadioButtonArrayModelState();
}

class _RadioButtonArrayModelState extends State<RadioButtonArrayModel> {
  final MainStore store = Modular.get();
  int groupValue = 0;
  @override
  Widget build(BuildContext context) {
    if(widget.response != null){
      print('widget.response: ${widget.response}');
      groupValue = widget.response!['index'];
    }
    return Container(
      margin: EdgeInsets.only(
        right: wXD(15, context),
        top: wXD(15, context),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: store.getRadiobuttonList(widget.model.id),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return LinearProgressIndicator();
          }
          List<Map<String, dynamic>> radiobuttonArray = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  // left: wXD(15, context),
                ),
                child: Text(
                  widget.model.title,
                  style: textFamily(context,
                    fontSize: 15,
                    color: getColors(context).onBackground,
                  ),
                ),
              ),
              Column(
                children: List.generate(
                  radiobuttonArray.length,
                  (i) {
                    // print('List.generate: $i');
                    Map<String, dynamic> radiobuttonMap = radiobuttonArray[i];
                    String signal = "";
                    if(radiobuttonMap['value'] != 0){
                      signal = radiobuttonMap['value'] > 0 ? "" : "-";
                    }
                    return Row(
                      children: [
                        Radio(
                          activeColor: colors.primary,
                          value: i,
                          groupValue: groupValue, 
                          onChanged: (int? value) {},
                        ),
                        Expanded(
                          child: Text(radiobuttonMap['label']),
                        ),
                        SizedBox(width: wXD(15, context),),
                        Container(
                          width: wXD(100, context),
                          child: Text(signal + 'R\$ ${formatedCurrency(radiobuttonMap['value'])}'),
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