import 'package:delivery_seller_white_label/app/modules/advertisement/advertisement_module.dart';
import 'package:delivery_seller_white_label/app/modules/home/home_module.dart';
import 'package:delivery_seller_white_label/app/modules/notifications/notifications_module.dart';
import 'package:delivery_seller_white_label/app/modules/orders/orders_module.dart';
import 'package:delivery_seller_white_label/app/modules/profile/profile_module.dart';
import 'package:delivery_seller_white_label/app/shared/custom_scroll_behavior.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/custom_nav_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'main_store.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ModularState<MainPage, MainStore> {
  @override
  void initState() {
    if(!kIsWeb){
      FirebaseMessaging.instance.onTokenRefresh.listen(store.saveTokenToDatabase);    
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("Modular.to.route: ${Modular.to.localPath}");
    return WillPopScope(
      onWillPop: () async {
        store.setVisibleNav(true);
        return false;
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Observer(builder: (context) {
              return Container(
                height: maxHeight(context),
                width: maxWidth(context),
                child: ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: PageView(
                    physics: store.paginateEnable
                        ? AlwaysScrollableScrollPhysics()
                        : NeverScrollableScrollPhysics(),
                    controller: store.pageController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      HomeModule(),
                      NotificationsModule(),
                      OrdersModule(),
                      AdvertisementModule(),
                      ProfileModule(),
                    ],
                    onPageChanged: (value) {
                      // print('value: $value');
                      store.page = value;
                      store.setVisibleNav(true);
                    },
                  ),
                ),
              );
            }),
            Observer(
              builder: (context) {
                return AnimatedPositioned(
                  duration: Duration(seconds: 2),
                  curve: Curves.bounceOut,
                  bottom: store.visibleNav ? 0 : wXD(-85, context),
                  child: CustomNavBar(),
                );
              },
            ),
            // Observer(
            //   builder: (context) {
            //     return AnimatedPositioned(
            //       duration: Duration(seconds: 1),
            //       curve: Curves.bounceOut,
            //       bottom:
            //           store.visibleNav ? wXD(42, context) : wXD(-68, context),
            //       child: Observer(
            //         builder: (context) {
            //           return FloatingCircleButton(
            //             onTap: () async {
            //               store.setPage(2);
            //             },
            //             iconColor: store.page == 2 ? getColors(context).primary : getColors(context).surface,
            //           );
            //         },
            //       ),
            //     );
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
