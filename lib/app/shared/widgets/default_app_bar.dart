import 'package:delivery_seller_white_label/app/shared/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

class DefaultAppBar extends StatelessWidget {
  final bool noPop;
  final String title;
  final void Function()? onPop;
  DefaultAppBar(this.title, {this.onPop, this.noPop = false});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyleFromColor(getColors(context).surface),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: maxWidth(context),
            height: MediaQuery.of(context).viewPadding.top + wXD(50, context),
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(3)),
              color: getColors(context).surface,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: getColors(context).shadow,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
          // noPop
          //     ? Container()
          //     :
          Visibility(
            visible: !noPop,
            child: Positioned(
              bottom: wXD(2, context),
              left: wXD(28, context),
              child: SizedBox(
                height: wXD(32, context),
                width: wXD(32, context),
                child: InkWell(
                    onTap: () {
                      if (!noPop) {
                        if (onPop != null) {
                          onPop!();
                        } else {
                          Modular.to.pop();
                        }
                      }
                    },
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: wXD(27, context),
                    )),
              ),
            ),
          ),
          Positioned(
            bottom: wXD(9, context),
            child: Text(
              title,
              style: TextStyle(
                color: getColors(context).onBackground,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
