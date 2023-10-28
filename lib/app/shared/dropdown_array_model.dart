import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../core/models/additional_model.dart';
import 'utilities.dart';

class DropdownArrayModel extends StatelessWidget {
  final MainStore store = Modular.get();
  final AdditionalModel model;
  final Map? response;
  String dropdownValue = "";

  DropdownArrayModel({Key? key, required this.model, this.response}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if(response != null){
      dropdownValue = response!['label'];
    }
    return Container(
      key: key,
      margin: EdgeInsets.only(
        top: wXD(15, context),
        // left: wXD(15, context),
      ),
      // height: 50,
      width: maxWidth(context),
      child: Column(
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
          Padding(
            padding: EdgeInsets.only(
              left: wXD(15, context),
            ),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: store.getDropdownList(model.id),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return LinearProgressIndicator();
                }
                List<Map<String, dynamic>> dropdownArray = snapshot.data!;
                if(dropdownValue == ""){
                  dropdownValue = dropdownArray[0]['label'];
                }

                return DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: colors.primary,
                  ),
                  onChanged: (String? newValue) {},
                  items: dropdownArray.map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
                    return DropdownMenuItem<String>(
                      enabled: false,
                      value: value['label'],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value['label']),
                          // Spacer(),
                          // SizedBox(width: wXD(15, context),),
                          Text("R\$ ${formatedCurrency(value['value'])}"),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}