import 'package:delivery_seller_white_label/app/modules/orders/orders_store.dart';

import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OrdersAppBar extends StatelessWidget {
  final Function(int value) onTap;
  final OrdersStore store = Modular.get();

  OrdersAppBar({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyleFromColor(getColors(context).surface),
      child: Container(
        height: MediaQuery.of(context).viewPadding.top + wXD(80, context),
        width: maxWidth(context),
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(3)),
          color: getColors(context).surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(0, 3),
              color: getColors(context).shadow,
            ),
          ],
        ),
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Pedidos',
              style: textFamily(
                context,
                fontSize: 20,
                color: getColors(context).primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: wXD(10, context)),
            Container(
              width: maxWidth(context),
              child: DefaultTabController(
                length: 3,
                child: TabBar(
                  indicatorColor: getColors(context).primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.symmetric(vertical: 8),
                  labelColor: getColors(context).primary,
                  labelStyle: textFamily(context, fontWeight: FontWeight.bold),
                  unselectedLabelColor: getColors(context).onBackground,
                  indicatorWeight: 3,
                  onTap: (value) {
                    print('value value: $value');
                    onTap(value);
                    // if (value == 0)
                    //   store.setOrderStatusView(["REQUESTED"].asObservable());
                    // else if (value == 1)
                    //   store.setOrderStatusView([
                    //     "SENDED",
                    //     "PROCESSING",
                    //     "DELIVERY_REQUESTED",
                    //     "DELIVERY_REFUSED",
                    //     "DELIVERY_ACCEPTED",
                    //     "TIMEOUT",
                    //   ].asObservable());
                    // else if (value == 2)
                    //   store.setOrderStatusView([
                    //     "CANCELED",
                    //     "REFUSED",
                    //     "CONCLUDED",
                    //   ].asObservable());
                  },
                  tabs: [
                    Text('Pendentes'),
                    Text('Em andamento'),
                    Text('Concluídos'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
