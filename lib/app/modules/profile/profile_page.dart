import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller_white_label/app/core/services/auth/auth_store.dart';
import 'package:delivery_seller_white_label/app/modules/main/main_store.dart';
import 'package:delivery_seller_white_label/app/modules/profile/widget/profile_app_bar.dart';
import 'package:delivery_seller_white_label/app/modules/profile/widget/profile_tile.dart';
import 'package:delivery_seller_white_label/app/shared/utilities.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/confirm_popup.dart';
import 'package:delivery_seller_white_label/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_seller_white_label/app/modules/profile/profile_store.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String title;
  const ProfilePage({Key? key, this.title = 'ProfilePage'}) : super(key: key);
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final ProfileStore store = Modular.get();

  final MainStore mainStore = Modular.get();

  final AuthStore authStore = Modular.get();

  final ScrollController scrollController = ScrollController();

  late OverlayEntry overlayEntry;

  OverlayEntry? overlayCircular;

  @override
  initState() {
    if (store.profileEdit.isEmpty) {
      store.setProfileEditFromDoc();
    }
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          !mainStore.visibleNav) {
        mainStore.setVisibleNav(true);
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          mainStore.visibleNav) {
        mainStore.setVisibleNav(false);
      }
    });
    super.initState();
  }

  @override
  dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }

  OverlayEntry getOverlay() {
    return OverlayEntry(
      builder: (context) => ConfirmPopup(
        text: 'Tem certeza que deseja sair?',
        onConfirm: () async {
          overlayCircular =
              OverlayEntry(builder: (context) => LoadCircularOverlay());
          overlayEntry.remove();
          Overlay.of(context)!.insert(overlayCircular!);
          User? _user = FirebaseAuth.instance.currentUser;
          if (!kIsWeb) {
            String? token = await FirebaseMessaging.instance.getToken();
            await FirebaseFirestore.instance
                .collection('sellers')
                .doc(_user!.uid)
                .update({
              'token_id': FieldValue.arrayRemove([token]),
            });
          }

          authStore.signout();
          overlayCircular!.remove();
          overlayCircular = null;
          mainStore.page = 0;
          store.profileEdit.clear();
          await Modular.to.pushReplacementNamed("/sign");
        },
        onCancel: () {
          overlayEntry.remove();
          // print('naaaaaaoo');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      print(
          "observer store.profileEdit['new_ratings']: ${store.profileEdit['new_ratings']}");
      print("observer store.profileEdit.isEmpty: ${store.profileEdit.isEmpty}");
      if (store.profileEdit.isEmpty) {
        return CenterLoadCircular();
      }
      return Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                SizedBox(height: viewPaddingTop(context) + wXD(70, context)),
                ProfileTile(
                  icon: Icons.star_outline_rounded,
                  title: 'Avaliações',
                  notifications: store.profileEdit['new_ratings'],
                  onTap: () async =>
                      await Modular.to.pushNamed('/profile/ratings'),
                ),
                ProfileTile(
                  icon: Icons.question_answer_outlined,
                  title: 'Perguntas',
                  notifications: store.profileEdit['new_questions'],
                  onTap: () async =>
                      await Modular.to.pushNamed('/profile/questions'),
                ),
                ProfileTile(
                  icon: Icons.email_outlined,
                  title: 'Mensagens',
                  notifications: store.profileEdit['new_messages'],
                  onTap: () async => await Modular.to.pushNamed('/messages'),
                ),
                // ProfileTile(
                //   icon: Icons.account_balance_wallet_outlined,
                //   title: 'Financeiro',
                //   onTap: () async => await Modular.to.pushNamed('/financial'),
                // ),
                // ProfileTile(
                //   icon: Icons.headset_mic_outlined,
                //   title: 'Suporte',
                //   notifications: store.profileEdit['new_support_messages'],
                //   onTap: () async =>
                //       await Modular.to.pushNamed('/profile/support'),
                // ),
                ProfileTile(
                  icon: Icons.settings_outlined,
                  title: 'Configurações',
                  onTap: () async =>
                      await Modular.to.pushNamed('/profile/settings'),
                ),
                ProfileTile(
                  icon: Icons.playlist_add_outlined,
                  title: 'Seções',
                  onTap: () async =>
                      await Modular.to.pushNamed('/profile/additional'),
                ),
                ProfileTile(
                  icon: Icons.category_outlined,
                  title: 'Categorias',
                  onTap: () async => await Modular.to.pushNamed('/categories'),
                ),
                // ProfileTile(
                //   icon: Icons.branding_watermark_outlined,
                //   title: 'Tipos',
                //   onTap: () async =>
                //       await Modular.to.pushNamed('/profile/types'),
                // ),
                ProfileTile(
                  icon: Icons.exit_to_app_outlined,
                  title: 'Sair',
                  onTap: () {
                    overlayEntry = getOverlay();
                    Overlay.of(context)?.insert(overlayEntry);
                  },
                ),
              ],
            ),
          ),
          ProfileAppBar(),
        ],
      );
    });
  }
}
