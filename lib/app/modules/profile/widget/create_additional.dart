import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:delivery_seller_white_label/app/modules/profile/profile_store.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/load_circular_overlay.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CreateAdditional extends StatefulWidget {
  CreateAdditional({Key? key}) : super(key: key);

  @override
  State<CreateAdditional> createState() => _CreateAdditionalState();
}

class _CreateAdditionalState extends State<CreateAdditional> {
  final ProfileStore store = Modular.get();
  final _formKey = GlobalKey<FormState>();
  // final ScrollController scrollController = ScrollController();
  // bool visibleButton = true;
  OverlayEntry? loadOverlay;

  @override
  void initState() {
    super.initState();
    // scrollController.addListener(() {
    //   if (scrollController.position.userScrollDirection ==
    //       ScrollDirection.forward) {
    //     if (visibleButton == false) {
    //       visibleButton = true;
    //       setState(() {});
    //     }
    //   } else {
    //     if (visibleButton == true) {
    //       visibleButton = false;
    //       setState(() {});
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    store.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (loadOverlay != null) {
          if (loadOverlay!.mounted) {
            return false;
          }
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Listener(
              onPointerDown: (a) {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: SizedBox(
                height: maxHeight(context),
                width: maxWidth(context),
                child: SingleChildScrollView(
                  // controller: scrollController,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          // width: maxWidth(context),
                          margin: EdgeInsets.only(
                            top: viewPaddingTop(context) + wXD(60, context),
                          ),
                          padding: EdgeInsets.only(
                            // bottom: wXD(10, context),
                            left: wXD(15, context),
                            right: wXD(15, context),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.2),
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  right: wXD(10, context),
                                ),
                                child: Text(
                                  "Propriedades:",
                                  style: TextStyle(
                                    color: getColors(context).onBackground,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                              SizedBox(height: wXD(15, context)),
                              Row(
                                children: [
                                  Container(
                                    width: wXD(70, context),
                                    margin: EdgeInsets.only(
                                      right: wXD(10, context),
                                    ),
                                    child: Text("Tipo:"),
                                  ),
                                  Flexible(
                                    child: DropDownType(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: wXD(10, context),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: wXD(70, context),
                                    margin: EdgeInsets.only(
                                      right: wXD(10, context),
                                    ),
                                    child: Text(
                                      "Vendedor:",
                                      style: textFamily(context),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                              value: "reading",
                                              groupValue: store.sellerOption,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  store.sellerOption = value!;
                                                  store.customerOption =
                                                      "edition";
                                                });
                                              },
                                              activeColor: colors.primary),
                                          Text("Leitura"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                              value: "edition",
                                              groupValue: store.sellerOption,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  store.sellerOption = value!;
                                                  store.customerOption =
                                                      "reading";
                                                });
                                              },
                                              activeColor: colors.primary),
                                          Text("Edição"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: wXD(10, context),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: wXD(70, context),
                                    margin: EdgeInsets.only(
                                      right: wXD(10, context),
                                    ),
                                    child: Text("Cliente:"),
                                  ),
                                  Row(children: [
                                    Row(
                                      children: [
                                        Radio(
                                            value: "reading",
                                            groupValue: store.customerOption,
                                            onChanged: (String? value) {
                                              setState(() {
                                                store.customerOption = value!;
                                                store.sellerOption = "edition";
                                              });
                                            },
                                            activeColor: colors.primary),
                                        Text("Leitura"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                            value: "edition",
                                            groupValue: store.customerOption,
                                            onChanged: (String? value) {
                                              setState(() {
                                                store.customerOption = value!;
                                                store.sellerOption = "reading";
                                              });
                                            },
                                            activeColor: colors.primary),
                                        Text("Edição"),
                                      ],
                                    ),
                                  ]),
                                ],
                              ),
                              SizedBox(
                                height: wXD(10, context),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: wXD(70, context),
                                    child: Text("Título:"),
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                          hintText: "Ex: Adicionais"),
                                      validator: (txt) {
                                        if (txt == null || txt.isEmpty) {
                                          return "Preencha corretamente";
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        store.titleSession = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: wXD(20, context)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Alinhamento:"),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                              value: "left",
                                              groupValue: store.alignment,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  store.alignment = value!;
                                                });
                                              },
                                              activeColor: colors.primary),
                                          Text("Esquerda"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                              value: "center",
                                              groupValue: store.alignment,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  store.alignment = value!;
                                                });
                                              },
                                              activeColor: colors.primary),
                                          Text("Centro"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                              value: "right",
                                              groupValue: store.alignment,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  store.alignment = value!;
                                                });
                                              },
                                              activeColor: colors.primary),
                                          Text("Direita"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    child: Text("Campo padrão:"),
                                  ),
                                  Checkbox(
                                    activeColor: colors.primary,
                                    value: store.autoSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        store.autoSelected = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              // SizedBox(height: wXD(10, context)),
                              Container(
                                child: Observer(builder: (context) {
                                  switch (store.dropdownValue) {
                                    case "Mais de uma opção":
                                      return CheckBoxConfig(
                                        refresh: () {
                                          setState(() {});
                                        },
                                      );

                                    case "Campo de texto":
                                      return TextFieldConfig(
                                        refresh: () {
                                          setState(() {});
                                        },
                                      );

                                    case "Contador":
                                      return IncrementConfig();

                                    // case "Apenas uma opção":
                                    //   return RadioButtonConfig();

                                    case "Etiqueta":
                                      return TextScoreConfig();

                                    case "Área de texto":
                                      return TextAreaConfig(
                                        refresh: () {
                                          setState(() {});
                                        },
                                      );

                                    case "Seletor":
                                      return Container();

                                    default:
                                      return Container();
                                  }
                                }),
                              ),
                              SizedBox(
                                height: wXD(10, context),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: wXD(10, context)),
                        Container(
                          width: maxWidth(context),
                          padding: EdgeInsets.only(
                            left: wXD(15, context),
                            right: wXD(15, context),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  "Visualização:",
                                  style: TextStyle(
                                    color: getColors(context).onBackground,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: wXD(15, context),
                                // width: maxWidth(context),
                              ),
                              Container(
                                child: Observer(builder: (context) {
                                  switch (store.dropdownValue) {
                                    case "Mais de uma opção":
                                      return CheckBoxArray();

                                    case "Campo de texto":
                                      return TextFieldScore();

                                    case "Contador":
                                      return IncrementField();

                                    case "Apenas uma opção":
                                      return RadioButtonArray();

                                    case "Etiqueta":
                                      return TextScore();

                                    case "Área de texto":
                                      return TextAreaScore();

                                    case "Seletor":
                                      return DropdownArray();

                                    default:
                                      return Container();
                                  }
                                }),
                              ),
                              SizedBox(height: wXD(30, context),),
                              SideButton(
                                onTap: () async{
                                  if (_formKey.currentState!.validate()) {
                                    loadOverlay =
                                        OverlayEntry(builder: (context) => LoadCircularOverlay());
                                    Overlay.of(context)!.insert(loadOverlay!);

                                    await store.saveAdditional();

                                    loadOverlay!.remove();
                                    loadOverlay = null;
                                  }
                                },
                                title: "Criar",
                              ),
                              SizedBox(height: wXD(30, context),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            DefaultAppBar(
              "Criar seção",
              onPop: () {
                if (loadOverlay != null) {
                  if (loadOverlay!.mounted) {
                  } else {
                    Modular.to.pop();
                  }
                } else {
                  Modular.to.pop();
                }
              },
            ),
          ],
        ),
        // floatingActionButton: Visibility(
        //   visible: visibleButton,
        //   child: FloatingActionButton.extended(
        //     onPressed: () async {
        //       if (_formKey.currentState!.validate()) {
        //         loadOverlay =
        //             OverlayEntry(builder: (context) => LoadCircularOverlay());
        //         Overlay.of(context)!.insert(loadOverlay!);

        //         await store.saveAdditional();

        //         loadOverlay!.remove();
        //         loadOverlay = null;
        //       }
        //     },
        //     label: Text(
        //       'Criar',
        //       style: TextStyle(color: colors.onPrimary),
        //     ),
        //     backgroundColor: colors.primary,
        //   ),
        // ),
      ),
    );
  }
}

