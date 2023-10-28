import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../core/models/additional_model.dart';
import '../modules/main/main_store.dart';

class IncrementFieldModel extends StatelessWidget {
  final AdditionalModel model;
  final Map? response;
  final MainStore mainStore = Modular.get();

  IncrementFieldModel({Key? key, required this.model, this.response}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, refresh) {
        return Container(
          margin: EdgeInsets.only(top: wXD(15, context)),
          child: Column(
            crossAxisAlignment: mainStore.getColumnAlignment(model.alignment),
            children: [
              Text(
                model.title,
                style: textFamily(context,
                  fontSize: 15,
                  color: getColors(context).onBackground,
                ),
              ),
              Row(
                mainAxisAlignment: mainStore.getRowAlignment(model.alignment),
                children: [                 
                  Container(
                    height: wXD(25, context),
                    width: wXD(88, context),
                    margin: EdgeInsets.only(top: wXD(4, context)),
                    padding:
                        EdgeInsets.symmetric(horizontal: wXD(4, context)),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: getColors(context).onSurface.withOpacity(.3),
                      ),
                      // borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.remove,
                            size: wXD(20, context),
                            color: getColors(context).primary.withOpacity(.4)
                          ),
                        ),
                        Container(
                          width: wXD(32, context),
                          height: wXD(25, context),
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                              vertical: BorderSide(
                                color: getColors(context)
                                    .onSurface
                                    .withOpacity(.3),
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            (response != null && response!['count'] != null) ? response!['count'].toString():  model.incrementMinimum.toString(),
                            style: textFamily(context,
                                color: getColors(context).primary),
                          ),
                        ),
                        InkWell(
                          onTap: (){},
                          child: Icon(
                            Icons.add,
                            size: wXD(20, context),
                            color: getColors(context).primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: wXD(10, context),
                  ),
                  Text(
                    "R\$ ${formatedCurrency(model.incrementValue)}",
                    style: textFamily(context,
                      fontSize: 15,
                      color: getColors(context).onBackground,
                    ),
                  ),
                ],
              ),
              SizedBox(height: wXD(10, context),),              
            ],
          ),
        );
      }
    );
  }
}