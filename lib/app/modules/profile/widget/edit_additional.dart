import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:delivery_seller_white_label/app/core/models/additional_model.dart';
import 'package:delivery_seller_white_label/app/modules/profile/profile_store.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/load_circular_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../shared/widgets/side_button.dart';

class EditAdditional extends StatefulWidget {
  final AdditionalModel model;
  EditAdditional({
    Key? key, required this.model,
  }) : super(key: key);

  @override
  State<EditAdditional> createState() => _EditAdditionalState();
}

class _EditAdditionalState extends State<EditAdditional> {
  final ProfileStore store = Modular.get();
  final _formKey = GlobalKey<FormState>();
  OverlayEntry? loadOverlay;

  setDropdownValue(){
    store.editAdditional = widget.model.toJsonAsObservable();
    print("store.editAdditional: ${store.editAdditional}");
    switch (widget.model.type) {
      case "text-field":
        store.dropdownValue = "Campo de texto";
        break;

      case "check-box":
        store.dropdownValue = "Mais de uma opção";
        break;

      case "radio-button":
        store.dropdownValue = "Apenas uma opção";
        break;

      case "increment":
        store.dropdownValue = "Contador";
        break;

      case "text":
        store.dropdownValue = "Etiqueta";
        break;

      case "text-area":
        store.dropdownValue = "Área de texto";
        break;

      case "combo-box":
        store.dropdownValue = "Seletor";
        break;

      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    setDropdownValue();
    // scrollController.addListener(() {
    //   if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
    //     if(visibleButton == false){
    //       visibleButton = true;
    //       setState(() {});
    //     }
    //   } else {
    //     if(visibleButton == true){
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
      onWillPop: () async{
        if(loadOverlay != null){
          if(loadOverlay!.mounted){
            return false;
          }
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Listener(
              onPointerDown: (a){
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: SizedBox(
                height: maxHeight(context),
                width: maxWidth(context),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          width: maxWidth(context),
                          margin: EdgeInsets.only(
                            top: viewPaddingTop(context) + wXD(60, context),
                          ),
                          padding: EdgeInsets.only(
                            bottom: wXD(10, context),
                            left: wXD(15, context),
                            right: wXD(15, context),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: getColors(context).onBackground.withOpacity(.2),
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
                                  "Configurações da Seção:",
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
                              ),
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
                              SizedBox(height: wXD(10, context),),
                              Row(
                                children: [
                                  Container(
                                    width: wXD(70, context),
                                    margin: EdgeInsets.only(
                                      right: wXD(10, context),
                                    ),
                                    child: Text("Vendedor:"),
                                  ),
                                  Row(children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: "reading", 
                                          groupValue: store.editAdditional['seller_config'],
                                          onChanged: (dynamic value){
                                            if(!widget.model.notEdit){
                                              setState(() {
                                                store.editAdditional['customer_config'] = "edition";
                                                store.editAdditional['seller_config'] = value!;                                              
                                              });
                                            }
                                          },
                                          activeColor: colors.primary
                                        ),
                                        Text("Leitura"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: "edition", 
                                          groupValue: store.editAdditional['seller_config'], 
                                          onChanged: (dynamic value){
                                            if(!widget.model.notEdit){
                                              setState(() {
                                                store.editAdditional['seller_config'] = value!;
                                                store.editAdditional['customer_config'] = "reading";
                                              });
                                            }
                                          },
                                          activeColor: colors.primary
                                        ),
                                        Text("Edição"),
                                      ],
                                    ),
                                  ],),
                                ],
                              ),
                              SizedBox(height: wXD(10, context),),
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
                                          groupValue: store.editAdditional['customer_config'],
                                          onChanged: (dynamic value){
                                            if(!widget.model.notEdit){
                                              setState(() {
                                                store.editAdditional['seller_config'] = "edition";
                                                store.editAdditional['customer_config'] = value!;
                                              });
                                            }
                                          },
                                          activeColor: colors.primary
                                        ),
                                        Text("Leitura"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: "edition", 
                                          groupValue: store.editAdditional['customer_config'],
                                          onChanged: (dynamic value){
                                            if(!widget.model.notEdit){
                                              setState(() {
                                                store.editAdditional['customer_config'] = value!;
                                                store.editAdditional['seller_config'] = "reading";
                                              });
                                            }
                                          },
                                          activeColor: colors.primary
                                        ),
                                        Text("Edição"),
                                      ],
                                    ),
                                  ],),
                                ],
                              ),
                              SizedBox(height: wXD(10, context),),
                              Row(
                                children: [
                                  Container(
                                    width: wXD(70, context),
                                    margin: EdgeInsets.only(
                                      right: wXD(10, context),
                                    ),
                                    child: Text("Título:"),
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      enabled: !widget.model.notEdit,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      initialValue: widget.model.title,
                                      decoration: InputDecoration(hintText: "Ex: Adicionais"),
                                      validator: (txt) {
                                        if (txt == null || txt.isEmpty) {
                                          return "Preencha corretamente";
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        store.editAdditional['title'] = value;
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                            value: "left",
                                            groupValue: store.editAdditional['alignment'],
                                            onChanged: (dynamic value){
                                              if(!widget.model.notEdit){
                                                setState(() {
                                                  store.editAdditional['alignment'] = value;
                                                });
                                              }
                                            },
                                            activeColor: colors.primary
                                          ),
                                          Text("Esquerda"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: "center", 
                                            groupValue: store.editAdditional['alignment'],
                                            onChanged: (dynamic value){
                                              if(!widget.model.notEdit){
                                                setState(() {
                                                  store.editAdditional['alignment'] = value!;
                                                });
                                              }
                                            },
                                            activeColor: colors.primary
                                          ),
                                          Text("Centro"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: "right", 
                                            groupValue: store.editAdditional['alignment'],
                                            onChanged: (dynamic value){
                                              if(!widget.model.notEdit){
                                                setState(() {
                                                  store.editAdditional['alignment'] = value!;
                                                });
                                              }
                                            },
                                            activeColor: colors.primary
                                          ),
                                          Text("Direita"),
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
                                        value: store.editAdditional['auto_selected'] == true,
                                        onChanged: (value) {
                                          if(!widget.model.notEdit){
                                            setState(() {
                                              store.editAdditional['auto_selected'] = value!;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: wXD(10, context)),
                              Container(
                                child: Observer(builder: (context){
                                  switch (store.dropdownValue) {
                                    case "Mais de uma opção":
                                      return CheckBoxConfig(
                                        refresh: (){
                                          setState(() {});
                                        },
                                      );

                                    case "Campo de texto":
                                      return TextFieldConfig(
                                        refresh: (){
                                          setState(() {});
                                        },
                                      );

                                    case "Contador":
                                      return IncrementConfig(
                                        enabled: !widget.model.notEdit,
                                      );

                                    // case "Apenas uma opção":
                                    //   return RadioButtonConfig();

                                    case "Etiqueta":
                                      return TextScoreConfig();

                                    case "Área de texto":
                                      return TextAreaConfig(
                                        enabled: !widget.model.notEdit,
                                        refresh: (){
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
                              SizedBox(height: wXD(10, context),),                      
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
                              ),
                              Container(
                                child: Observer(builder: (context){
                                  switch (store.dropdownValue) {
                                    case "Mais de uma opção":
                                      return CheckBoxArray(
                                        model: widget.model,
                                        enabled: !widget.model.notEdit,
                                      );

                                    case "Campo de texto":
                                      return TextFieldScore(
                                        enabled: !widget.model.notEdit,
                                      );

                                    case "Contador":
                                      return IncrementField(
                                        model: widget.model,
                                      );

                                    case "Apenas uma opção":
                                      return RadioButtonArray(
                                        model: widget.model,
                                        enabled: !widget.model.notEdit,
                                      );

                                    case "Etiqueta":
                                      return TextScore();

                                    case "Área de texto":
                                      return TextAreaScore(
                                        enabled: !widget.model.notEdit,
                                      );

                                    case "Seletor":
                                      return DropdownArray(
                                        model: widget.model,
                                        enabled: !widget.model.notEdit,
                                      );
  
                                    default:
                                      return Container();
                                  }
                                }),
                              ),
                              SizedBox(height: wXD(30, context),),
                              SideButton(
                                onTap: () async{
                                  if(widget.model.notEdit){
                                    Modular.to.pop();
                                  } else {
                                    if(_formKey.currentState!.validate()){
                                      loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());
                                      Overlay.of(context)!.insert(loadOverlay!);

                                      await store.saveEditAdditional();
                                      print('await store.saveEditAdditional after');
                                      loadOverlay!.remove();
                                      loadOverlay = null;
                                    }
                                  } 
                                },
                                title: "Salvar",
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
              "Editar seção",
              onPop: () {
                if(loadOverlay != null){
                  if(loadOverlay!.mounted){} else {
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
        //     onPressed: () async{
        //       if(widget.model.notEdit){
        //         Modular.to.pop();
        //       } else {
        //         if(_formKey.currentState!.validate()){
        //           loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());
        //           Overlay.of(context)!.insert(loadOverlay!);

        //           await store.saveEditAdditional();
        //           print('await store.saveEditAdditional after');
        //           loadOverlay!.remove();
        //           loadOverlay = null;
        //         }
        //       }              
        //     },
        //     label: Text(
        //       'Salvar',
        //       style: TextStyle(color: colors.onPrimary),
        //     ),
        //     // icon: Icon(Icons.add, color: colors.onPrimary),
        //     backgroundColor: colors.primary,
        //   ),
        // ),
      ),
    );
  }

  CrossAxisAlignment  getAlignment(){
    switch (store.editAdditional['alignment']) {
      case "left":
        return CrossAxisAlignment.start;

      case "center":
        return CrossAxisAlignment.center;

      case "right":
        return CrossAxisAlignment.end;

      default:
        return CrossAxisAlignment.start;
    }
  }
}

class DropDownType extends StatelessWidget {
  final ProfileStore store = Modular.get();

  DropDownType({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: store.dropdownValue,
      icon: const Icon(Icons.keyboard_arrow_down),
      elevation: 16,
      // style: TextStyle(color: colors.primary),
      underline: Container(
        height: 2,
        color: colors.primary,
      ),
      onChanged: (String? newValue) {
        store.dropdownValue = newValue!;
      },
      items: store.typesArray.map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
        // print('value: $value');
        return DropdownMenuItem<String>(
          enabled: false,
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
  final AdditionalModel model;
  final bool enabled;
  final ProfileStore store = Modular.get();
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(symbol: 'R\$');

  CheckBoxArray({
    Key? key, 
    required this.model, 
    required this.enabled,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('store.checkboxArray.length ${store.checkboxArray.length}');
    return Container(
      margin: EdgeInsets.only(right: wXD(15, context)),
      child: FutureBuilder<bool>(
        future: store.getCheckboxList(model.id),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return LinearProgressIndicator();
          }
          
           return StatefulBuilder(
            builder: (context, refresh) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: wXD(15, context),
                    ),
                    child: Observer(
                      builder: (context) {
                        if(store.editAdditional['title'] == "" || store.editAdditional['title'] == null){
                          return Container();
                        }
                        return Text(
                          store.editAdditional['title'],
                          style: textFamily(context,
                            fontSize: 15,
                            color: getColors(context).onBackground,
                          ),
                        );
                      }
                    ),
                  ),
                  Column(
                    children: List.generate(
                      store.checkboxArray.length, 
                      (i) {
                        // print('List.generate $i');
                        
                        return Row(
                          children: [
                            Checkbox(                            
                              activeColor: colors.primary,
                              value: store.checkedMap[i],
                              onChanged: (bool? value){
                                if(enabled){
                                  store.checkedMap[i] = value!;
                                  refresh((){});
                                }
                              },
                            ),
                            Flexible(
                              child: TextFormField(
                                enabled: enabled,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(hintText: "Opção ${i + 1}"),
                                initialValue: store.checkboxArray[i]['label'],
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
                            SizedBox(width: wXD(15, context),),
                            Container(
                              width: wXD(100, context),
                              child: TextFormField(
                                enabled: enabled,
                                inputFormatters: [_formatter],
                                keyboardType: TextInputType.number,
                                initialValue: 'R\$ ${formatedCurrency(store.checkboxArray[i]["value"])}',
                                decoration: InputDecoration(
                                  hintText: 'R\$ ${formatedCurrency(0)}',
                                ),
                                onChanged: (val) {
                                  // print('price: ${_formatter.getUnformattedValue()}');
                                  store.checkboxArray[i]["value"] = _formatter.getUnformattedValue();
                                },
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            store.checkboxArray.length == 1 ? Container() :
                            IconButton(
                              onPressed: (){
                                if(enabled){
                                  store.removeCheckBox(i);
                                  refresh((){});
                                }
                              }, 
                              icon: Icon(
                                Icons.indeterminate_check_box,
                                color: colors.primary
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
                        onPressed: (){
                          if(enabled){
                            store.addCheckBox();
                            refresh((){});
                          }
                        }, 
                        icon: Icon(
                          Icons.add_box,
                          color: colors.primary
                        ),
                      ),
                      Spacer(),
                    ],
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

class TextFieldScore extends StatelessWidget {
  final ProfileStore store = Modular.get();
  final bool enabled;

  TextFieldScore({Key? key, required this.enabled}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // bool mandatory = store.editAdditional['mandatory'] != null ? store.editAdditional['mandatory'] : false;
    // bool short = store.editAdditional['short'] != null ? store.editAdditional['short'] : false;
    print("hinttttttttttt: ${store.editAdditional['hint']}");
    return Container(
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: store.getColumnAlignment(editAlignment: store.editAdditional['alignment']),
        children: [
          Observer(
            builder: (context) {
              if(store.editAdditional['title'] == null || store.editAdditional['title'] == ""){
                return Container();
              }
              return Text(
                // store.editAdditional['title'],
                store.editAdditional['mandatory'] == true ? store.editAdditional['title'] + "*" : store.editAdditional['title'],
                style: textFamily(context,
                  fontSize: 15,
                  color: getColors(context).onBackground,
                ),
              );
            }
          ),
          SizedBox(height: wXD(5, context)),
          Container(
            width: store.editAdditional['short'] == true ? maxWidth(context) /2 : maxWidth(context),
            padding: EdgeInsets.symmetric(
                horizontal: wXD(8, context),
                vertical: wXD(5, context)),
            decoration: BoxDecoration(
              border:
                  Border.all(color: getColors(context).primary),
              borderRadius:
                  BorderRadius.all(Radius.circular(12)),
            ),
            child: TextFormField(
              enabled: false,
              // initialValue: store.editAdditional['hint'],
              maxLines: 1,
              decoration: InputDecoration.collapsed(
                hintText: store.editAdditional['hint'],
              ),
              //  validator: (String? val){
              //   if((val == null || val == "") && (store.editAdditional['seller_config'] == "edition" && store.editAdditional['mandatory'] == true)){
              //     return "Preencha corretamente";
              //   }
              //   return null;
              // },
              // onChanged: (val) => store.editAdditional['hint'] = val,
            ),
          ),
        ],
      ),
    );
  }
}

class IncrementField extends StatelessWidget {
  final ProfileStore store = Modular.get();
  final AdditionalModel model;  

  IncrementField({Key? key, required this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    dynamic minimum = store.editAdditional['increment_minimum'] != null ? store.editAdditional['increment_minimum'] : 0;
    if(minimum > store.count){
      store.count = minimum;
    }
    return StatefulBuilder(
      builder: (context, refresh) {
        return Container(
          width: maxWidth(context),
          child: Column(
            crossAxisAlignment: store.getColumnAlignment(editAlignment: store.editAdditional['alignment']),
            children: [
              Observer(
                builder: (context) {
                  if(store.editAdditional['title'] == null || store.editAdditional['title'] == ""){
                    return Container();
                  }
                  return Text(
                    store.editAdditional['title'],
                    style: textFamily(context,
                      fontSize: 15,
                      color: getColors(context).onBackground,
                    ),
                  );
                }
              ),
              Row(
                mainAxisAlignment: store.getRowAlignment(editAlignment: store.editAdditional['alignment']),
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
                            if(store.editAdditional['increment_minimum'] == null || store.count > store.editAdditional['increment_minimum']){
                              refresh((){
                                store.count --;
                              });
                            }
                          },
                          child: Icon(
                            Icons.remove,
                            size: wXD(20, context),
                            color: store.count == minimum
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
                                color: getColors(context)
                                    .onSurface
                                    .withOpacity(.3),
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            store.count.toString(),
                            style: textFamily(context,
                              color: getColors(context).primary,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            if(store.editAdditional['increment_maximum'] == null || store.count < store.editAdditional['increment_maximum']) {
                              refresh((){
                                store.count ++;
                              });
                            }                                
                          },
                          child: Icon(
                            Icons.add,
                            size: wXD(20, context),
                            color: store.count == store.editAdditional['increment_maximum'] ?
                            getColors(context).primary.withOpacity(.4):
                            getColors(context).primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Observer(
                    builder: (context) {
                      if(store.editAdditional['increment_value'] == 0 || store.editAdditional['increment_value'] == null){
                        return Container();
                      }
                      return Container(
                        margin: EdgeInsets.only(
                          left: wXD(10, context)
                        ),
                        child: Text(
                          "R\$ ${formatedCurrency(store.count * store.editAdditional['increment_value'])}",
                          style: textFamily(context,
                            fontSize: 15,
                            color: getColors(context).onBackground,
                          ),
                        ),
                      );
                    }
                  ),
                ],
              ),
              // SizedBox(height: wXD(10, context),),              
            ],
          ),
        );
      }
    );
  }
}

class RadioButtonArray extends StatelessWidget {
  final ProfileStore store = Modular.get();
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(symbol: 'R\$');

  final AdditionalModel model;
  final bool enabled;

  RadioButtonArray({Key? key, required this.model, required this.enabled}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: store.getRadiobuttonList(model.id),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return LinearProgressIndicator();
        }
        return StatefulBuilder(
          builder: (context, refresh) {
            return Container(
              margin: EdgeInsets.only(right: wXD(15, context)),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: wXD(15, context),
                    ),
                    child: Observer(
                      builder: (context) {
                        if(store.editAdditional['title'] == "" || store.editAdditional['title'] == null){
                          return Container();
                        }
                        return Text(
                          store.editAdditional['title'],
                          style: textFamily(context,
                            fontSize: 15,
                            color: getColors(context).onBackground,
                          ),
                        );
                      }
                    ),
                  ),
                  Column(
                    children: List.generate(
                      store.radiobuttonArray.length,
                      (i) {
                        print('List.generate: $i');
                        return Row(
                          children: [
                            Radio(
                              activeColor: colors.primary,
                              value: i,
                              groupValue: store.groupValue,
                              onChanged: (int? value){
                                print('value: $value');
                                refresh((){
                                  store.groupValue = value!;
                                });
                              },
                            ),
                            Flexible(
                              child: TextFormField(
                                enabled: enabled,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                initialValue: store.radiobuttonArray[i]["label"],
                                decoration: InputDecoration(hintText: "Opção ${i + 1}"),
                                validator: (txt) {
                                  if (txt == null || txt.isEmpty) {
                                    return "Preencha corretamente";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  store.radiobuttonArray[i]["label"] = value;
                                  // print('store.radiobuttonArray: ${store.radiobuttonArray}');
                                  refresh((){});
                                },
                              ),
                            ),
                            SizedBox(width: wXD(15, context),),
                            Container(
                              width: wXD(100, context),
                              child: TextFormField(
                                enabled: enabled,
                                initialValue: 'R\$ ${formatedCurrency(store.radiobuttonArray[i]["value"])}',
                                inputFormatters: [_formatter],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'R\$ ${formatedCurrency(0)}',
                                ),
                                onChanged: (val) {
                                  print('price: ${_formatter.getUnformattedValue()}');
                                  store.radiobuttonArray[i]["value"] = _formatter.getUnformattedValue();
                                },
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            store.radiobuttonArray.length == 1 ? Container() :
                            IconButton(
                              onPressed: (){
                                if(enabled){
                                  store.removeRadiobutton(i);
                                  refresh((){});
                                }
                              }, 
                              icon: Icon(
                                Icons.indeterminate_check_box,
                                color: colors.primary
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
                        onPressed: (){
                          if(enabled){
                            store.addRadiobutton();
                            refresh((){});
                          }
                        }, 
                        icon: Icon(
                          Icons.add_box,
                          color: colors.primary
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }
}

class TextFieldConfig extends StatelessWidget {
  final ProfileStore store = Modular.get();
  final Function refresh;

  TextFieldConfig({Key? key, required this.refresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool mandatory = store.editAdditional['mandatory'] != null ? store.editAdditional['mandatory'] : false;
    bool short = store.editAdditional['short'] != null ? store.editAdditional['short'] : false;
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: wXD(70, context),
              child: Text("Texto explicativo:"),
            ),
            SizedBox(width: 10,),
            Flexible(
              child: TextFormField(
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                initialValue: store.editAdditional['hint'],
                decoration: InputDecoration(
                  hintText: "Ex: Escreva aqui",
                ),
                // validator: (txt) {
                //   if (txt == null || txt.isEmpty) {
                //     return "Preencha corretamente";
                //   }
                //   return null;
                // },
                onChanged: (value){
                  store.editAdditional['hint'] = value;
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              // margin: EdgeInsets.only(left: wXD(15, context)),
              // width: wXD(70, context),
              // margin: EdgeInsets.only(
              //   right: wXD(10, context),
              // ),
              child: Text("Campo obrigatório:"),
            ),
            Checkbox(
              activeColor: colors.primary,
              value: mandatory, 
              onChanged: (value){
                store.editAdditional['mandatory'] = value!;
                // print('store.editAdditional[mandatory]: ${store.editAdditional['mandatory']}');
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
              value: short, 
              onChanged: (value){
                store.editAdditional['short'] = value!;
                // print('store.short: ${store.editAdditional['short']}');
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
  final bool enabled;

  TextAreaConfig({Key? key, required this.refresh, required this.enabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // bool mandatory = store.editAdditional['mandatory'] != null ? store.editAdditional['mandatory'] : false;
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: wXD(70, context),
              child: Text("Texto explicativo:"),
            ),
            SizedBox(width: 10,),
            Flexible(
              child: TextFormField(
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(hintText: "Ex: Escreva aqui"),
                initialValue: store.editAdditional['hint'],
                // validator: (txt) {
                //   if (txt == null || txt.isEmpty) {
                //     return "Preencha corretamente";
                //   }
                //   return null;
                // },
                onChanged: (value){
                  store.editAdditional['hint'] = value;
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              // margin: EdgeInsets.only(left: wXD(15, context)),
              // width: wXD(70, context),
              // margin: EdgeInsets.only(
              //   right: wXD(10, context),
              // ),
              child: Text("Campo obrigatório:"),
            ),
            Checkbox(
              activeColor: colors.primary,
              value: store.editAdditional['mandatory'], 
              onChanged: (value){
                if(enabled){
                  store.editAdditional['mandatory'] = value!;
                  print('store.editAdditional[mandatory]: ${store.editAdditional['mandatory']}');
                  refresh();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class IncrementConfig extends StatelessWidget {
  final ProfileStore store = Modular.get();
  final bool enabled;
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(symbol: 'R\$');

  IncrementConfig({Key? key, required this.enabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    num minimum = store.editAdditional['increment_minimum'] != null ? store.editAdditional['increment_minimum'] : 0;
    // num maximum = store.editAdditional['increment_maximum'] != null ? store.editAdditional['increment_maximum'] : 10;
    num price = store.editAdditional['increment_value'] != null ? store.editAdditional['increment_value'] : 0;

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
                // style: textFamily(context,
                //   fontSize: 15,
                //   color: getColors(context).onBackground,
                // ),
              ),
            ),
            Container(
              width: wXD(88, context),
              child: TextFormField(
                enabled: enabled,
                initialValue: 'R\$ ${formatedCurrency(price)}',
                decoration: InputDecoration(hintText: "R\$ ${formatedCurrency(0)}"),
                inputFormatters: [_formatter],
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  print('price: ${_formatter.getUnformattedValue()}');
                  store.editAdditional['increment_value'] = _formatter.getUnformattedValue();
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
                // style: textFamily(context,
                //   fontSize: 15,
                //   color: getColors(context).onBackground,
                // ),
              ),
            ),
            Flexible(
              child: TextFormField(
                enabled: enabled,
                initialValue: minimum.toString(),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if(val != "") {
                    store.editAdditional['increment_minimum'] = num.parse(val);
                    if(store.count < store.editAdditional['increment_minimum']){
                      store.count = store.editAdditional['increment_minimum'];
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
                // style: textFamily(context,
                //   fontSize: 15,
                //   color: getColors(context).onBackground,
                // ),
              ),
            ),
            Flexible(
              child: TextFormField(
                enabled: enabled,
                initialValue: store.editAdditional['increment_maximum'] != null ? store.editAdditional['increment_maximum'].toString() : null,
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if(val != "") {
                    store.editAdditional['increment_maximum'] = num.parse(val);
                    if(store.count > store.editAdditional['increment_maximum']){
                      store.count = store.editAdditional['increment_maximum'];
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

class TextScore extends StatelessWidget {
  final ProfileStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: store.getColumnAlignment(editAlignment: store.editAdditional['alignment']),
        children: [
          Observer(
            builder: (context) {
              return Text(
                (store.editAdditional['title'] != null && store.editAdditional['title'] != "") ? store.editAdditional['title'] : "Ex: Adicionais",
                style: textFamily(context,
                  fontSize: store.editAdditional['font_size'].toDouble(),
                  color: getColors(context).onBackground,
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}

class TextAreaScore extends StatelessWidget {
  final ProfileStore store = Modular.get();
  final bool enabled;

  TextAreaScore({Key? key, required this.enabled}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool mandatory = store.editAdditional['mandatory'] != null ? store.editAdditional['mandatory'] : false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: wXD(15, context),
          ),
          child: Observer(
            builder: (context) {
              if(store.editAdditional['title'] == "" || store.editAdditional['title'] == null){
                return Container();
              }
              return Text(
                getText(store.editAdditional['title'], mandatory),
                style: textFamily(context,
                  fontSize: 15,
                  color: getColors(context).onBackground,
                ),
              );
            }
          ),
        ),
        SizedBox(height: wXD(5, context),),
        Container(
          width: maxWidth(context),
          alignment: Alignment.centerLeft,
          child: Container(
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
              enabled: false,
              // initialValue: store.editAdditional['hint'],
              maxLines: 5,
              decoration: InputDecoration.collapsed(
                  hintText: store.editAdditional['hint']),
              // validator: (String? val){
              //   if((val == null || val == "") && (store.editAdditional['seller_config'] == "edition" && store.editAdditional['mandatory'] == true)){
              //     return "Preencha corretamente";
              //   }
              // },
              // onChanged: (val) => store.editAdditional['hint'] = val,
            ),
          ),
        ), 
      ],
    );
  }

  getText(String? title, bool mandatory){
    if(title != null){
      String _title = mandatory ? title + "*" : title;
      return _title;
    } else {
      return "";
    }
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
            initialValue: store.editAdditional['number_mandatory_fields'] != null ? store.editAdditional['number_mandatory_fields'].toString() : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "0"),
            onChanged: (value){
              store.editAdditional['number_mandatory_fields'] = num.parse(value);
            },
          ),
        ),
      ],
    );
  }
}

class DropdownArray extends StatelessWidget {
  final AdditionalModel model;
  final bool enabled;
  final ProfileStore store = Modular.get();
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(symbol: 'R\$');

  DropdownArray({
    Key? key, 
    required this.model, 
    required this.enabled,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('store.dropdownArray.length ${store.dropdownArray.length}');
    return Container(
      margin: EdgeInsets.only(
        right: wXD(15, context), 
        left: wXD(15, context),
      ),
      child: FutureBuilder<bool>(
        future: store.getDropdownList(model.id),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return LinearProgressIndicator();
          }
          
          // QuerySnapshot checkboxQuery = snapshot.data!;
          return StatefulBuilder(
            builder: (context, refresh) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      // left: wXD(15, context),
                    ),
                    child: Observer(
                      builder: (context) {
                        if(store.editAdditional['title'] == "" || store.editAdditional['title'] == null){
                          return Container();
                        }
                        return Text(
                          store.editAdditional['title'],
                          style: textFamily(context,
                            fontSize: 15,
                            color: getColors(context).onBackground,
                          ),
                        );
                      }
                    ),
                  ),
                  Column(
                    children: List.generate(
                      store.dropdownArray.length, 
                      (i) {
                        // print('List.generate $i');
                        
                        return Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                enabled: enabled,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(hintText: "Opção ${i + 1}"),
                                initialValue: store.dropdownArray[i]['label'],
                                validator: (txt) {
                                  if (txt == null || txt.isEmpty) {
                                    return "Preencha corretamente";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  store.dropdownArray[i]["label"] = value;
                                  // print('store.checkboxArray: ${store.checkboxArray}');
                                },
                              ),
                            ),
                            SizedBox(width: wXD(15, context),),
                            Container(
                              width: wXD(100, context),
                              child: TextFormField(
                                enabled: enabled,
                                inputFormatters: [_formatter],
                                keyboardType: TextInputType.number,
                                initialValue: 'R\$ ${formatedCurrency(store.dropdownArray[i]["value"])}',
                                decoration: InputDecoration(
                                  hintText: 'R\$ ${formatedCurrency(0)}',
                                ),
                                onChanged: (val) {
                                  // print('price: ${_formatter.getUnformattedValue()}');
                                  store.dropdownArray[i]["value"] = _formatter.getUnformattedValue();
                                },
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            store.dropdownArray.length == 1 ? Container() :
                            IconButton(
                              onPressed: (){
                                if(enabled){
                                  store.removeDropdownItem(i);
                                  refresh((){});
                                }
                              }, 
                              icon: Icon(
                                Icons.indeterminate_check_box,
                                color: colors.primary
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
                        onPressed: (){
                          if(enabled){
                            store.addDropdownItem();
                            refresh((){});
                          }
                        }, 
                        icon: Icon(
                          Icons.add_box,
                          color: colors.primary
                        ),
                      ),
                      Spacer(),
                    ],
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
        SizedBox(width: 10),
        Container(
          width: 100,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(hintText: "18"),
            keyboardType: TextInputType.number,
            initialValue: store.editAdditional['font_size'].toString(),
            validator: (txt) {
              if (txt == null || txt.isEmpty) {
                return "Preencha corretamente";
              }
              return null;
            },
            onChanged: (String value){
              if(value != ""){
                store.editAdditional['font_size'] = num.parse(value);
              } else {
                store.editAdditional['font_size'] = 0;
              }
            },
          ),
        ),
      ],
    );
  }
}