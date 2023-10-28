import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/models/category_model.dart';
import '../../../shared/utilities.dart';
import '../../../shared/widgets/white_button.dart';

class EditCategoryOverlay extends StatefulWidget {
  final Category category;
  final void Function() onBack;
  final void Function() onDelete;
  final void Function() onEdit;
  final void Function() onCategories;
  EditCategoryOverlay({
    Key? key,
    required this.category,
    required this.onBack,
    required this.onDelete,
    required this.onEdit,
    required this.onCategories,
  }) : super(key: key);

  @override
  State<EditCategoryOverlay> createState() => _EditCategoryOverlayState();
}

class _EditCategoryOverlayState extends State<EditCategoryOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.animateTo(1,
        duration: Duration(milliseconds: 400), curve: Curves.easeOutQuint);
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
        // print("_controller.value: ${_controller.value}");
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _controller.value + 0.001,
                sigmaY: _controller.value + 0.001,
              ),
              child: GestureDetector(
                onTap: () async {
                  await _controller.animateBack(0,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeOutQuint);
                  widget.onBack();
                },
                child: Container(
                  height: maxHeight(context),
                  width: maxWidth(context),
                  color: getColors(context).shadow,
                ),
              ),
            ),
            Positioned(
              top: maxHeight(context) - (wXD(164, context) * _controller.value),
              child: Container(
                width: maxWidth(context),
                height: wXD(164, context),
                decoration: BoxDecoration(
                  color: getColors(context).surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      offset: Offset(0, -5),
                      color: Color(0x70000000),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Material(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                  color: getColors(context).surface,
                  child: Column(
                    children: [
                      SizedBox(height: wXD(16, context)),
                      Container(
                        width: wXD(300, context),
                        alignment: Alignment.center,
                        child: Text(
                          widget.category.label,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: textFamily(
                            context,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: getColors(context).onBackground,
                          ),
                        ),
                      ),
                      SizedBox(height: wXD(16, context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          WhiteButton(
                            text: 'Excluir',
                            icon: Icons.delete_outline,
                            onTap: widget.onDelete,
                          ),
                          WhiteButton(
                            text: 'Editar',
                            icon: Icons.edit_outlined,
                            onTap: widget.onEdit,
                          ),
                          WhiteButton(
                            text: 'Detalhar',
                            icon: Icons.category_outlined,
                            onTap: widget.onCategories,
                          ),
                        ],
                      ),
                      SizedBox(height: wXD(13, context)),
                      InkWell(
                        onTap: widget.onBack,
                        child: Text(
                          'Cancelar',
                          style: textFamily(context,
                              fontWeight: FontWeight.w500,
                              color: getColors(context).error),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
