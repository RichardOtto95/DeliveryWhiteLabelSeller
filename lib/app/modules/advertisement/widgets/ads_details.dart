import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'dart:math' as math;
import '../../../core/models/additional_model.dart';
import '../../main/main_store.dart';
import '../advertisement_store.dart';

class AdsDetails extends StatefulWidget {
  AdsDetails({Key? key}) : super(key: key);

  @override
  _AdsDetailsState createState() => _AdsDetailsState();
}

class _AdsDetailsState extends State<AdsDetails> {
  final AdvertisementStore store = Modular.get();

  final CurrencyTextInputFormatter _formatter =
    CurrencyTextInputFormatter(symbol: 'R\$');

  FocusNode titleFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: wXD(17, context), bottom: wXD(9, context)),
            child: Text(
              'Título do anúncio*',
              style: textFamily(
                context,
                fontSize: 15,
                color: getColors(context).onBackground,
              ),
            ),
          ),
          Center(
            child: Container(
              height: wXD(52, context),
              width: wXD(342, context),
              decoration: BoxDecoration(
                color: getColors(context).surface,
                border: Border.all(color: getColors(context).primary),
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
              padding: EdgeInsets.symmetric(horizontal: wXD(12, context)),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                initialValue:
                    store.editingAd ? store.adEdit.title : store.adsTitle,
                focusNode: titleFocus,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Escreva um título válido';
                  }
                  return null;
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Ex: Samsung Galaxy S9',
                ),
                onChanged: (val) {
                  print('title: $val');
                  store.editingAd
                      ? store.adEdit.title = val
                      : store.setAdsTitle(val);
                },
                onEditingComplete: () => descriptionFocus.requestFocus(),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: wXD(35, context),
                left: wXD(17, context),
                bottom: wXD(9, context)),
            child: Text('Descrição*',
                style: textFamily(
                  context,
                  fontSize: 15,
                  color: getColors(context).onBackground,
                )),
          ),
          Center(
            child: Container(
              height: wXD(123, context),
              width: wXD(342, context),
              decoration: BoxDecoration(
                color: getColors(context).surface,
                border: Border.all(color: getColors(context).primary),
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: wXD(12, context),
                vertical: wXD(20, context),
              ),
              alignment: Alignment.topLeft,
              child: TextFormField(
                initialValue: store.editingAd
                    ? store.adEdit.description
                    : store.adsDescription,
                focusNode: descriptionFocus,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Escreva uma descrição válida';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLines: 5,
                decoration: InputDecoration.collapsed(
                  hintText:
                      'Ex: Samsung Galaxy S9 com 128gb de memória, com caixa, todos os cabos e sem marca de uso.',
                  hintStyle: textFamily(context,
                      fontSize: 14,
                      color: getColors(context).onBackground.withOpacity(.7)),
                ),
                onChanged: (val) {
                  print('description: $val');
                  store.editingAd
                      ? store.adEdit.description = val
                      : store.setAdsDescription(val);
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: wXD(35, context),
                left: wXD(17, context),
                bottom: wXD(9, context)),
            child: Text(
              'Categoria*',
              style: textFamily(
                context,
                fontSize: 15,
                color: getColors(context).onBackground,
              ),
            ),
          ),
          Center(
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(3)),
              onTap: () =>
                  Modular.to.pushNamed('/advertisement/choose-category'),
              child: Container(
                height: wXD(52, context),
                width: wXD(342, context),
                decoration: BoxDecoration(
                  color: getColors(context).surface,
                  border: Border.all(color: getColors(context).primary),
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                padding: EdgeInsets.only(
                    left: wXD(12, context), right: wXD(15, context)),
                child: Row(
                  children: [
                    Observer(builder: (context) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.editingAd
                                ? '${store.adEdit.category}        ${store.adEdit.option}'
                                : store.adsCategory == ''
                                    ? 'Selecione uma categoria'
                                    : '${store.adsCategory}        ${store.adsOption}',
                            style: textFamily(context,
                                fontSize: 14,
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.7)),
                          ),
                          Visibility(
                            visible: store.categoryValidateVisible,
                            child: Text(
                              store.getCategoryValidateText(),
                              style: textFamily(
                                context,
                                fontSize: 11,
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: getColors(context).primary,
                      size: wXD(17, context),
                    ),
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: wXD(35, context),
                left: wXD(17, context),
                bottom: wXD(9, context)),
            child: Text('Tipo*',
                style: textFamily(
                  context,
                  fontSize: 15,
                  color: getColors(context).onBackground,
                )),
          ),
          Center(
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(3)),
              onTap: () => store.setSearchType(true),
              child: Container(
                height: wXD(52, context),
                width: wXD(342, context),
                decoration: BoxDecoration(
                  color: getColors(context).surface,
                  border: Border.all(color: getColors(context).primary),
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                padding: EdgeInsets.only(
                    left: wXD(12, context), right: wXD(15, context)),
                child: Row(
                  children: [
                    Observer(builder: (context) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.editingAd
                                ? store.adEdit.type
                                : store.adsType == ''
                                    ? 'Selecione o tipo'
                                    : store.adsType,
                            style: textFamily(context,
                                fontSize: 14,
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.7)),
                          ),
                          Visibility(
                            visible: store.typeValidateVisible,
                            child: Text(
                              'Selecione um tipo',
                              style: textFamily(
                                context,
                                fontSize: 11,
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    Spacer(),
                    Transform.rotate(
                      angle: math.pi / 2,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: getColors(context).primary,
                        size: wXD(17, context),
                      ),
                    ),
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
          //  Padding(
          //   padding: EdgeInsets.only(
          //     top: wXD(35, context),
          //     left: wXD(17, context),
          //     bottom: wXD(20, context),
          //   ),
          //   child: Text('Novo/Usado*',
          //     style: textFamily(
          //       context,
          //       fontSize: 15,
          //       color: getColors(context).onBackground,
          //     ),
          //   ),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     Observer(
          //       builder: (context) {
          //         return GestureDetector(
          //           onTap: () {
          //             store.editingAd
          //               ? setState(() {
          //                   store.adEdit.isNew = true;
          //                 })
          //               : store.setAdsIsNew(true);
          //             print('STORE isNew ? ${store.adsIsNew}');
          //           },
          //           child: Container(
          //             height: wXD(32, context),
          //             width: wXD(155, context),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(Radius.circular(3)),
          //               color: store.editingAd
          //                   ? store.adEdit.isNew
          //                       ? getColors(context).primary
          //                       : getColors(context).surface
          //                   : store.adsIsNew
          //                       ? getColors(context).primary
          //                       : getColors(context).surface,
          //               border: Border.all(
          //                 color: store.editingAd
          //                     ? store.adEdit.isNew
          //                         ? Colors.transparent
          //                         : getColors(context).onSurface.withOpacity(.8)
          //                     : store.adsIsNew
          //                         ? Colors.transparent
          //                         : getColors(context)
          //                             .onSurface
          //                             .withOpacity(.8),
          //               ),
          //               boxShadow: [
          //                 BoxShadow(
          //                   blurRadius: 4,
          //                   offset: Offset(0, 4),
          //                   color: getColors(context).shadow,
          //                 ),
          //               ],
          //             ),
          //             alignment: Alignment.center,
          //             child: Text(
          //               'Novo',
          //               style: textFamily(
          //                 context,
          //                 color: store.editingAd
          //                     ? store.adEdit.isNew
          //                         ? getColors(context).surface
          //                         : getColors(context).onBackground
          //                     : store.adsIsNew
          //                         ? getColors(context).surface
          //                         : getColors(context).onBackground,
          //               ),
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //     Observer(
          //       builder: (context) {
          //         return GestureDetector(
          //           onTap: () {
          //             store.editingAd
          //                 ? setState(() {
          //                     store.adEdit.isNew = false;
          //                   })
          //                 : store.setAdsIsNew(false);
          //             print('STORE isNew ? ${store.adsIsNew}');
          //           },
          //           child: Container(
          //             height: wXD(32, context),
          //             width: wXD(155, context),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(Radius.circular(3)),
          //               color: store.editingAd
          //                   ? !store.adEdit.isNew
          //                       ? getColors(context).primary
          //                       : getColors(context).surface
          //                   : !store.adsIsNew
          //                       ? getColors(context).primary
          //                       : getColors(context).surface,
          //               border: Border.all(
          //                 color: store.editingAd
          //                     ? !store.adEdit.isNew
          //                         ? Colors.transparent
          //                         : getColors(context).onSurface.withOpacity(.8)
          //                     : !store.adsIsNew
          //                         ? Colors.transparent
          //                         : getColors(context)
          //                             .onSurface
          //                             .withOpacity(.8),
          //               ),
          //               boxShadow: [
          //                 BoxShadow(
          //                   blurRadius: 4,
          //                   offset: Offset(0, 4),
          //                   color: getColors(context).shadow,
          //                 ),
          //               ],
          //             ),
          //             alignment: Alignment.center,
          //             child: Text(
          //               'Usado',
          //               style: textFamily(
          //                 context,
          //                 color: store.editingAd
          //                     ? !store.adEdit.isNew
          //                         ? getColors(context).surface
          //                         : getColors(context).onBackground
          //                     : !store.adsIsNew
          //                         ? getColors(context).surface
          //                         : getColors(context).onBackground,
          //               ),
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ],
          // ),
          Padding(
            padding: EdgeInsets.only(
              top: wXD(35, context),
              left: wXD(17, context),
              bottom: wXD(9, context),
            ),
            child: Text(
              'Quantidade de itens',
              style: textFamily(
                context,
                fontSize: 15,
                color: getColors(context).onBackground,
              ),
            ),
          ),
          Container(
            height: wXD(52, context),
            width: wXD(171, context),
            decoration: BoxDecoration(
              color: getColors(context).surface,
              border: Border.all(color: getColors(context).primary),
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            padding: EdgeInsets.symmetric(horizontal: wXD(12, context)),
            margin: EdgeInsets.only(left: wXD(17, context)),
            child: TextFormField(
              initialValue: '${store.adEdit.amount}',
              keyboardType: TextInputType.number,
              validator: (val) {
                print('val price: $val');
                if (val == null || val.isEmpty || num.parse(val) == 0) {
                  return 'Escreva uma quantidade válida';
                }
                return null;
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Digite a quantidade',
              ),
              onChanged: (val) {
                if (val == "") {
                  store.editingAd
                  ? store.adEdit.amount = 0
                  : store.adsQntdd = 0;                  
                } else {
                  store.editingAd
                  ? store.adEdit.amount = num.parse(val)
                  : store.adsQntdd = num.parse(val);
                }                
              },
            ),
            alignment: Alignment.centerLeft,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: wXD(35, context),
                left: wXD(17, context),
                bottom: wXD(9, context)),
            child: Text('Preço do produto (R\$)',
                style: textFamily(
                  context,
                  fontSize: 15,
                  color: getColors(context).onBackground,
                )),
          ),
          Container(
            height: wXD(52, context),
            width: wXD(171, context),
            decoration: BoxDecoration(
              color: getColors(context).surface,
              border: Border.all(color: getColors(context).primary),
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            padding: EdgeInsets.symmetric(horizontal: wXD(12, context)),
            margin: EdgeInsets.only(left: wXD(17, context)),
            child: TextFormField(
              // initialValue: store.editingAd
              //     ? _formatter.format((store.adEdit.sellerPrice * 10).toString())
              //     : null,
              initialValue: 'R\$ ${formatedCurrency(store.adEdit.totalPrice)}',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: [_formatter],
              keyboardType: TextInputType.number,
              validator: (val) {
                print('val price: $val');
                if (val!.isEmpty || val == "R\$ 0,00") {
                  return 'Escreva um preço válido';
                }
                return null;
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Digite o seu preço',
              ),
              onChanged: (val) {
                print('price: ${_formatter.getUnformattedValue()}');
                store.getFinalPrice(_formatter.getUnformattedValue());
              },
            ),
            alignment: Alignment.centerLeft,
          ),
          Container(
            width: maxWidth(context),
            padding: EdgeInsets.only(
              left: wXD(17, context),
              right: wXD(17, context),
              // bottom: wXD(12, context),
            ),
            alignment: Alignment.topLeft,
            child: Observer(
              builder: (context) {
                return Column(
                  children: store.checkedAdditionalList.map((element) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('sellers').doc(user.uid).collection('additional').doc(element).get(),
                      builder: (context, snapshotFutureDoc) {
                        if(!snapshotFutureDoc.hasData){
                          return Container();
                        }
                        DocumentSnapshot additionalDoc = snapshotFutureDoc.data!;
                        if(additionalDoc['seller_config'] != "edition") {
                          return Container();
                        }

                        switch (additionalDoc['type']) {
                          case "text-field":
                            return TextFieldScore(
                              model: AdditionalModel.fromDoc(additionalDoc),
                            );

                          case "text-area":
                            return TextArea(
                              model: AdditionalModel.fromDoc(additionalDoc),
                            );

                          case "increment":
                            return IncrementField(
                              model: AdditionalModel.fromDoc(additionalDoc),
                            );

                          case "text":
                            return TextScore(
                              model: AdditionalModel.fromDoc(additionalDoc),
                            );

                          case "check-box":
                            return CheckBoxArray(
                              model: AdditionalModel.fromDoc(additionalDoc),
                            );

                          case "radio-button":
                            return RadioButtonArray(
                              model: AdditionalModel.fromDoc(additionalDoc),
                            );

                          case "combo-box":
                            return DropdownArray(
                              model: AdditionalModel.fromDoc(additionalDoc),
                            );

                          default:
                            return Container();
                        }
                      }
                    );
                  }).toList(),
                );
              }
            ),
          ),
        ],
      );
    });
  }

  String getDeliveryTypeText(
      {required bool editing,
      required String deliveryTypeEdit,
      required String deliveryType}) {
    if (editing && deliveryTypeEdit != '') {
      switch (deliveryTypeEdit) {
        case "moto":
          return "Moto";

        case "car":
          return "Carro";

        case "sedan":
          return "Carro sedan";

        case "utility":
          return "Utilitário";

        default:
          return '';
      }
    } else {
      switch (deliveryType) {
        case "moto":
          return "Moto";

        case "car":
          return "Carro";

        case "sedan":
          return "Carro sedan";

        case "utility":
          return "Utilitário";

        case "":
          return "Selecione um veículo";

        default:
          return '';
      }
    }
  }
}

class RadioButtonArray extends StatefulWidget {
  final AdditionalModel model;

  RadioButtonArray({Key? key, required this.model}) : super(key: key);

  @override
  State<RadioButtonArray> createState() => _RadioButtonArrayState();
}

class _RadioButtonArrayState extends State<RadioButtonArray> {
  final MainStore mainStore = Modular.get();
  final AdvertisementStore store = Modular.get();
  int groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: wXD(15, context),
        top: wXD(15, context),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: store.getRadiobuttonList(widget.model.id),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            print(snapshot.error);
          }
          if(!snapshot.hasData){
            return LinearProgressIndicator();
          }
          List<Map<String, dynamic>> radiobuttonArray = snapshot.data!;
          for (var i = 0; i < radiobuttonArray.length; i++) {
            Map map = radiobuttonArray[i];
            if(map['selected']){
              groupValue = i;
              break;
            }            
          }
          if(!store.additionalResponse.containsKey(widget.model.id)){
            Map<String, dynamic> radiobuttonMap = radiobuttonArray[0];
            store.additionalResponse.putIfAbsent(widget.model.id, () => {
              "response_label": radiobuttonMap['label'],
              "response_value": radiobuttonMap['value'],
              "response_index": radiobuttonMap['index'],
            });
          }

          print('store.additionalResponse: ${store.additionalResponse[widget.model.id]}');

          return StatefulBuilder(
            builder: (context, refresh) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      // left: wXD(15, context),
                    ),
                    child: Text(
                      widget.model.title,
                      style: textFamily(context,
                        fontSize: 15,
                        color: getColors(context).onBackground,
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(
                      radiobuttonArray.length,
                      (i) {
                        Map<String, dynamic> radiobuttonMap = radiobuttonArray[i];
                        return Row(
                          children: [
                            Radio(
                              activeColor: colors.primary,
                              value: i,
                              groupValue: groupValue, 
                              onChanged: (int? value) {
                                refresh((){
                                  groupValue = i;
                                });
                                store.additionalResponse.update(widget.model.id, (value) => {
                                  "response_label": radiobuttonMap['label'],
                                  "response_value": radiobuttonMap['value'],
                                  "response_index": radiobuttonMap['index'],
                                });
                              },
                            ),
                            Expanded(
                              child: Text(radiobuttonMap['label']),
                            ),
                            SizedBox(width: wXD(15, context),),
                            Container(
                              width: wXD(100, context),
                              child: Text('R\$ ${formatedCurrency(radiobuttonMap['value'])}'),
                              alignment: Alignment.centerLeft,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          );
        }
      ),
    );
  }
}

class TextFieldScore extends StatefulWidget {
  final AdditionalModel model;

  TextFieldScore({Key? key, required this.model}) : super(key: key);

  @override
  State<TextFieldScore> createState() => _TextFieldScoreState();
}

class _TextFieldScoreState extends State<TextFieldScore> {
  final AdvertisementStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: mainStore.getColumnAlignment(widget.model.alignment),
      children: [
        Padding(
          padding: EdgeInsets.only(
            // left: wXD(15, context),
            top: wXD(15, context),
          ),
          child: Text(
            getText(widget.model.title, widget.model.mandatory),
            style: textFamily(context,
              fontSize: 15,
              color: getColors(context).onBackground,
            ),
          ),
        ),
        SizedBox(height: wXD(5, context),),
        FutureBuilder<dynamic>(
          future: store.getInitialValue(widget.model.id),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Container();
            }
            print('initialValue: $initialValue');
            String snapshotData = snapshot.data;
            initialValue = snapshotData == "" ? null : snapshotData;
            return Container(
              // width: maxWidth(context),
              // alignment: Alignment.centerLeft,
              child: Container(
                width: widget.model.short == false ? maxWidth(context) /2 : maxWidth(context),
                // margin: EdgeInsets.symmetric(
                //     horizontal: wXD(15, context)),
                padding: EdgeInsets.symmetric(
                    horizontal: wXD(8, context),
                    vertical: wXD(5, context)),
                // height: wXD(200, context),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: getColors(context).primary),
                  borderRadius:
                      BorderRadius.all(Radius.circular(12)),
                ),
                child: TextFormField(
                  maxLines: 1,
                  initialValue: initialValue,
                  decoration: InputDecoration.collapsed(
                    hintText: widget.model.hint,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String? value){
                    if(value == null || value == "" && widget.model.mandatory == true){
                      return "Preencha corretamente";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (String value){
                    if(!store.additionalResponse.containsKey(widget.model.id)){
                      store.additionalResponse.putIfAbsent(widget.model.id, () => {
                        "response_text": value,
                      });
                    } else {
                      store.additionalResponse.update(widget.model.id, (valueMap) => {
                        "response_text": value,
                      });
                    }
                  },
                ),
              ),
            );
          }
        ), 
      ],
    );
  }

  getText(String title, bool? mandatory){
    if(mandatory == null || mandatory == false){
      return title;
    } else {
      return title + "*";
    }
  }
}

