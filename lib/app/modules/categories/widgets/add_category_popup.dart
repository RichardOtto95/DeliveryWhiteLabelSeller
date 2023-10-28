import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../shared/utilities.dart';

class AddCategoryPopup extends StatefulWidget {
  final void Function() onBack;
  final Future Function(String) onSave;
  final String label;

  AddCategoryPopup({
    Key? key,
    required this.onBack,
    required this.onSave,
    this.label = "Preencha com a categoria desejada!",
  }) : super(key: key);

  @override
  State<AddCategoryPopup> createState() => _AddCategoryPopupState();
}

class _AddCategoryPopupState extends State<AddCategoryPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final _formKey = GlobalKey<FormState>();

  String text = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.animateTo(1,
        curve: Curves.easeOutQuad, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double value = _controller.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: value * 2 + 0.001, sigmaY: value * 2 + 0.001),
              child: GestureDetector(
                onTap: () async {
                  await _controller.animateTo(0,
                      curve: Curves.easeInOutSine,
                      duration: Duration(milliseconds: 300));
                  widget.onBack();
                },
                child: Container(
                  height: maxHeight(context),
                  width: maxWidth(context),
                  color: getColors(context).shadow.withOpacity(value * .3),
                  alignment: Alignment.center,
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: Container(
                height: (value * wXD(100, context)) + wXD(130, context),
                width: (value * wXD(150, context)) + wXD(177, context),
                padding: EdgeInsets.all(wXD(24, context)),
                decoration: BoxDecoration(
                  color: getColors(context).surface.withOpacity(value),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(value * 3),
                    topRight: Radius.circular(value * 3),
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: value * 18,
                        color:
                            getColors(context).shadow.withOpacity(value * .3))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.label,
                      style: textFamily(context,
                          fontSize: value * 17,
                          color:
                              getColors(context).onSurface.withOpacity(value)),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                    Form(
                      key: _formKey,
                      child: Center(
                        child: Container(
                          width: value * wXD(180, context),
                          // child: TextFormField(),
                          child: TextFormField(
                            autofocus: true,
                            maxLines: 1,
                            onChanged: (val) => text = val,
                            style: textFamily(
                              context,
                              fontSize: value * 21,
                              color: getColors(context).onBackground,
                            ),
                            autovalidateMode: AutovalidateMode.always,
                            textAlign: TextAlign.center,
                            // inputFormatters: [UpperCaseTextFormatter()],
                            decoration: InputDecoration.collapsed(
                              hintText: "Categoria",
                              hintStyle: textFamily(
                                context,
                                fontSize: value * 21,
                                color: getColors(context)
                                    .onSurface
                                    .withOpacity(value * .5),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: getColors(context)
                                      .primary
                                      .withOpacity(value),
                                  width: value * wXD(2, context),
                                ),
                              ),
                              fillColor:
                                  getColors(context).primary.withOpacity(value),
                              focusColor: getColors(context)
                                  .primary
                                  .withOpacity(value * .7),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Preencha corretamente";
                              }
                              return null;
                            },
                            cursorColor:
                                getColors(context).primary.withOpacity(value),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Center(
                      child: ThisButton(
                        value: value,
                        text: 'Salvar',
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await widget.onSave(text);
                            await _controller.animateTo(0,
                                curve: Curves.easeOutQuad,
                                duration: Duration(milliseconds: 300));
                            widget.onBack();
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ThisButton extends StatelessWidget {
  final String text;
  final double? width;
  final double value;
  final void Function() onTap;

  const ThisButton({
    Key? key,
    required this.value,
    required this.text,
    required this.onTap,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: value * wXD(47, context),
        width: value * (width ?? wXD(82, context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(value * 6)),
          boxShadow: [
            BoxShadow(
                blurRadius: value * 8,
                offset: Offset(0, 0),
                color: Color(0xff000000).withOpacity(value * .3))
          ],
          color: getColors(context).surface,
          border: Border.all(
            color: getColors(context).surface.withOpacity(value),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: textFamily(
            context,
            color: getColors(context).primary.withOpacity(value),
            fontSize: value * 17,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
// class AddCategoryPopup extends StatelessWidget {
//   final void Function() onBack;
//   final void Function(String) onSave;

//   AddCategoryPopup({
//     Key? key,
//     required this.onBack,
//     required this.onSave,
//   }) : super(key: key);

//   final _formKey = GlobalKey<FormState>();

//   String text = "";

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//           child: GestureDetector(
//             onTap: onBack,
//             child: Container(
//               height: maxHeight(context),
//               width: maxWidth(context),
//               color: getColors(context).shadow,
//               alignment: Alignment.center,
//             ),
//           ),
//         ),
//         Material(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(3),
//             topRight: Radius.circular(3),
//           ),
//           child: Container(
//             height: wXD(230, context),
//             width: wXD(327, context),
//             padding: EdgeInsets.all(wXD(24, context)),
//             decoration: BoxDecoration(
//               color: getColors(context).surface,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(3),
//                 topRight: Radius.circular(3),
//               ),
//               boxShadow: [
//                 BoxShadow(blurRadius: 18, color: getColors(context).shadow)
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   "Preencha com a categoria desejada!",
//                   style: textFamily(context, fontSize: 17),
//                   textAlign: TextAlign.center,
//                 ),
//                 Spacer(),
//                 Form(
//                   key: _formKey,
//                   child: Center(
//                     child: Container(
//                       width: wXD(180, context),
//                       child: TextFormField(),
//                       // child: TextFormField(
//                       //   autofocus: true,
//                       //   maxLines: 1,
//                       //   onChanged: (val) => text = val,
//                       //   style: textFamily(
//                       //     context,
//                       //     fontSize: 21,
//                       //     color: getColors(context).onBackground,
//                       //   ),
//                       //   textAlign: TextAlign.center,
//                       //   inputFormatters: [UpperCaseTextFormatter()],
//                       //   decoration: InputDecoration.collapsed(
//                       //     hintText: "Categoria",
//                       //     hintStyle: textFamily(
//                       //       context,
//                       //       fontSize: 21,
//                       //       color: getColors(context).onSurface.withOpacity(.5),
//                       //     ),
//                       //     border: UnderlineInputBorder(
//                       //       borderSide: BorderSide(
//                       //         color: getColors(context).primary,
//                       //         width: wXD(2, context),
//                       //       ),
//                       //     ),
//                       //     fillColor: getColors(context).primary,
//                       //     focusColor:
//                       //         getColors(context).primary.withOpacity(.7),
//                       //   ),
//                       //   validator: (value) {
//                       //     if (value == null || value.isEmpty) {
//                       //       return "Preencha corretamente";
//                       //     }
//                       //     return null;
//                       //   },
//                       //   cursorColor: getColors(context).primary,
//                       // ),
//                     ),
//                   ),
//                 ),
//                 Spacer(),
//                 Center(
//                   child: BlackButton(
//                     width: wXD(100, context),
//                     text: 'Salvar',
//                     onTap: () => onSave(text),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
