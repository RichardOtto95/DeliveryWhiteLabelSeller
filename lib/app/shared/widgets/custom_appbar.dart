import 'package:flutter/material.dart';

import '../utilities.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({Key? key, required this.title})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  final Size preferredSize;
  final String title;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title,
          style: TextStyle(color: getColors(context).onBackground)),
      iconTheme: IconThemeData(color: getColors(context).onBackground),
      backgroundColor: getColors(context).surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(3))),
    );
  }
}
