import 'package:delivery_seller_white_label/app/core/services/auth/auth_store.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/color_theme.dart';
import '../../main/main_store.dart';
import '../home_store.dart';

class HomeCard extends StatefulWidget {
  @override
  _HomeCardState createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard>
    with SingleTickerProviderStateMixin {
  final MainStore mainStore = Modular.get();
  final HomeStore store = Modular.get();
  final AuthStore authStore = Modular.get();
  late AnimationController animationController;
  bool montantVisible = false;
  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 10000),
    );
    animationController.forward();
    animationController.addListener(() {
      // setState(() {
      store.nowDate = DateTime.now();
      if (animationController.status == AnimationStatus.completed) {
        animationController.repeat();
      }
      // });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: wXD(257, context),
        width: wXD(342, context),
        padding: EdgeInsets.symmetric(
            horizontal: wXD(21, context), vertical: wXD(14, context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          border: Border.all(color: Color(0xfff1f1f1)),
          color: getColors(context).surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: getColors(context).shadow,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   'Nível 1',
                //   style: textFamily(context,
                //     fontSize: 16,
                //     color: getColors(context).onBackground,
                //   ),
                // ),
                Spacer(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          montantVisible = !montantVisible;
                        });
                      },
                      child: Icon(
                        montantVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: getColors(context).onBackground,
                        size: wXD(25, context),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          montantVisible = !montantVisible;
                        });
                      },
                      child: FutureBuilder<num>(
                          future: store.getTotalAmount(),
                          builder: (context, snapshotFuture) {
                            // print(
                            //     'snapshotFuture: ${snapshotFuture.hasError} - ${snapshotFuture.hasData}');
                            if (snapshotFuture.hasError) {
                              print(snapshotFuture.error);
                            }
                            if (!snapshotFuture.hasData) {
                              return Container(
                                height: wXD(17, context),
                                width: wXD(98, context),
                                margin: EdgeInsets.only(left: wXD(3, context)),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  color: getColors(context)
                                      .onSurface
                                      .withOpacity(.3),
                                ),
                                child: LinearProgressIndicator(
                                  backgroundColor: getColors(context)
                                      .primary
                                      .withOpacity(0.7),
                                  color: getColors(context).primary,
                                ),
                              );
                            }

                            num totalAmount = snapshotFuture.data!;

                            return montantVisible
                                ? Text(
                                    ' R\$ ${formatedCurrency(totalAmount)}',
                                    style: textFamily(
                                      context,
                                      fontSize: 16,
                                      color: getColors(context).onBackground,
                                    ),
                                  )
                                : Container(
                                    height: wXD(17, context),
                                    width: wXD(98, context),
                                    margin:
                                        EdgeInsets.only(left: wXD(3, context)),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3)),
                                        color: getColors(context)
                                            .onSurface
                                            .withOpacity(.3)),
                                  );
                          }),
                    ),
                  ],
                )
              ],
            ),
            Container(
              height: wXD(160, context),
              width: wXD(160, context),
              child: GestureDetector(
                onTap: () => mainStore.changeSellerOn(),
                child: Stack(
                  fit: StackFit.loose,
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: wXD(160, context),
                      width: wXD(160, context),
                      // child: CustomPaint(
                      //   painter: ShadowPainter(),
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0)
                            .animate(animationController),
                        child: SizedBox(
                          height: wXD(160, context),
                          width: wXD(160, context),
                          // child: CustomPaint(
                          //   painter: Painter(),
                          // ),
                        ),
                      ),
                      // ),
                    ),
                    // AnimatedBuilder(
                    //   animation: animationController,
                    //   builder: (context, child) {
                    //     return
                    //      SizedBox(
                    //       height: wXD(160, context),
                    //       width: wXD(160, context),
                    //       child: CustomPaint(
                    //         painter: Painter(),
                    //       ),
                    //     );
                    //   },
                    // ),
                    Observer(builder: (context) {
                      String hour =
                          store.nowDate.hour.toString().padLeft(2, '0');
                      String minute =
                          store.nowDate.minute.toString().padLeft(2, '0');
                      return Text(
                        hour + ':' + minute,
                        style: GoogleFonts.montserrat(
                          fontSize: 44,
                          color: getColors(context).onBackground,
                          shadows: [
                            Shadow(
                              blurRadius: 0,
                              color:
                                  getColors(context).onSurface.withOpacity(.8),
                              offset: Offset(2, 0),
                            )
                          ],
                          fontWeight: FontWeight.normal,
                        ),
                      );
                    }),
                    Observer(builder: (context) {
                      return Positioned(
                        right: wXD(15, context),
                        bottom: wXD(8, context),
                        child: GestureDetector(
                          onTap: () {
                            // setState(() {
                            //   online = !online;
                            // });
                            mainStore.changeSellerOn();
                          },
                          child: Container(
                            height: wXD(25, context),
                            width: wXD(25, context),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: getColors(context).surface),
                                color: mainStore.sellerOn
                                    ? green
                                    : getColors(context).error),
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
            Observer(builder: (context) {
              return GestureDetector(
                onTap: () {
                  mainStore.changeSellerOn();
                  // setState(() {
                  //   online = !online;
                  // });
                },
                child: Text(
                  mainStore.sellerOn
                      ? 'Toque para ficar offline'
                      : 'Toque para ficar online',
                  style: textFamily(
                    context,
                    fontSize: 16,
                    color: getColors(context).onBackground,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// class ShadowPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     double radius = size.width / 2;
//     canvas.translate(size.width / 2, size.height / 2);
//     Path oval = Path()
//       ..addOval(Rect.fromCircle(center: Offset(0, 3), radius: radius));

//     Paint shadowPaint = Paint()
//       ..color = getColors(context).onBackground.withOpacity(.3)
//       ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 5;
//     canvas.drawPath(oval, shadowPaint);
//   }

//   @override
//   bool shouldRepaint(ShadowPainter oldDelegate) {
//     return false;
//   }
// }

// class Painter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     double radius = size.width / 2;
//     canvas.translate(size.width / 2, size.height / 2);
//     Offset center = Offset(0.0, 0.0);
//     // draw shadow first
//     // Path oval = Path()
//     //   ..addOval(Rect.fromCircle(center: Offset(0, 3), radius: radius));

//     // Paint shadowPaint = Paint()
//     //   ..color = getColors(context).onBackground.withOpacity(.3)
//     //   ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3)
//     //   ..style = PaintingStyle.stroke
//     //   ..strokeWidth = 5;
//     // canvas.drawPath(oval, shadowPaint);
//     // draw circle
//     Paint thumbPaint = Paint()
//       ..shader = LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.blue.shade800,
//                 Colors.red,
//                 Colors.yellow.shade700
//               ],
//               tileMode: TileMode.mirror)
//           .createShader(Rect.fromCircle(center: center, radius: radius))
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 5;
//     // canvas.drawCircle(center, radius, thumbPaint);
//     canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 50, 50,
//         false, thumbPaint);
//   }

//   @override
//   bool shouldRepaint(Painter oldDelegate) {
//     return false;
//   }
// }