class DropDownType extends StatelessWidget {
  final ProfileStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: store.dropdownValue,
      icon: const Icon(Icons.keyboard_arrow_down),
      elevation: 16,
      underline: Container(
        height: 2,
        color: colors.primary,
      ),
      onChanged: (String? newValue) {
        store.dropdownValue = newValue!;
      },
      items: store.typesArray
          .map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
        return DropdownMenuItem<String>(
          value: value['dropdownValue'],
          child: Row(
            children: [
              Icon(value['iconData']),
              SizedBox(
                width: wXD(10, context),
              ),
              Text(value['dropdownValue']),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class CheckBoxArray extends StatelessWidget {
  final ProfileStore store = Modular.get();
  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter(symbol: 'R\$');
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: wXD(15, context),
      ),
      child: StatefulBuilder(builder: (context, refresh) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: wXD(15, context),
              ),
              child: Observer(builder: (context) {
                if (store.titleSession == "") {
                  return Container();
                }
                return Text(
                  store.titleSession,
                  style: textFamily(
                    context,
                    fontSize: 15,
                    color: getColors(context).onBackground,
                  ),
                );
              }),
            ),
            Column(
              children: List.generate(
                store.checkboxArray.length,
                (i) {
                  return Row(
                    children: [
                      Checkbox(
                        activeColor: colors.primary,
                        value: store.checkedMap[i],
                        onChanged: (bool? value) {
                          store.checkedMap[i] = value!;
                          refresh(() {});
                        },
                      ),
                      Flexible(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              InputDecoration(hintText: "Opção ${i + 1}"),
                          validator: (txt) {
                            if (txt == null || txt.isEmpty) {
                              return "Preencha corretamente";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            store.checkboxArray[i]["label"] = value;
                            // print('store.checkboxArray: ${store.checkboxArray}');
                          },
                        ),
                      ),
                      SizedBox(
                        width: wXD(15, context),
                      ),
                      Container(
                        width: wXD(100, context),
                        child: TextFormField(
                          inputFormatters: [_formatter],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'R\$ ${formatedCurrency(0)}',
                          ),
                          onChanged: (val) {
                            store.checkboxArray[i]["value"] =
                                _formatter.getUnformattedValue();
                          },
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      store.checkboxArray.length == 1
                          ? Container()
                          : IconButton(
                              onPressed: () {
                                store.removeCheckBox(i);
                                refresh(() {});
                              },
                              icon: Icon(
                                Icons.indeterminate_check_box,
                                color: colors.primary,
                              ),
                            ),
                    ],
                  );
                },
              ),
            ),
            Row(
              children: [
                Spacer(),
                IconButton(
                  onPressed: () {
                    store.addCheckBox();
                    refresh(() {});
                  },
                  icon: Icon(Icons.add_box, color: colors.primary),
                ),
                Spacer(),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class TextFieldScore extends StatelessWidget {
  final ProfileStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: store.getColumnAlignment(),
        children: [
          Observer(builder: (context) {
            if (store.titleSession == "") {
              return Container();
            }
            return Text(
              getText(store.titleSession, store.additionalMandatory),
              style: textFamily(
                context,
                fontSize: 15,
                color: getColors(context).onBackground,
              ),
            );
          }),
          SizedBox(height: wXD(5, context)),
          Container(
            width: store.short ? maxWidth(context) / 2 : maxWidth(context),
            padding: EdgeInsets.symmetric(
              horizontal: wXD(8, context),
              vertical: wXD(5, context),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: getColors(context).primary),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: TextFormField(
              enabled: false,
              maxLines: 1,
              decoration: InputDecoration.collapsed(
                hintText: store.textFieldHint,
              ),
              // onChanged: (val) => store.textFieldHint = val,
            ),
          ),
        ],
      ),
    );
  }

  getText(String title, bool mandatory) {
    String _title = mandatory ? title + "*" : title;
    return _title;
  }
}

class IncrementField extends StatelessWidget {
  final ProfileStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, refresh) {
      return Container(
        width: maxWidth(context),
        child: Column(
          crossAxisAlignment: store.getColumnAlignment(),
          children: [
            Observer(builder: (context) {
              if (store.titleSession == "" || store.titleSession == "") {
                return Container();
              }
              return Text(
                store.titleSession,
                style: textFamily(
                  context,
                  fontSize: 15,
                  color: getColors(context).onBackground,
                ),
              );
            }),
            Row(
              mainAxisAlignment: store.getRowAlignment(),
              children: [
                Container(
                  height: wXD(25, context),
                  width: wXD(88, context),
                  margin: EdgeInsets.only(top: wXD(4, context)),
                  padding: EdgeInsets.symmetric(horizontal: wXD(4, context)),
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
                          if (store.count > store.incrementMinimum) {
                            refresh(() {
                              store.count--;
                            });
                          }
                        },
                        child: Icon(
                          Icons.remove,
                          size: wXD(20, context),
                          color: store.count == store.incrementMinimum
                              ? getColors(context).primary.withOpacity(.4)
                              : getColors(context).primary,
                        ),
                      ),
                      Container(
                        width: wXD(32, context),
                        height: wXD(25, context),
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            vertical: BorderSide(
                              color:
                                  getColors(context).onSurface.withOpacity(.3),
                            ),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          store.count.toString(),
                          style: textFamily(context,
                              color: getColors(context).primary),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (store.count < store.incrementMaximum) {
                            refresh(() {
                              store.count++;
                            });
                          }
                        },
                        child: Icon(
                          Icons.add,
                          size: wXD(20, context),
                          color: store.count == store.incrementMaximum
                              ? getColors(context).primary.withOpacity(.4)
                              : getColors(context).primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Observer(builder: (context) {
                  if (store.incrementValue == 0) {
                    return Container();
                  }
                  return Container(
                    margin: EdgeInsets.only(left: wXD(10, context)),
                    child: Text(
                      "R\$ ${formatedCurrency(store.count * store.incrementValue)}",
                      style: textFamily(
                        context,
                        fontSize: 15,
                        color: getColors(context).onBackground,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class RadioButtonArray extends StatelessWidget {
  final ProfileStore store = Modular.get();
  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter(symbol: 'R\$');
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, refresh) {
      return Container(
        margin: EdgeInsets.only(right: wXD(15, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: wXD(15, context),
              ),
              child: Observer(builder: (context) {
                if (store.titleSession == "") {
                  return Container();
                }
                return Text(
                  store.titleSession,
                  style: textFamily(
                    context,
                    fontSize: 15,
                    color: getColors(context).onBackground,
                  ),
                );
              }),
            ),
            Column(
              children: List.generate(
                store.radiobuttonArray.length,
                (i) {
                  return Row(
                    children: [
                      Radio(
                        activeColor: colors.primary,
                        value: i,
                        groupValue: store.groupValue,
                        onChanged: (int? value) {
                          refresh(() {
                            store.groupValue = value!;
                          });
                        },
                      ),
                      Flexible(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              InputDecoration(hintText: "Opção ${i + 1}"),
                          validator: (txt) {
                            if (txt == null || txt.isEmpty) {
                              return "Preencha corretamente";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            store.radiobuttonArray[i]["label"] = value;
                            refresh(() {});
                          },
                        ),
                      ),
                      SizedBox(
                        width: wXD(15, context),
                      ),
                      Container(
                        width: wXD(100, context),
                        child: TextFormField(
                          inputFormatters: [_formatter],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'R\$ ${formatedCurrency(0)}',
                          ),
                          onChanged: (val) {
                            store.radiobuttonArray[i]["value"] =
                                _formatter.getUnformattedValue();
                          },
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      store.radiobuttonArray.length == 1
                          ? Container()
                          : IconButton(
                              onPressed: () {
                                store.removeRadiobutton(i);
                                refresh(() {});
                              },
                              icon: Icon(Icons.indeterminate_check_box,
                                  color: colors.primary),
                            ),
                    ],
                  );
                },
              ),
            ),
            Row(
              children: [
                Spacer(),
                IconButton(
                  onPressed: () {
                    store.addRadiobutton();
                    refresh(() {});
                  },
                  icon: Icon(Icons.add_box, color: colors.primary),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class TextFieldConfig extends StatelessWidget {
  final ProfileStore store = Modular.get();
  final Function refresh;

  TextFieldConfig({Key? key, required this.refresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: wXD(70, context),
              child: Text("Texto explicativo:"),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(hintText: "Ex: Escreva aqui"),
                // validator: (txt) {
                //   if (txt == null || txt.isEmpty) {
                //     return "Preencha corretamente";
                //   }
                //   return null;
                // },
                onChanged: (value) {
                  store.textFieldHint = value;
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              child: Text("Campo obrigatório:"),
            ),
            Checkbox(
              activeColor: colors.primary,
              value: store.additionalMandatory,
              onChanged: (value) {
                store.additionalMandatory = value!;
                refresh();
              },
            ),
          ],
        ),
        Row(
          children: [
            Container(
              child: Text("Campo curto:"),
            ),
            Checkbox(
              activeColor: colors.primary,
              value: store.short,
              onChanged: (value) {
                store.short = value!;
                refresh();
              },
            ),
          ],
        ),
      ],
    );
  }
}

class TextAreaConfig extends StatelessWidget {
  final ProfileStore store = Modular.get();
  final Function refresh;

  TextAreaConfig({Key? key, required this.refresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: wXD(70, context),
              child: Text("Texto explicativo:"),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(hintText: "Ex: Escreva aqui"),
                // validator: (txt) {
                //   if (txt == null || txt.isEmpty) {
                //     return "Preencha corretamente";
                //   }
                //   return null;
                // },
                onChanged: (value) {
                  store.textFieldHint = value;
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              child: Text("Campo obrigatório:"),
            ),
            Checkbox(
              activeColor: colors.primary,
              value: store.additionalMandatory,
              onChanged: (value) {
                store.additionalMandatory = value!;
                print(
                    'store.additionalMandatory: ${store.additionalMandatory}');
                refresh();
              },
            ),
          ],
        ),
      ],
    );
  }
}

class TextScore extends StatelessWidget {
  final ProfileStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: store.getColumnAlignment(),
        children: [
          Observer(builder: (context) {
            return Text(
              store.titleSession != "" ? store.titleSession : "Ex: Adicionais",
              style: textFamily(
                context,
                fontSize: store.fontSize.toDouble(),
                color: getColors(context).onBackground,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class TextAreaScore extends StatelessWidget {
  final ProfileStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: wXD(15, context),
          ),
          child: Observer(builder: (context) {
            if (store.titleSession == "") {
              return Container();
            }
            return Text(
              getText(store.titleSession, store.additionalMandatory),
              style: textFamily(
                context,
                fontSize: 15,
                color: getColors(context).onBackground,
              ),
            );
          }),
        ),
        SizedBox(
          height: wXD(5, context),
        ),
        Container(
          width: maxWidth(context),
          margin: EdgeInsets.symmetric(horizontal: wXD(15, context)),
          padding: EdgeInsets.symmetric(
            horizontal: wXD(8, context),
            vertical: wXD(5, context),
          ),
          height: wXD(200, context),
          decoration: BoxDecoration(
            border: Border.all(color: getColors(context).primary),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: TextFormField(
            enabled: false,
            maxLines: 5,
            decoration:
                InputDecoration.collapsed(hintText: store.textFieldHint),
            // onChanged: (val) => store.textFieldHint = val,
          ),
        ),
      ],
    );
  }

  getText(String title, bool mandatory) {
    String _title = mandatory ? title + "*" : title;
    return _title;
  }
}

class IncrementConfig extends StatelessWidget {
  final ProfileStore store = Modular.get();
  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter(symbol: 'R\$');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: wXD(70, context),
              margin: EdgeInsets.only(right: wXD(10, context)),
              child: Text(
                "Valor:",
              ),
            ),
            Container(
              width: wXD(88, context),
              child: TextFormField(
                decoration:
                    InputDecoration(hintText: "R\$ ${formatedCurrency(0)}"),
                inputFormatters: [_formatter],
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  store.incrementValue = _formatter.getUnformattedValue();
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: wXD(70, context),
              margin: EdgeInsets.only(right: wXD(10, context)),
              child: Text(
                "Mínimo:",
              ),
            ),
            Flexible(
              child: TextFormField(
                initialValue: '1',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if (val != "") {
                    store.incrementMinimum = num.parse(val);
                    if (store.incrementMinimum > store.count) {
                      store.count = int.parse(val);
                    }
                  }
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: wXD(70, context),
              margin: EdgeInsets.only(right: wXD(10, context)),
              child: Text(
                "Máximo:",
              ),
            ),
            Flexible(
              child: TextFormField(
                initialValue: '10',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if (val != "") {
                    store.incrementMaximum = num.parse(val);
                    if (store.incrementMaximum < store.count) {
                      store.count = int.parse(val);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CheckBoxConfig extends StatelessWidget {
  final ProfileStore store = Modular.get();
  final Function refresh;

  CheckBoxConfig({Key? key, required this.refresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          // width: wXD(75, context),
          margin: EdgeInsets.only(
            // left: wXD(15, context),
            right: wXD(10, context),
          ),
          child: Text("Quantidade de itens obrigatórios:"),
        ),
        Container(
          width: wXD(50, context),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "0"),
            onChanged: (value) {
              if (value == "") {
                store.numberMandatoryFields = 0;
              } else {
                store.numberMandatoryFields = num.parse(value);
              }
            },
          ),
        ),
      ],
    );
  }
}

class DropdownArray extends StatelessWidget {
  final ProfileStore store = Modular.get();
  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter(symbol: 'R\$');
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: wXD(15, context),
        left: wXD(15, context),
      ),
      child: StatefulBuilder(builder: (context, refresh) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Observer(builder: (context) {
              if (store.titleSession == "") {
                return Container();
              }
              return Text(
                store.titleSession,
                style: textFamily(
                  context,
                  fontSize: 15,
                  color: getColors(context).onBackground,
                ),
              );
            }),
            Column(
              children: List.generate(
                store.dropdownArray.length,
                (i) {
                  return Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              InputDecoration(hintText: "Opção ${i + 1}"),
                          validator: (txt) {
                            if (txt == null || txt.isEmpty) {
                              return "Preencha corretamente";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            store.dropdownArray[i]["label"] = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: wXD(15, context),
                      ),
                      Container(
                        width: wXD(100, context),
                        child: TextFormField(
                          inputFormatters: [_formatter],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'R\$ ${formatedCurrency(0)}',
                          ),
                          onChanged: (val) {
                            store.dropdownArray[i]["value"] =
                                _formatter.getUnformattedValue();
                          },
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      store.dropdownArray.length == 1
                          ? Container()
                          : IconButton(
                              onPressed: () {
                                store.removeDropdownItem(i);
                                refresh(() {});
                              },
                              icon: Icon(
                                Icons.indeterminate_check_box,
                                color: colors.primary,
                              ),
                            ),
                    ],
                  );
                },
              ),
            ),
            Row(
              children: [
                Spacer(),
                IconButton(
                  onPressed: () {
                    store.addDropdownItem();
                    refresh(() {});
                  },
                  icon: Icon(Icons.add_box, color: colors.primary),
                ),
                Spacer(),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class TextScoreConfig extends StatelessWidget {
  final ProfileStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          // width: wXD(70, context),
          child: Text("Tamanho da fonte:"),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 100,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(hintText: "18"),
            keyboardType: TextInputType.number,
            initialValue: "18",
            validator: (txt) {
              if (txt == null || txt.isEmpty) {
                return "Preencha corretamente";
              }
              return null;
            },
            onChanged: (String value) {
              if (value != "") {
                store.fontSize = num.parse(value);
              } else {
                store.fontSize = 0;
              }
            },
          ),
        ),
      ],
    );
  }
}
