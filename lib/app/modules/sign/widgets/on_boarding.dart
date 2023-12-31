import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoarding extends StatefulWidget {
  OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController pageController = PageController();
  bool firstPage = true;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyleFromColor(getColors(context).surface),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: hXD(523, context),
              child: PageView(
                onPageChanged: (val) {
                  // print('val: $val');
                  if (val == 1) {
                    setState(() {
                      firstPage = false;
                    });
                  } else {
                    setState(() {
                      firstPage = true;
                    });
                  }
                },
                controller: pageController,
                children: [
                  WellCome(),
                  Delivery(),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: wXD(102, context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          pageController.animateToPage(0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                          setState(() {
                            firstPage = true;
                          });
                        },
                        child: Container(
                          height: wXD(8, context),
                          width: wXD(47, context),
                          decoration: BoxDecoration(
                            color: getColors(context).primary.withOpacity(.32),
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          print('pageController: ${pageController.page}');
                          pageController.animateToPage(1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                          setState(() {
                            firstPage = false;
                          });
                        },
                        child: Container(
                          height: wXD(8, context),
                          width: wXD(47, context),
                          decoration: BoxDecoration(
                            color: getColors(context).primary.withOpacity(.32),
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedPositioned(
                  left: firstPage ? 0 : wXD(55, context),
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    height: wXD(8, context),
                    width: wXD(47, context),
                    decoration: BoxDecoration(
                      color: getColors(context).primary,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            SideButton(
              onTap: () async {
                // print('pageController: ${pageController.page}');
                if (pageController.page == 0) {
                  pageController.animateToPage(1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease);
                } else {
                  Modular.to.pushReplacementNamed("/main/");
                  // await Modular.to.pushNamed('/sign');
                  pageController.jumpToPage(0);
                }
              },
              child: Icon(
                Icons.arrow_forward,
                size: wXD(25, context),
                color: getColors(context).onPrimary,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class WellCome extends StatelessWidget {
  const WellCome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Text(
          'Bem vindo!',
          style: GoogleFonts.montserrat(
            color: getColors(context).onBackground.withOpacity(.8),
            fontStyle: FontStyle.italic,
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: wXD(10, context)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: wXD(30, context)),
          child: Text(
            'Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,\n sed do eiusmod',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: getColors(context).onBackground,
              fontStyle: FontStyle.italic,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Spacer(),
        Image.asset(
          brightness == Brightness.light
              ? "./assets/images/logo.png"
              : "./assets/images/logo_dark.png",
          height: wXD(240, context),
          fit: BoxFit.fill,
        ),
        Spacer(),
      ],
    );
  }
}

class Delivery extends StatelessWidget {
  const Delivery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Text(
          'Lorem',
          style: GoogleFonts.montserrat(
            color: getColors(context).onBackground.withOpacity(.8),
            fontStyle: FontStyle.italic,
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: wXD(10, context)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: wXD(30, context)),
          child: Text(
            'Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,\n sed do eiusmod',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: getColors(context).onBackground,
              fontStyle: FontStyle.italic,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Spacer(),
        Image.asset(
          brightness == Brightness.light
              ? "./assets/images/logo.png"
              : "./assets/images/logo_dark.png",
          height: wXD(240, context),
          fit: BoxFit.fill,
        ),
        Spacer(),
      ],
    );
  }
}