class TextArea extends StatefulWidget {
  final AdditionalModel model;

  TextArea({Key? key, required this.model}) : super(key: key);

  @override
  State<TextArea> createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  final AdvertisementStore store = Modular.get();
  String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: wXD(15, context),
            top: wXD(15, context),
          ),
          child: Text(
            getText(widget.model.title, widget.model.mandatory),
            style: textFamily(context,
              fontSize: 15,
              color: getColors(context).onBackground,
            ),
          ),
        ),
        SizedBox(height: wXD(5, context),),
        FutureBuilder<dynamic>(
          future: store.getInitialValue(widget.model.id),
          builder: (context, snapshot) {
            print('snapshot.data: ${snapshot.hasData}');

            if(!snapshot.hasData){
              return Container();
            }
            String snapshotData = snapshot.data;
            initialValue = snapshotData == "" ? null : snapshotData;
            print('initialValue: $initialValue');
            return Container(
              width: maxWidth(context),
              margin: EdgeInsets.symmetric(
                  horizontal: wXD(15, context)),
              padding: EdgeInsets.symmetric(
                  horizontal: wXD(8, context),
                  vertical: wXD(5, context)),
              height: wXD(200, context),
              decoration: BoxDecoration(
                border:
                    Border.all(color: getColors(context).primary),
                borderRadius:
                    BorderRadius.all(Radius.circular(12)),
              ),
              child: TextFormField(
                initialValue: initialValue,
                maxLines: 5,
                decoration: InputDecoration.collapsed(
                  hintText: widget.model.hint,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value){
                  if(value == null || value == "" && widget.model.mandatory!){
                    return "Preencha corretamente";
                  } else {
                    return null;
                  }
                },
                onChanged: (String value) {
                  if(!store.additionalResponse.containsKey(widget.model.id)){
                    store.additionalResponse.putIfAbsent(widget.model.id, () => {
                      "response_text": value,
                    });
                  } else {
                    store.additionalResponse.update(widget.model.id, (valueMap) => {
                      "response_text": value,
                    });
                  }
                  // print('store.additionalResponse: ${store.additionalResponse[widget.model.id]}');
                },
              ),
            );
          }
        ), 
      ],
    );
  }

  getText(String title, bool? mandatory){
    if(mandatory == null || mandatory == false){
      return title;
    } else {
      return title + "*";
    }
  }
}

