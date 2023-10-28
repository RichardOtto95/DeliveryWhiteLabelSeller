import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ProfileDataTile extends StatefulWidget {
  final String? Function(String?)? validator;

  final void Function(String?)? onChanged;
  final void Function(String?)? onChanged2;
  final TextEditingController? controller;
  final TextEditingController? controller2;
  final MaskTextInputFormatter? mask;
  final TextInputFormatter? inputFormatter;
  final void Function()? onPressed;
  final void Function()? onComplete;
  final void Function()? onComplete2;
  final FocusNode? focusNode;
  final FocusNode? focusNode2;
  final String title, hint;
  final bool? validate;
  final bool needValidation;
  final bool? validate2;
  final String? data;
  final String? data2, hint2;
  final int? length;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;

  const ProfileDataTile({
    Key? key,
    this.focusNode,
    required this.title,
    required this.hint,
    this.onComplete,
    this.validator,
    this.onChanged,
    this.onPressed,
    this.validate,
    this.validate2,
    this.length,
    this.mask,
    this.data,
    this.controller,
    this.controller2,
    this.textInputType,
    this.onChanged2,
    this.focusNode2,
    this.hint2,
    this.data2,
    this.onComplete2,
    this.textCapitalization,
    this.inputFormatter,
    this.needValidation = true,
  }) : super(key: key);

  @override
  _ProfileDataTileState createState() => _ProfileDataTileState();
}

class _ProfileDataTileState extends State<ProfileDataTile> {
  String? _data;
  String? _data2;

  bool validator = false;
  @override
  void initState() {
    if (widget.controller != null) {
      _data = null;
      widget.controller!.text = widget.data ?? "";
    } else {
      _data = widget.data;
    }
    if (widget.controller2 != null) {
      _data2 = null;
      widget.controller2!.text = widget.data2 ?? "";
    } else {
      _data2 = widget.data2;
    }

    super.initState();
  }

