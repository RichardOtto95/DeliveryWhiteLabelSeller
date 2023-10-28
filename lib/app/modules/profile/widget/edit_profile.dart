import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_seller_white_label/app/core/models/time_model.dart';
import 'package:delivery_seller_white_label/app/modules/profile/widget/opening_hours.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../profile_store.dart';
import 'profile_data_tile.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileStore store = Modular.get();
  final genderKey = GlobalKey();
  final bankKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final LayerLink genderLayerLink = LayerLink();
  final LayerLink bankLayerLink = LayerLink();
  late OverlayEntry genderOverlay;
  late OverlayEntry bankOverlay;
  late OverlayEntry loadOverlay;
  OverlayEntry? openHoursOverlay;
  TextEditingController bankTextController = TextEditingController();
  FocusNode fullnameFocus = FocusNode();
  FocusNode usernameFocus = FocusNode();
  FocusNode birthdayFocus = FocusNode();
  FocusNode cpfFocus = FocusNode();
  FocusNode rgFocus = FocusNode();
  FocusNode issuerFocus = FocusNode();
  FocusNode genderFocus = FocusNode();
  FocusNode corporatenameFocus = FocusNode();
  FocusNode storenameFocus = FocusNode();
  FocusNode categoryFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode devolutionFocus = FocusNode();
  FocusNode warrantyFocus = FocusNode();
  FocusNode paymentFocus = FocusNode();
  FocusNode cnpjFocus = FocusNode();
  FocusNode openingHoursFocus = FocusNode();
  FocusNode bankFocus = FocusNode();
  FocusNode agencyFocus = FocusNode();
  FocusNode agencyDigitFocus = FocusNode();
  FocusNode accountDigitFocus = FocusNode();
  FocusNode accountFocus = FocusNode();
  FocusNode operationFocus = FocusNode();

  @override
  void initState() {
    // print("store.profileEdit['bank']: ${store.profileEdit["bank"]}");
    // bankTextController = TextEditingController(text: store.profileEdit["bank"]);
    // bankCodeTextController = TextEditingController(text: store.profileEdit["bank_code"]);
    store.setProfileEditFromDoc();
    addGenderFocusListener();
    addBankFocusListener();
    addBirthdayFocusListener();
    super.initState();
  }

  @override
  void dispose() {
    bankTextController.dispose();
    openingHoursFocus.dispose();
    store.setProfileEditFromDoc();
    fullnameFocus.dispose();
    usernameFocus.dispose();
    birthdayFocus.removeListener(() {});
    birthdayFocus.dispose();
    cpfFocus.dispose();
    rgFocus.dispose();
    issuerFocus.dispose();
    genderFocus.removeListener(() {});
    genderFocus.dispose();
    corporatenameFocus.dispose();
    storenameFocus.dispose();
    categoryFocus.dispose();
    descriptionFocus.dispose();
    devolutionFocus.dispose();
    warrantyFocus.dispose();
    paymentFocus.dispose();
    cnpjFocus.dispose();
    bankFocus.removeListener(() {});
    bankFocus.dispose();
    agencyFocus.dispose();
    accountFocus.dispose();
    operationFocus.dispose();
    super.dispose();
  }

  Future scrollToGender() async {
    final _context = genderKey.currentContext;
    double proportion = hXD(73, context) / maxWidth(context);
    // print(
    //     "propotion: ${(maxHeight(context) *) / maxHeight(context)}");
    await Scrollable.ensureVisible(_context!,
        alignment: proportion, duration: Duration(milliseconds: 400));
  }

  Future scrollToBank() async {
    final _context = bankKey.currentContext;
    double proportion = hXD(73, context) / maxWidth(context);
    // print(
    //     "propotion: ${(maxHeight(context) *) / maxHeight(context)}");
    await Scrollable.ensureVisible(_context!,
        alignment: proportion, duration: Duration(milliseconds: 400));
  }

  addGenderFocusListener() {
    genderFocus.addListener(() async {
      if (genderFocus.hasFocus) {
        scrollToGender();
        genderOverlay = getGenderOverlay();
        Overlay.of(context)!.insert(genderOverlay);
      } else {
        genderOverlay.remove();
      }
    });
  }

  addBankFocusListener() {
    bankFocus.addListener(() async {
      if (bankFocus.hasFocus) {
        scrollToBank();
        bankOverlay = getBankOverlay();
        Overlay.of(context)!.insert(bankOverlay);
      } else {
        bankOverlay.remove();
      }
    });
  }

  addBirthdayFocusListener() {
    birthdayFocus.addListener(() async {
      if (birthdayFocus.hasFocus) {
        FocusScope.of(context).requestFocus(new FocusNode());
        await store.setBirthday(context, () {
          cpfFocus.requestFocus();
        });
      }
    });
  }

  OverlayEntry getGenderOverlay() {
    List<String> genders = ["Feminino", "Masculino", "Outro"];
    return OverlayEntry(
      builder: (context) => Positioned(
        height: wXD(100, context),
        width: wXD(80, context),
        child: CompositedTransformFollower(
          offset: Offset(wXD(35, context), wXD(60, context)),
          link: genderLayerLink,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    // topRight: Radius.circular(3),
                    // bottomLeft: Radius.circular(3),
                    ),
                color: getColors(context).surface,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    offset: Offset(0, 3),
                    color: getColors(context).shadow,
                  )
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: genders
                    .map(
                      (gender) => InkWell(
                        onTap: () {
                          store.profileEdit['gender'] = gender;
                          genderFocus.unfocus();
                          corporatenameFocus.requestFocus();
                        },
                        child: Container(
                          height: wXD(20, context),
                          padding: EdgeInsets.only(left: wXD(8, context)),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            gender,
                            style: textFamily(context),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry getBankOverlay() {
    if (store.bankDocs == null) {
      store.getBanks();
    }

    return OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        width: wXD(320, context),
        height: wXD(270, context),
        child: CompositedTransformFollower(
          offset: Offset(
            (maxWidth(context) - wXD(320, context)) / 2,
            wXD(80, context),
          ),
          link: bankLayerLink,
          child: Container(
            padding: EdgeInsets.all(wXD(5, context)),
            decoration: BoxDecoration(
              color: getColors(context).surface,
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  offset: Offset(0, 3),
                  color: getColors(context).shadow,
                )
              ],
            ),
            child: Material(
              color: getColors(context).surface,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(wXD(5, context)),
                child: Observer(
                  builder: (context) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      store.searchBank(bankTextController.text);
                    });
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (store.bankDocs == null)
                          Padding(
                            padding: EdgeInsets.only(top: wXD(100, context)),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        if (store.bankDocsSearch.isNotEmpty)
                          ...store.bankDocsSearch
                              .map(
                                (bank) => InkWell(
                                  onTap: () {
                                    bankTextController.text = bank.get("label");
                                    store.profileEdit['bank'] =
                                        bank.get("label");
                                    agencyFocus.requestFocus();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: getColors(context)
                                                .onSurface
                                                .withOpacity(.7),
                                            width: 1),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(wXD(6, context)),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      bank.get("label"),
                                      style: textFamily(
                                        context,
                                        color: getColors(context).onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        if (store.bankDocs != null &&
                            store.bankDocsSearch.isEmpty)
                          ...store.bankDocs!
                              .map(
                                (bank) => InkWell(
                                  onTap: () {
                                    bankTextController.text = bank.get("label");
                                    store.profileEdit['bank'] =
                                        bank.get("label");
                                    agencyFocus.requestFocus();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: getColors(context)
                                                .onSurface
                                                .withOpacity(.7),
                                            width: 1),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(wXD(6, context)),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      bank.get("label"),
                                      style: textFamily(
                                        context,
                                        color: getColors(context).onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (openHoursOverlay != null) {
          openHoursOverlay!.remove();
          openHoursOverlay = null;
          return false;
        }
        return true;
      },
      child: Listener(
        onPointerDown: (event) =>
            FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          body: Stack(
            children: [
              Observer(
                builder: (context) {
                  if (store.profileEdit.isEmpty) {
                    return CenterLoadCircular();
                  }
                  return SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height:
                                  viewPaddingTop(context) + wXD(50, context)),
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 3,
                                        offset: Offset(0, 3),
                                        color: getColors(context).shadow)
                                  ],
                                ),
                                child: Container(
                                  height: wXD(338, context),
                                  width: maxWidth(context),
                                  child: store.profileEdit['avatar'] == null ||
                                          store.profileEdit['avatar'] == ""
                                      ? Image.asset(
                                          "./assets/images/defaultUser.png",
                                          height: wXD(338, context),
                                          width: maxWidth(context),
                                          fit: BoxFit.fitWidth,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: store.profileEdit['avatar'],
                                          height: wXD(338, context),
                                          width: maxWidth(context),
                                          fit: BoxFit.fitWidth,
                                          progressIndicatorBuilder: (context,
                                              value, donwloadProgress) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: getColors(context).primary,
                                            ));
                                          },
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: wXD(30, context),
                                right: wXD(17, context),
                                child: InkWell(
                                  onTap: () => store.pickAvatar(),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: getColors(context).onSurface,
                                    size: wXD(30, context),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Visibility(
                            visible: store.avatarValidate,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: wXD(24, context),
                                  top: wXD(15, context)),
                              child: Text(
                                "Selecione uma imagem para continuar",
                                style: TextStyle(
                                  color: Colors.red[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: wXD(23, context), top: wXD(21, context)),
                            child: Text(
                              'Dados do proprietário',
                              style: textFamily(
                                context,
                                fontSize: 16,
                                color: getColors(context).primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ProfileDataTile(
                            title: 'Nome completo',
                            data: store.profileEdit['fullname'],
                            hint: 'Fulano Ciclano',
                            focusNode: fullnameFocus,
                            onComplete: () {
                              usernameFocus.requestFocus();
                            },
                            onChanged: (txt) =>
                                store.profileEdit['fullname'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Nome de usuário',
                            data: store.profileEdit['username'],
                            hint: 'Fulano Ciclano',
                            focusNode: usernameFocus,
                            onComplete: () {
                              birthdayFocus.requestFocus();
                            },
                            onChanged: (txt) =>
                                store.profileEdit['username'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Data de nascimento',
                            hint: '99/99/9999',
                            data: store.profileEdit['birthday'] != null
                                ? Time(store.profileEdit['birthday'].toDate())
                                    .dayDate()
                                : null,
                            onPressed: () {
                              birthdayFocus.requestFocus();
                            },
                            focusNode: birthdayFocus,
                            validate: store.birthdayValidate,
                          ),
                          ProfileDataTile(
                            title: 'CPF',
                            hint: '999.999.999-99',
                            textInputType: TextInputType.number,
                            data: cpfMask
                                .maskText(store.profileEdit['cpf'] ?? ''),
                            mask: cpfMask,
                            length: 11,
                            focusNode: cpfFocus,
                            onComplete: () => rgFocus.requestFocus(),
                            onChanged: (txt) => store.profileEdit['cpf'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Telefone',
                            hint: '(99) 99999-9999',
                            textInputType: TextInputType.number,
                            data: fullNumberMask
                                .maskText(store.profileEdit['phone']),
                          ),
                          ProfileDataTile(
                            title: 'RG',
                            hint: '99999999',
                            textInputType: TextInputType.number,
                            data: store.profileEdit['rg'],
                            // mask: rgMask,
                            length: null,
                            focusNode: rgFocus,
                            onComplete: () => issuerFocus.requestFocus(),
                            onChanged: (txt) => store.profileEdit['rg'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Órgão emissor',
                            hint: 'SSP',
                            inputFormatter: UpperCaseTextFormatter(),
                            data: store.profileEdit['issuing_agency'],
                            focusNode: issuerFocus,
                            onComplete: () => genderFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.profileEdit['issuing_agency'] = txt,
                          ),
                          CompositedTransformTarget(
                            link: genderLayerLink,
                            child: ProfileDataTile(
                              key: genderKey,
                              title: 'Gênero',
                              hint: 'Feminino',
                              data: store.profileEdit['gender'],
                              focusNode: genderFocus,
                              validate: store.genderValidate,
                              onPressed: () {
                                // print("Render press");
                                genderFocus.requestFocus();
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: wXD(23, context), top: wXD(21, context)),
                            child: Text(
                              'Dados da loja',
                              style: textFamily(
                                context,
                                fontSize: 16,
                                color: getColors(context).primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ProfileDataTile(
                            title: 'Razão social',
                            hint: 'Lorem ipsum dolor sit amet',
                            data: store.profileEdit['corporate_name'],
                            focusNode: corporatenameFocus,
                            onComplete: () => storenameFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.profileEdit['corporate_name'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Nome da loja',
                            hint: 'Lorem ipsum dolor sit amet',
                            data: store.profileEdit['store_name'],
                            focusNode: storenameFocus,
                            onComplete: () => categoryFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.profileEdit['store_name'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Categoria da loja',
                            hint: 'Lorem ipsum dolor sit amet',
                            data: store.profileEdit['store_category'],
                            focusNode: categoryFocus,
                            onComplete: () => descriptionFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.profileEdit['store_category'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Descrição da loja',
                            hint: 'Lorem ipsum dolor sit amet',
                            data: store.profileEdit['store_description'],
                            focusNode: descriptionFocus,
                            onComplete: () => devolutionFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.profileEdit['store_description'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Políticas de devolução grátis',
                            hint: 'Lorem ipsum dolor sit amet',
                            data: store.profileEdit['return_policies'],
                            focusNode: devolutionFocus,
                            onComplete: () => warrantyFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.profileEdit['return_policies'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Garantia',
                            hint: 'Lorem ipsum dolor sit amet',
                            data: store.profileEdit['warranty'],
                            focusNode: warrantyFocus,
                            onComplete: () => cnpjFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.profileEdit['warranty'] = txt,
                          ),
                          // ProfileDataTile(
                          //   title: 'Forma de pagamento',
                          //   hint: 'Lorem ipsum dolor sit amet',
                          //   data: store.profileEdit['payment_method'],
                          //   focusNode: paymentFocus,
                          //   onComplete: () => cnpjFocus.requestFocus(),
                          //   onChanged: (txt) =>
                          //       store.profileEdit['payment_method'] = txt,
                          // ),
                          ProfileDataTile(
                            title: 'CNPJ',
                            hint: '99.999.999/9999-99',
                            focusNode: cnpjFocus,
                            textInputType: TextInputType.number,
                            data: cnpjMask
                                .maskText(store.profileEdit['cnpj'] ?? ''),
                            mask: cnpjMask,
                            length: 14,
                            needValidation:
                                store.profileEdit['is_juridic_person'],
                            onComplete: () => openingHoursFocus.requestFocus(),
                            onChanged: (txt) => store.profileEdit['cnpj'] = txt,
                          ),
                          ProfileDataTile(
                            textInputType: TextInputType.number,
                            title: 'Horário de funcionamento',
                            hint: 'Seg a Sex, das 14:00 às 16:00',
                            focusNode: openingHoursFocus,
                            data: store.profileEdit["opening_hours"],
                            onPressed: () {
                              openHoursOverlay = OverlayEntry(
                                builder: (context) => OpeningHours(onBack: () {
                                  openHoursOverlay!.remove();
                                  openHoursOverlay = null;
                                }),
                              );
                              Overlay.of(context)!.insert(openHoursOverlay!);
                            },
                            // mask: openingHoursMask,
                            // length: 8,
                            // onComplete: () => bankFocus.requestFocus(),
                            // onChanged: (txt) =>
                            //     store.profileEdit['opening_hours'] = txt,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: wXD(23, context), top: wXD(21, context)),
                            child: Text(
                              'Dados bancários',
                              style: textFamily(context,
                                  fontSize: 16,
                                  color: getColors(context).primary,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          CompositedTransformTarget(
                            link: bankLayerLink,
                            child: ProfileDataTile(
                              key: bankKey,
                              title: 'Banco',
                              controller: bankTextController,
                              data: store.profileEdit['bank'],
                              onChanged: (txt) => store.searchBank(txt),
                              hint: 'Selecione seu banco',
                              focusNode: bankFocus,
                              // data2: "aleola",
                            ),
                          ),
                          ProfileDataTile(
                            title: 'Agência',
                            hint: '9999',
                            textInputType: TextInputType.number,
                            data: store.profileEdit['agency'],
                            // mask: agencyMask,
                            focusNode: agencyFocus,
                            // length: 4,
                            onComplete: () => agencyDigitFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.profileEdit['agency'] = txt,
                            data2: store.profileEdit["agency_digit"],
                            focusNode2: agencyDigitFocus,
                            hint2: "1",
                            onChanged2: (txt) =>
                                store.profileEdit["agency_digit"] = txt,
                            onComplete2: () => accountFocus.requestFocus(),
                          ),
                          ProfileDataTile(
                            title: 'Conta',
                            hint: '999999999-99',
                            textInputType: TextInputType.number,
                            data: store.profileEdit['account'],
                            mask: accountMask,
                            focusNode: accountFocus,
                            length: 11,
                            onComplete: () => accountDigitFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.profileEdit['account'] = txt,
                            data2: store.profileEdit["account_digit"],
                            focusNode2: accountDigitFocus,
                            hint2: "1",
                            onChanged2: (txt) =>
                                store.profileEdit["account_digit"] = txt,
                            onComplete2: () => operationFocus.requestFocus(),
                          ),
                          ProfileDataTile(
                            title: 'Operação',
                            hint: '999',
                            textInputType: TextInputType.number,
                            data: store.profileEdit['operation'],
                            mask: operationMask,
                            focusNode: operationFocus,
                            length: 3,
                            onComplete: () => operationFocus.unfocus(),
                            onChanged: (txt) =>
                                store.profileEdit['operation'] = txt,
                          ),
                          SavingsCNPJ(),
                          SideButton(
                            onTap: () async {
                              bool _validate = store.getValidate();
                              if (_formKey.currentState!.validate() &&
                                  _validate) {
                                await store.saveProfile(context);
                              } else {
                                showToast(
                                  "Verifique os campos e ente novamente",
                                  error: true,
                                );
                              }

                              // final banksCol = await FirebaseFirestore.instance
                              //     .collection("info")
                              //     .doc(infoId)
                              //     .collection("banks")
                              //     .get();

                              // for (DocumentSnapshot doc in banksCol.docs) {
                              //   doc.reference.update({
                              //     "label":
                              //         "${doc.get("code")} - ${doc.get("label")}",
                              //     "code": FieldValue.delete()
                              //   });
                              // }

                              // servPerCol.docs.forEach((servingPeriod) async {
                              //   await servingPeriod.reference.update({
                              //     "created_at": FieldValue.serverTimestamp(),
                              //   });
                              // });

                              // for (int i = 1; i <= 7; i++) {
                              //   final servingPeriod = FirebaseFirestore.instance
                              //       .collection("sellers")
                              //       .doc("Iz3wa9Ou9GP4DDnpbi3yEtfNQbJ3")
                              //       .collection("service_periods")
                              //       .doc(i.toString());

                              //   await servingPeriod.set({
                              //     "week_day": i,
                              //     "start_hour": null,
                              //     "end_hour": null,
                              //     "id": servingPeriod.id,
                              //   });
                              // }

                              // await FirebaseFirestore.instance
                              //     .collection("sellers")
                              //     .get()
                              //     .then((value) {
                              //   for (var doc in value.docs) {
                              //     doc.reference.update({
                              //       "is_juridic_person": null,
                              //     });
                              //   }
                              // });
                            },
                            height: wXD(52, context),
                            width: wXD(142, context),
                            title: 'Salvar',
                          ),
                          SizedBox(height: wXD(20, context))
                        ],
                      ),
                    ),
                  );
                },
              ),
              DefaultAppBar('Editar perfil')
            ],
          ),
        ),
      ),
    );
  }
}

class SavingsCNPJ extends StatelessWidget {
  final ProfileStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: wXD(26, context),
        top: wXD(16, context),
        bottom: wXD(33, context),
      ),
      alignment: Alignment.centerLeft,
      child: Observer(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Esta é uma conta poupança?',
                style: textFamily(context,
                    color: getColors(context).onBackground.withOpacity(.6)),
              ),
              SizedBox(height: wXD(10, context)),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(3),
                    onTap: () => store.profileEdit['savings_account'] = true,
                    child: Container(
                      height: wXD(17, context),
                      width: wXD(17, context),
                      margin: EdgeInsets.only(right: wXD(9, context)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: getColors(context).primary,
                            width: wXD(2, context)),
                      ),
                      alignment: Alignment.center,
                      child: store.profileEdit['savings_account']
                          ? Container(
                              height: wXD(9, context),
                              width: wXD(9, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getColors(context).primary,
                              ),
                            )
                          : Container(),
                    ),
                  ),
                  Text(
                    'Sim',
                    style: textFamily(context,
                        color: getColors(context).onBackground.withOpacity(.6)),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(3),
                    onTap: () => store.profileEdit['savings_account'] = false,
                    child: Container(
                      height: wXD(17, context),
                      width: wXD(17, context),
                      margin: EdgeInsets.only(
                          right: wXD(9, context), left: wXD(15, context)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: getColors(context).primary,
                            width: wXD(2, context)),
                      ),
                      alignment: Alignment.center,
                      child: store.profileEdit['savings_account']
                          ? Container()
                          : Container(
                              height: wXD(9, context),
                              width: wXD(9, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getColors(context).primary,
                              ),
                            ),
                    ),
                  ),
                  Text(
                    'Não',
                    style: textFamily(context,
                        color: getColors(context).onBackground.withOpacity(.6)),
                  ),
                ],
              ),
              SizedBox(height: wXD(24, context)),
              Text(
                'Esta conta está vinculada ao cpf do proprietário\nou ao cnpj da loja?',
                style: textFamily(context,
                    color: getColors(context).onBackground.withOpacity(.6)),
              ),
              SizedBox(height: wXD(10, context)),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(3),
                    onTap: () => store.profileEdit['linked_to_cnpj'] = true,
                    child: Container(
                      height: wXD(17, context),
                      width: wXD(17, context),
                      margin: EdgeInsets.only(right: wXD(9, context)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: getColors(context).primary,
                            width: wXD(2, context)),
                      ),
                      alignment: Alignment.center,
                      child: store.profileEdit['linked_to_cnpj']
                          ? Container(
                              height: wXD(9, context),
                              width: wXD(9, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getColors(context).primary,
                              ),
                            )
                          : Container(),
                    ),
                  ),
                  Text(
                    'Sim',
                    style: textFamily(context,
                        color: getColors(context).onBackground.withOpacity(.6)),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(3),
                    onTap: () => store.profileEdit['linked_to_cnpj'] = false,
                    child: Container(
                      height: wXD(17, context),
                      width: wXD(17, context),
                      margin: EdgeInsets.only(
                          right: wXD(9, context), left: wXD(15, context)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: getColors(context).primary,
                            width: wXD(2, context)),
                      ),
                      alignment: Alignment.center,
                      child: store.profileEdit['linked_to_cnpj']
                          ? Container()
                          : Container(
                              height: wXD(9, context),
                              width: wXD(9, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getColors(context).primary,
                              ),
                            ),
                    ),
                  ),
                  Text(
                    'Não',
                    style: textFamily(context,
                        color: getColors(context).onBackground.withOpacity(.6)),
                  ),
                ],
              ),
              SizedBox(height: wXD(24, context)),
              Text(
                'Sou pessoa jurídica ou física?',
                style: textFamily(context,
                    color: getColors(context).onBackground.withOpacity(.6)),
              ),
              SizedBox(height: wXD(10, context)),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(3),
                    onTap: () => store.profileEdit['is_juridic_person'] = true,
                    child: Container(
                      height: wXD(17, context),
                      width: wXD(17, context),
                      margin: EdgeInsets.only(right: wXD(9, context)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: getColors(context).primary,
                            width: wXD(2, context)),
                      ),
                      alignment: Alignment.center,
                      child: store.profileEdit['is_juridic_person']
                          ? Container(
                              height: wXD(9, context),
                              width: wXD(9, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getColors(context).primary,
                              ),
                            )
                          : Container(),
                    ),
                  ),
                  Text(
                    'Jurídica',
                    style: textFamily(context,
                        color: getColors(context).onBackground.withOpacity(.6)),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(3),
                    onTap: () => store.profileEdit['is_juridic_person'] = false,
                    child: Container(
                      height: wXD(17, context),
                      width: wXD(17, context),
                      margin: EdgeInsets.only(
                          right: wXD(9, context), left: wXD(15, context)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: getColors(context).primary,
                            width: wXD(2, context)),
                      ),
                      alignment: Alignment.center,
                      child: store.profileEdit['is_juridic_person']
                          ? Container()
                          : Container(
                              height: wXD(9, context),
                              width: wXD(9, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getColors(context).primary,
                              ),
                            ),
                    ),
                  ),
                  Text(
                    'Física',
                    style: textFamily(context,
                        color: getColors(context).onBackground.withOpacity(.6)),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