class IncrementField extends StatefulWidget {
  final AdditionalModel model;

  IncrementField({Key? key, required this.model}) : super(key: key);

  @override
  State<IncrementField> createState() => _IncrementFieldState();
}

class _IncrementFieldState extends State<IncrementField> {
  final AdvertisementStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  num count = 0;

  @override
  Widget build(BuildContext context) {
    if(!store.additionalResponse.containsKey(widget.model.id)){
      count = widget.model.incrementMinimum!;
      store.additionalResponse.putIfAbsent(widget.model.id, () => {
        "response_count": widget.model.incrementMinimum,
        "response_value": widget.model.incrementValue,
      });
    }
    if(count > widget.model.incrementMinimum!){
      count = widget.model.incrementMinimum!;
    }
    return StatefulBuilder(
      builder: (context, refresh) {
        return Container(
          margin: EdgeInsets.only(top: wXD(15, context)),
          child: Column(
            crossAxisAlignment: mainStore.getColumnAlignment(widget.model.alignment),
            children: [
              Text(
                widget.model.title,
                style: textFamily(context,
                  fontSize: 15,
                  color: getColors(context).onBackground,
                ),
              ),
              Row(
                mainAxisAlignment: mainStore.getRowAlignment(widget.model.alignment),
                children: [                 
                  Container(
                    height: wXD(25, context),
                    width: wXD(88, context),
                    margin: EdgeInsets.only(top: wXD(4, context)),
                    padding:
                        EdgeInsets.symmetric(horizontal: wXD(4, context)),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: getColors(context).onSurface.withOpacity(.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            if(count > widget.model.incrementMinimum!){
                              refresh((){
                                count--;
                              });
                              store.additionalResponse.update(widget.model.id, (value) => {
                                "response_count": count,
                                "response_value": widget.model.incrementValue! * count,
                              });
                            }
                          },
                          child: Icon(
                            Icons.remove,
                            size: wXD(20, context),
                            color: count > widget.model.incrementMinimum! ? 
                            getColors(context).primary :
                            getColors(context).primary.withOpacity(.4),
                          ),
                        ),
                        Container(
                          width: wXD(32, context),
                          height: wXD(25, context),
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                              vertical: BorderSide(
                                color: getColors(context)
                                  .onSurface
                                  .withOpacity(.3),
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            count.toString(),
                            style: textFamily(context,
                                color: getColors(context).primary),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            if(count < widget.model.incrementMaximum!){                            
                              refresh((){
                                count++;
                              });
                              store.additionalResponse.update(widget.model.id, (value) => {
                                "response_count": count,
                                "response_value": widget.model.incrementValue! * count,
                              });
                            }
                          },
                          child: Icon(
                            Icons.add,
                            size: wXD(20, context),
                            color: count < widget.model.incrementMaximum! ? 
                            getColors(context).primary :
                            getColors(context).primary.withOpacity(.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: wXD(10, context),
                  ),
                  Text(
                    "R\$ ${formatedCurrency(widget.model.incrementValue! * count)}",
                    style: textFamily(context,
                      fontSize: 15,
                      color: getColors(context).onBackground,
                    ),
                  ),
                ],
              ),
              SizedBox(height: wXD(10, context),),              
            ],
          ),
        );
      }
    );
  }
}

class TextScore extends StatelessWidget {
 final AdditionalModel model;
  final MainStore mainStore = Modular.get();

  TextScore({Key? key, required this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: mainStore.getColumnAlignment(model.alignment),
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: wXD(15, context),
            top: wXD(15, context),
            bottom: wXD(15, context),
          ),
          child: Text(
            model.title,
            style: textFamily(context,
              fontSize: model.fontSize.toDouble(),
              color: getColors(context).onBackground,
            ),
          ),
        ),
      ],
    );
  }
}

