import 'package:delivery_seller_white_label/app/modules/advertisement/advertisement_store.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'dart:math' as math;
import '../../../shared/color_theme.dart';

class DeliveryFee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // height: wXD(52, context),
      // width: wXD(342, context),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: wXD(77, context)),
                DeliveryFeeItem(
                  type: "moto",
                  icon: Icons.motorcycle,
                  text: "Moto",
                ),
                DeliveryFeeItem(
                  type: "car",
                  icon: Icons.car_rental_outlined,
                  text: "Carro",
                ),
                DeliveryFeeItem(
                  type: "sedan",
                  icon: Icons.car_rental,
                  text: "Sedan",
                ),
                DeliveryFeeItem(
                  type: "utility",
                  icon: Icons.bus_alert,
                  text: "Utilitário",
                ),
              ],
            ),
          ),
          DefaultAppBar('Escolha o veículo apropriado')
        ],
      ),
    );
  }
}

class DeliveryFeeItem extends StatelessWidget {
  final AdvertisementStore store = Modular.get();

  final String text;
  final IconData icon;
  final String type;

  DeliveryFeeItem({
    Key? key,
    required this.text,
    required this.icon,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return InkWell(
        onTap: () {
          // if (store.editingAd) {
          //   store.adEdit.deliveryType = type;
          // } else {
          //   store.deliveryType = type;
          // }
          // store.deliveryTypeValidate = false;
          Modular.to.pop();
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: wXD(23, context),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: wXD(46, context),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Icon(icon, size: 30),
                    SizedBox(width: wXD(10, context)),
                    Text(
                      text,
                      style: textFamily(
                        context,
                        color: getColors(context).primary,
                        fontSize: 17,
                      ),
                    ),
                    // SizedBox(
                    //   width: wXD(10, context),
                    // ),
                    // Text(
                    //   text,
                    //   style: textFamily(context,
                    //     color: getColors(context).primary,
                    //     fontSize: 17,
                    //   ),
                    // ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward,
                      size: wXD(23, context),
                      color: getColors(context).primary,
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              type == "moto"
                  ? Container(
                      height: wXD(115, context),
                      margin: EdgeInsets.only(left: wXD(40, context)),
                      alignment: Alignment.topCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Limite de peso:",
                                style: textFamily(
                                  context,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                width: wXD(10, context),
                              ),
                              Text(
                                "20 Kg",
                                style: textFamily(
                                  context,
                                  color: getColors(context).primary,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Limites de tamanho:",
                            style: textFamily(
                              context,
                              fontSize: 15,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Profundidade:",
                                style: textFamily(
                                  context,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                width: wXD(10, context),
                              ),
                              Text(
                                "40 cm",
                                style: textFamily(
                                  context,
                                  color: getColors(context).primary,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Largura:",
                                style: textFamily(
                                  context,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                width: wXD(10, context),
                              ),
                              Text(
                                "40 cm",
                                style: textFamily(
                                  context,
                                  color: getColors(context).primary,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Altura:",
                                style: textFamily(
                                  context,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(width: wXD(9, context)),
                              Text(
                                "35 cm",
                                style: textFamily(
                                  context,
                                  color: getColors(context).primary,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: wXD(15, context)),
                        ],
                      ),
                    )
                  : Container(
                      height: wXD(84, context),
                      margin: EdgeInsets.only(left: wXD(40, context)),
                      alignment: Alignment.topCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Limite de peso:",
                                style: textFamily(
                                  context,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(width: wXD(10, context)),
                              Text(
                                getKg(),
                                style: textFamily(
                                  context,
                                  color: getColors(context).primary,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: wXD(10, context)),
                          Text(
                            "Limites de tamanho:",
                            style: textFamily(
                              context,
                              fontSize: 15,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Volume:",
                                style: textFamily(
                                  context,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(width: wXD(10, context)),
                              Text(
                                getVolumeInLitros(),
                                style: textFamily(
                                  context,
                                  color: getColors(context).primary,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: wXD(5, context)),
                        ],
                      ),
                    ),
            ],
          ),
          height: type != "moto" ? wXD(135, context) : wXD(171, context),
          width: maxWidth(context),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: getColors(context).onBackground.withOpacity(.2),
              ),
            ),
          ),
          alignment: Alignment.center,
        ),
      );
    });
  }

  String getVolumeInLitros() {
    String l = '';

    switch (type) {
      case "car":
        l = "200 litros";
        break;

      case "sedan":
        l = "375 litros";
        break;

      case "utility":
        l = "2.500 Litros";
        break;

      default:
        break;
    }

    return l;
  }

  String getKg() {
    String kg = '';

    switch (type) {
      case "car":
        kg = "200 Kg";
        break;

      case "sedan":
        kg = "300 Kg";
        break;

      case "utility":
        kg = "500 Kg";
        break;

      default:
        break;
    }

    return kg;
  }
}
