import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class Accounts extends StatelessWidget {
  final num totalPrice, shippingPrice;
  final num? discount, newTotalPrice, change;
  const Accounts(
      {Key? key,
      required this.totalPrice,
      required this.shippingPrice,
      this.discount,
      this.newTotalPrice,
      required this.change})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.fromLTRB(
        wXD(30, context),
        wXD(15, context),
        wXD(20, context),
        wXD(30, context),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Sub Total',
                style: textFamily(
                  context,
                  fontSize: 15,
                  color: getColors(context).onBackground,
                ),
              ),
              Spacer(),
              Text(
                'R\$ ${formatedCurrency(totalPrice - shippingPrice)}',
                style: textFamily(
                  context,
                  fontSize: 15,
                  color: getColors(context).primary,
                ),
              ),
            ],
          ),
          SizedBox(height: wXD(12, context)),
          Row(
            children: [
              Text(
                'Frete',
                style: textFamily(
                  context,
                  fontSize: 15,
                  color: getColors(context).onBackground,
                ),
              ),
              Spacer(),
              Text(
                'R\$ ${formatedCurrency(shippingPrice)}',
                style: textFamily(
                  context,
                  fontSize: 15,
                  color: getColors(context).primary,
                ),
              ),
            ],
          ),
          SizedBox(height: wXD(12, context)),
          Row(
            children: [
              Text(
                'Total',
                style: textFamily(
                  context,
                  fontSize: 15,
                  color: getColors(context).onBackground,
                ),
              ),
              Spacer(),
              Text(
                'R\$ ${formatedCurrency((totalPrice))}',
                style: textFamily(
                  context,
                  fontSize: 15,
                  color: getColors(context).primary,
                ),
              ),
            ],
          ),
          discount == null
              ? Container()
              : Column(
                  children: [
                    SizedBox(height: wXD(12, context)),
                    Row(
                      children: [
                        Text(
                          'Desconto',
                          style: textFamily(
                            context,
                            fontSize: 15,
                            color: getColors(context).onBackground,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'R\$ -${formatedCurrency((discount))}',
                          style: textFamily(context,
                              fontSize: 15, color: getColors(context).error),
                        ),
                      ],
                    ),
                    SizedBox(height: wXD(12, context)),
                    Row(
                      children: [
                        Text(
                          'Pago',
                          style: textFamily(
                            context,
                            fontSize: 15,
                            color: getColors(context).onBackground,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'R\$ ${formatedCurrency((newTotalPrice))}',
                          style: textFamily(
                            context,
                            fontSize: 15,
                            color: getColors(context).primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          change == null
              ? Container()
              : Column(
                  children: [
                    SizedBox(height: wXD(12, context)),
                    Row(
                      children: [
                        Text(
                          'Troco',
                          style: textFamily(
                            context,
                            fontSize: 15,
                            color: getColors(context).onBackground,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'R\$ ${formatedCurrency((change))}',
                          style: textFamily(
                            context,
                            fontSize: 15,
                            color: getColors(context).primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
