import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class SideButton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? fontSize;
  final Widget? child;
  final bool isWhite;
  final void Function() onTap;
  final String title;
  final Color? colorFont;

  const SideButton({
    Key? key,
    this.width,
    required this.onTap,
    this.title = '',
    this.height,
    this.child,
    this.isWhite = false,
    this.fontSize,
    this.colorFont,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width ?? wXD(81, context),
          height: height ?? wXD(44, context),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.horizontal(
            //   left: Radius.circular(isWhite ? 0 : 50),
            //   right: Radius.circular(isWhite ? 50 : 0),
            // ),
            border: Border.all(
              color: isWhite
                  ? getColors(context).onBackground.withOpacity(.25)
                  : getColors(context).onBackground,
            ),
            color: isWhite
                ? getColors(context).surface
                : getColors(context).primary,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                offset: Offset(0, 3),
                color: isWhite ? Color(0x80000000) : getColors(context).shadow,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: child == null
              ? Text(
                  title,
                  style: textFamily(
                    context,
                    color: colorFont != null
                        ? colorFont
                        : isWhite
                            ? getColors(context).primary
                            : getColors(context).onPrimary,
                    fontSize: fontSize ?? 18,
                  ),
                )
              : child,
        ),
      ),
    );
  }
}

class SideButtonWithIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final double? fontSize;
  final Widget? child;
  final bool isWhite;
  final void Function() onTap;
  final String title;
  final Color? colorFont;
  final IconData? iconData;

  const SideButtonWithIcon({
    Key? key,
    this.width,
    required this.onTap,
    this.title = '',
    this.height,
    this.child,
    this.isWhite = false,
    this.fontSize,
    this.colorFont,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width ?? wXD(81, context),
          height: height ?? wXD(44, context),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.horizontal(
            //   left: Radius.circular(isWhite ? 0 : 50),
            //   right: Radius.circular(isWhite ? 50 : 0),
            // ),
            // border: Border.all(
            //   color: isWhite
            //       ? getColors(context).onBackground.withOpacity(.25)
            //       : getColors(context).onBackground,
            // ),
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                offset: Offset(0, 3),
                color: isWhite ? Color(0x80000000) : getColors(context).shadow,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              iconData != null ? Icon(
                iconData,
                color: Colors.white
              )
              : Container(),
              SizedBox(width: wXD(15, context),),
              child == null
              ? Text(
                  title,
                  style: textFamily(
                    context,
                    color: colorFont != null
                        ? colorFont
                        : isWhite
                            ? getColors(context).primary
                            : getColors(context).onPrimary,
                    fontSize: fontSize ?? 18,
                  ),
                )
              : child!,
            ],
          ),                
        ),
      ),
    );
  }
}
