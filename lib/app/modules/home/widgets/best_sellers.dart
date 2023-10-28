import 'package:cached_network_image/cached_network_image.dart';

import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';

class BestSellers extends StatelessWidget {
  const BestSellers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('BestSellers');
    List products = [
      {
        'name': 'Samsung Falaxy A51+aaaaaa aaaaaa aaaaa',
        'description':
            'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum ',
        'image': '',
        'grade': 1250.0,
      },
      {
        'name': 'Samsung Falaxy A51+',
        'description':
            'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum ',
        'grade': 1250.0,
        'image': 'https://t2.tudocdn.net/518979?w=660&h=643',
      },
      {
        'name': 'Samsung Falaxy A51+',
        'description':
            'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum ',
        'grade': 1250.0,
        'image': 'https://t2.tudocdn.net/518979?w=660&h=643',
      },
      {
        'name': 'Samsung Falaxy A51+',
        'description':
            'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum ',
        'grade': 1250.0,
        'image': 'https://t2.tudocdn.net/518979?w=660&h=643',
      },
      {
        'name': 'Samsung Falaxy A51+',
        'description':
            'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum ',
        'grade': 1250.0,
        'image': 'https://t2.tudocdn.net/518979?w=660&h=643',
      },
    ];
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: wXD(90, context)),
                Container(
                  padding: EdgeInsets.only(
                      left: wXD(14, context),
                      right: wXD(11, context),
                      bottom: wXD(18, context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Últimos 30 dias',
                          style: textFamily(
                            context,
                            fontSize: 17,
                            color: getColors(context).onBackground,
                          )),
                      Icon(
                        Icons.filter_alt_outlined,
                        size: wXD(22, context),
                        color: getColors(context).onBackground,
                      )
                    ],
                  ),
                ),
                ...products.map(
                  (product) => Product(
                    requestDate: 'Qua 25 outubro 2020',
                    name: product['name'],
                    image: product['image'],
                    price: product['grade'],
                    description: product['description'],
                  ),
                ),
              ],
            ),
          ),
          DefaultAppBar('Mais Vendidos'),
        ],
      ),
    );
  }
}

class Product extends StatelessWidget {
  final String name, description, image, requestDate;
  final double price;
  // final void Function() onTap;
  Product({
    Key? key,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.requestDate,
    // required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: wXD(105, context),
        width: wXD(352, context),
        margin: EdgeInsets.only(bottom: wXD(10, context)),
        padding: EdgeInsets.fromLTRB(
          wXD(19, context),
          wXD(15, context),
          wXD(15, context),
          wXD(7, context),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffF1F1F1)),
          borderRadius: BorderRadius.all(Radius.circular(3)),
          color: getColors(context).surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(0, 3),
              color: getColors(context).shadow,
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: wXD(12, context)),
              child: ClipRRect(
                child: image == ''
                    ? Image.asset(
                        'assets/images/no-image-icon.png',
                        height: wXD(65, context),
                        width: wXD(62, context),
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: image,
                        height: wXD(65, context),
                        width: wXD(62, context),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: wXD(8, context)),
              width: wXD(220, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: textFamily(context,
                        color: getColors(context).onBackground),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: wXD(3, context)),
                  Text(
                    description,
                    style: textFamily(context,
                        color: getColors(context).onSurface, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: wXD(3, context)),
                  Text(
                    'R\$ $price',
                    style:
                        textFamily(context, color: getColors(context).primary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // RatingBar(
                  //   initialRating: grade,
                  //   onRatingUpdate: (value) {},
                  //   ignoreGestures: true,
                  //   glowColor: getColors(context).primary.withOpacity(.4),
                  //   unratedColor:
                  //       getColors(context).primary.withOpacity(.4),
                  //   allowHalfRating: true,
                  //   itemSize: wXD(25, context),
                  //   ratingWidget: RatingWidget(
                  //     full: Icon(Icons.star_rounded,
                  //         color: getColors(context).primary),
                  //     empty: Icon(Icons.star_outline_rounded,
                  //         color: getColors(context).primary),
                  //     half: Icon(Icons.star_half_rounded,
                  //         color: getColors(context).primary),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