  @override
  Widget build(context) {
    if (widget.controller != null) {
      print("title: ${widget.title}");
      print("widget.controller: ${widget.controller!.text}");
    }
    return Listener(
      onPointerDown: (abc) => FocusScope.of(context).requestFocus(FocusNode()),
      child: Stack(
        children: [
          Container(
            width: maxWidth(context),
            // height: wXD(76, context),
            margin: EdgeInsets.symmetric(horizontal: wXD(23, context)),
            padding: EdgeInsets.fromLTRB(
              wXD(11, context),
              wXD(18, context),
              0,
              wXD(18, context),
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: getColors(context)
                            .onBackground
                            .withOpacity(.9)
                            .withOpacity(.2)))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: textFamily(
                    context,
                    color: getColors(context).onBackground,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                // SizedBox(height: wXD(3, context)),
                widget.onPressed == null
                    ? SizedBox(
                        width: wXD(321, context),
                        child: Row(
                          children: [
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(8, 8, 8, 9),
                                margin: EdgeInsets.only(top: wXD(4, context)),
                                decoration: widget.onChanged2 != null ||
                                        widget.data2 != null ||
                                        widget.controller2 != null
                                    ? BoxDecoration(
                                        color: getColors(context).surface,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(3)))
                                    : BoxDecoration(),
                                child: Material(
                                  color: Colors.transparent,
                                  child: TextFormField(
                                    enabled: widget.focusNode != null,
                                    keyboardType: widget.textInputType,
                                    controller: widget.controller,
                                    cursorColor: getColors(context).primary,
                                    // ignore: deprecated_member_use
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    initialValue: _data,
                                    focusNode: widget.focusNode,
                                    inputFormatters: widget.mask != null
                                        ? [widget.mask!]
                                        : widget.inputFormatter != null
                                            ? [widget.inputFormatter!]
                                            : [],
                                    style: textFamily(
                                      context,
                                      color: getColors(context).onBackground,
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration.collapsed(
                                      hintText: widget.hint,
                                      hintStyle: textFamily(
                                        context,
                                        color: getColors(context)
                                            .onBackground
                                            .withOpacity(.5),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    textCapitalization:
                                        widget.textCapitalization ??
                                            TextCapitalization.none,
                                    validator: (val) {
                                      // print("Title: ${widget.title}   Val: $val");
                                      String _text = '';
                                      if (widget.mask != null) {
                                        _text =
                                            widget.mask!.unmaskText(val ?? '');
                                      } else {
                                        _text = val ?? '';
                                      }
                                      // print("Text: $_text");
                                      if (_text == '' &&
                                          widget.needValidation) {
                                        return "Este campo não pode ser vazio!";
                                      } else if (widget.length != null &&
                                          widget.length != _text.length &&
                                          widget.needValidation) {
                                        return "Preencha o campo ${widget.title} por completo!";
                                      }
                                      if (widget.validator != null &&
                                          widget.needValidation) {
                                        String? value = widget.validator!(val);
                                        if (value != null) {
                                          return value;
                                        }
                                      }
                                    },
                                    onChanged: (txt) {
                                      String _text = txt;
                                      if (widget.mask != null) {
                                        // print("unmasked: ${mask!.unmaskText(txt)}");
                                        _text = widget.mask!.unmaskText(txt);
                                      }
                                      // print("_text: $_text");
                                      if (widget.onChanged != null) {
                                        widget.onChanged!(
                                            _text == '' ? null : _text);
                                      }
                                    },
                                    onEditingComplete: widget.onComplete,
                                  ),
                                ),
                              ),
                            ),
                            if (widget.onChanged2 != null ||
                                widget.data2 != null ||
                                widget.controller2 != null)
                              Container(
                                alignment: Alignment.center,
                                width: wXD(12, context),
                                child: Text(
                                  "-",
                                  style: textFamily(
                                    context,
                                    color: getColors(context).onBackground,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            if (widget.onChanged2 != null ||
                                widget.data2 != null ||
                                widget.controller2 != null)
                              Container(
                                margin: EdgeInsets.only(
                                    right: wXD(80, context),
                                    top: wXD(4, context)),
                                width: wXD(50, context),
                                padding: EdgeInsets.fromLTRB(8, 8, 8, 9),
                                decoration: BoxDecoration(
                                  color: getColors(context).surface,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(3)),
                                ),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: widget.controller2,
                                      enabled: widget.onChanged2 != null,
                                      keyboardType: widget.textInputType,
                                      cursorColor: getColors(context).primary,
                                      autovalidateMode: AutovalidateMode.always,
                                      initialValue: _data2,
                                      focusNode: widget.focusNode2,
                                      style: textFamily(
                                        context,
                                        color: getColors(context).onBackground,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      decoration: InputDecoration.collapsed(
                                        hintText: widget.hint2,
                                        hintStyle: textFamily(
                                          context,
                                          color: getColors(context)
                                              .onBackground
                                              .withOpacity(.5),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      validator: (txt) {
                                        if (widget.controller2 != null) {
                                          if (widget.controller2!.text == "" &&
                                              widget.needValidation) {
                                            validator = true;
                                            return "Erro";
                                          } else {
                                            validator = false;
                                            return null;
                                          }
                                        }
                                        if (txt == "" &&
                                            widget.needValidation) {
                                          validator = true;
                                          return "Erro";
                                        }
                                        validator = false;
                                        return null;
                                      },
                                      onChanged: (txt) {
                                        String _text = txt;
                                        if (txt == "" ||
                                            (widget.validate2 != null &&
                                                widget.validate2!)) {
                                          validator = true;
                                        } else {
                                          validator = false;
                                        }
                                        if (widget.mask != null) {
                                          // print("unmasked: ${mask!.unmaskText(txt)}");
                                          _text = widget.mask!.unmaskText(txt);
                                        }
                                        // print("_text: $_text");
                                        widget.onChanged2!(
                                            _text == '' ? null : _text);
                                      },
                                      onEditingComplete: widget.onComplete2,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 1,
                                      color: validator && widget.needValidation
                                          ? getColors(context).error
                                          : Colors.transparent,
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: widget.onPressed,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 9),
                              margin: EdgeInsets.only(top: wXD(4, context)),
                              child: Focus(
                                focusNode: widget.focusNode,
                                child: SizedBox(
                                  width: wXD(321, context),
                                  child: Text(
                                    widget.data ?? widget.hint,
                                    style: textFamily(
                                      context,
                                      color: widget.data != null
                                          ? getColors(context).onBackground
                                          : getColors(context)
                                              .onBackground
                                              .withOpacity(.9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // validate != null && validate!
                            //     ?
                            Visibility(
                              visible: widget.validate != null &&
                                  widget.validate! &&
                                  widget.needValidation,
                              child: Text(
                                "Este campo não pode ser vazio",
                                style: TextStyle(
                                  color: Colors.red[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            // : Container(),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          widget.focusNode != null
              ? Positioned(
                  top: wXD(18, context),
                  right: wXD(20, context),
                  child: InkWell(
                    onTap: () => widget.onPressed == null
                        ? widget.focusNode!.requestFocus()
                        : widget.onPressed!(),
                    child: Icon(
                      Icons.edit_outlined,
                      color: getColors(context).primary,
                      size: wXD(19, context),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