class CheckBoxArray extends StatefulWidget {
  final AdditionalModel model;

  CheckBoxArray({Key? key, required this.model}) : super(key: key);

  @override
  State<CheckBoxArray> createState() => _CheckBoxArrayState();
}

class _CheckBoxArrayState extends State<CheckBoxArray> {
  final AdvertisementStore store = Modular.get();

  Map<String, bool> checkedMap = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: wXD(15, context),
        top: wXD(15, context),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: store.getCheckboxList(widget.model.id),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return LinearProgressIndicator();
          }
          List<Map<String, dynamic>> checkboxArray = snapshot.data!;
          for (var i = 0; i < checkboxArray.length; i++) {
            Map<String, dynamic> checkboxMap = checkboxArray[i];
            checkedMap.putIfAbsent(checkboxMap['id'], () => checkboxMap['response']);
          }
          store.additionalResponse.putIfAbsent(widget.model.id, () => checkedMap);
          return StatefulBuilder(
            builder: (context, refresh) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      // left: wXD(15, context),
                    ),
                    child: Text(
                      widget.model.title,
                      style: textFamily(context,
                        fontSize: 15,
                        color: getColors(context).onBackground,
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(
                      checkboxArray.length,
                      (i) {
                        Map<String, dynamic> checkboxMap = checkboxArray[i];
                        return Row(
                          children: [
                            Checkbox(
                              activeColor: colors.primary,
                              value: checkedMap[checkboxMap['id']],
                              onChanged: (bool? value){
                                refresh(() {
                                  print('checkedMap: $checkedMap');
                                  checkedMap.update(checkboxMap['id'], (val) => !val);
                                  store.additionalResponse.update(widget.model.id, (value) => checkedMap);
                                  print('checkedMap: $checkedMap');
                                });
                              },
                            ),
                            Expanded(child: Text(checkboxMap['label'])),
                            SizedBox(width: wXD(15, context),),
                            Container(
                              width: wXD(100, context),
                              child: Text("R\$ ${formatedCurrency(checkboxMap['value'])}"),
                              alignment: Alignment.centerLeft,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          );
        }
      ),
    );
  }
}

class DropdownArray extends StatefulWidget {
  final AdditionalModel model;

  DropdownArray({Key? key, required this.model}) : super(key: key);

  @override
  State<DropdownArray> createState() => _DropdownArrayState();
}

class _DropdownArrayState extends State<DropdownArray> {
  final MainStore mainStore = Modular.get();
  final AdvertisementStore store = Modular.get();
  String dropdownValue = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: wXD(15, context),
        left: wXD(15, context),
      ),
      // height: 50,
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [    
            Padding(
            padding: EdgeInsets.only(
              // left: wXD(15, context),
            ),
            child: Text(
              widget.model.title,
              style: textFamily(context,
                fontSize: 15,
                color: getColors(context).onBackground,
              ),
            ),
          ),             
          FutureBuilder<List<Map<String, dynamic>>>(
            future: mainStore.getDropdownList(widget.model.id),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return LinearProgressIndicator();
              }
              List<Map<String, dynamic>> dropdownArray = snapshot.data!;
              print('store.additionalResponse.containsKey(model.id): ${store.additionalResponse.containsKey(widget.model.id)}');
              print('dropdownValue: $dropdownValue');
              if(dropdownValue == ""){
                dropdownValue = dropdownArray[0]['label'];
              }
              if(!store.additionalResponse.containsKey(widget.model.id)){
                Map<String, dynamic> dropdownMap = dropdownArray[0];
                store.additionalResponse.putIfAbsent(widget.model.id, () => {
                  "response_label": dropdownMap['label'],
                  "response_value": dropdownMap['value'],
                  "response_index": dropdownMap['index'],
                });
              }
              
              return DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.keyboard_arrow_down),
                elevation: 16,
                underline: Container(
                  height: 2,
                  color: colors.primary,
                ),
                onChanged: (String? newValue) {
                  setState((){
                    dropdownValue = newValue!;
                    print("dropdownValue = newValue $dropdownValue");
                  });
                  for (var i = 0; i < dropdownArray.length; i++) {
                    Map<String, dynamic> dropdownMap = dropdownArray[i];
                    if(dropdownValue == dropdownMap['label']){
                      store.additionalResponse.update(widget.model.id, (value) => {
                        "response_label": dropdownMap['label'],
                        "response_value": dropdownMap['value'],
                        "response_index": dropdownMap['index'],
                      });
                      break;
                    }
                  }
                },
                items: dropdownArray.map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
                  return DropdownMenuItem<String>(
                    enabled: true,
                    value: value['label'],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(value['label']),
                        // Spacer(),
                        // SizedBox(width: wXD(15, context),),
                        Text("R\$ ${formatedCurrency(value['value'])}"),
                      ],
                    ),
                  );
                }).toList(),
              );
            }
          ),
        ],
      ),
    );
  }
}