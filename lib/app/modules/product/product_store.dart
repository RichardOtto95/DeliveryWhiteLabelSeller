import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:mobx/mobx.dart';

part 'product_store.g.dart';

class ProductStore = _ProductStoreBase with _$ProductStore;

abstract class _ProductStoreBase with Store {
  @observable
  int imageIndex = 1;
  @observable
  ObservableList<DocumentSnapshot> ratings =
      <DocumentSnapshot>[].asObservable();

  @action
  Future<Map<String, dynamic>> getAdditionalQuery(String adsId) async {
    final User user = FirebaseAuth.instance.currentUser!;
    QuerySnapshot additionalQuery = await FirebaseFirestore.instance.collection('ads').doc(adsId).collection('additional').orderBy('index').get();  
    List<DocumentSnapshot> customerAdditional = [];
    List<Map<String, dynamic>> sellerAdditional = [];

    for (var i = 0; i < additionalQuery.docs.length; i++) {
      DocumentSnapshot additionalDoc = await FirebaseFirestore.instance.collection('sellers').doc(user.uid).collection('additional').doc(additionalQuery.docs[i].id).get();
      if(additionalDoc['customer_config'] == "edition"){
        customerAdditional.add(additionalDoc);
      } else {
        Map<String, dynamic> response = {};
        DocumentSnapshot additionalResponseDoc = additionalQuery.docs[i];

        switch (additionalDoc['type']) {
          case "check-box":
            QuerySnapshot checkboxResponseQuery = await additionalResponseDoc.reference.collection('checkbox').get();
            Map<String, bool> checkboxResponse = {};
            for (var i = 0; i < checkboxResponseQuery.docs.length; i++) {
              DocumentSnapshot checkboxDoc = checkboxResponseQuery.docs[i];
              checkboxResponse.putIfAbsent(checkboxDoc['id'], () => checkboxDoc['response']);
            }

            response = checkboxResponse;
            break;

          case "radio-button":
            QuerySnapshot radiobuttonResponseQuery = await additionalDoc.reference.collection('radiobutton').get();

            int index = 0;
            for (var i = 0; i < radiobuttonResponseQuery.docs.length; i++) {
              DocumentSnapshot radiobuttonDoc = radiobuttonResponseQuery.docs[i];
              if(radiobuttonDoc['label'] == additionalResponseDoc['response_label']){
                index = radiobuttonDoc['index'];
                break;
              }
            }

            response = {"index": index};
            break;

          case "combo-box":
            response = {"label": additionalResponseDoc['response_label']};
            break;

          case "text-field":
            response = {"text": additionalResponseDoc['response_text']};
            break;

          case "text-area":
            response = {"text": additionalResponseDoc['response_text']};
            break;

          case "increment":
            response = {"count": additionalResponseDoc['response_count']};
            break;

          default:
        }
        sellerAdditional.add({
          "doc": additionalDoc,
          "response": response,
        });        
      }
    }

    return {
      "customer-additional": customerAdditional,
      "seller-additional": sellerAdditional,
    };

  }

  // @action
  // Future<List<DocumentSnapshot>> getAdditionalList(String adsId) async{
  //   final User user = FirebaseAuth.instance.currentUser!;
  //   QuerySnapshot additionalQuery = await FirebaseFirestore.instance.collection('ads').doc(adsId).collection('additional').orderBy('index').get();

  //   List<DocumentSnapshot> additionalList = [];
  //   for (var i = 0; i < additionalQuery.docs.length; i++) {
  //     DocumentSnapshot additionalDoc = await FirebaseFirestore.instance.collection('sellers').doc(user.uid).collection('additional').doc(additionalQuery.docs[i].id).get();
  //     if(additionalDoc['customer_config'] == "edition"){
  //       additionalList.add(additionalDoc);
  //     }
  //   }

  //   return additionalList;
  // }

  // @action
  // Future<List<Map<String, dynamic>>> getProductInformationsList(String adsId) async{
  //   final User user = FirebaseAuth.instance.currentUser!;
  //   QuerySnapshot additionalQuery = await FirebaseFirestore.instance.collection('ads').doc(adsId).collection('additional').orderBy('index').get();
  //   List<Map<String, dynamic>> additionalList = [];
  //   for (var i = 0; i < additionalQuery.docs.length; i++) {
  //     Map<String, dynamic> response = {};
  //     DocumentSnapshot additionalResponseDoc = additionalQuery.docs[i];
  //     DocumentSnapshot<Map<String, dynamic>> additionalDoc = await FirebaseFirestore.instance.collection('sellers').doc(user.uid).collection('additional').doc(additionalQuery.docs[i].id).get();

  //     if(additionalDoc["seller_config"] == "edition"){
  //       switch (additionalDoc['type']) {
  //         case "check-box":
  //           QuerySnapshot checkboxResponseQuery = await additionalResponseDoc.reference.collection('checkbox').get();
  //           Map<String, bool> checkboxResponse = {};
  //           for (var i = 0; i < checkboxResponseQuery.docs.length; i++) {
  //             DocumentSnapshot checkboxDoc = checkboxResponseQuery.docs[i];
  //             checkboxResponse.putIfAbsent(checkboxDoc['id'], () => checkboxDoc['response']);
  //           }

  //           response = checkboxResponse;
  //           break;

  //         case "radio-button":
  //         // print('case "radio-button":');
  //           QuerySnapshot radiobuttonResponseQuery = await additionalDoc.reference.collection('radiobutton').get();
  //           // print('radiobuttonResponseQuery: ${radiobuttonResponseQuery.docs.length}');

  //           int index = 0;
  //           for (var i = 0; i < radiobuttonResponseQuery.docs.length; i++) {
  //             DocumentSnapshot radiobuttonDoc = radiobuttonResponseQuery.docs[i];
  //             // print('radiobuttonDoc[label] == additionalResponseDoc[response_label]: ${radiobuttonDoc['label']} == ${additionalResponseDoc['response_label']}');
  //             if(radiobuttonDoc['label'] == additionalResponseDoc['response_label']){
  //               index = radiobuttonDoc['index'];
  //               break;
  //             }
  //           }

  //           response = {"index": index};
  //           break;

  //         case "combo-box":
  //           response = {"label": additionalResponseDoc['response_label']};
  //           break;

  //         case "text-field":
  //           response = {"text": additionalResponseDoc['response_text']};
  //           break;

  //         case "text-area":
  //           response = {"text": additionalResponseDoc['response_text']};
  //           break;

  //         case "increment":
  //           response = {"count": additionalResponseDoc['response_count']};
  //           break;

  //         default:
  //       }
  //       additionalList.add({
  //         "doc": additionalDoc,
  //         "response": response,
  //       });
  //     }
  //   }
  //   return additionalList;
  // }

  @action
  void setImageIndex(_imageIndex) => imageIndex = _imageIndex;

  @action 
  Future<Map<String, dynamic>> getAverageRating(String adsId) async {
    QuerySnapshot ratingsQuery = await FirebaseFirestore.instance.collection('ads')
      .doc(adsId)
      .collection('ratings')
      .where("status", isEqualTo: "VISIBLE")
      .get();

    // print('ratingsQuery: ${ratingsQuery.docs.length}');
      
    num averageRating = 0;
    num lengthRating = ratingsQuery.docs.length;

    for (var ratingDoc in ratingsQuery.docs) {
      averageRating += ratingDoc['rating'];    
    }

    if(lengthRating != 0){
      averageRating = averageRating / lengthRating;
    }
     
    return {
      "length-rating": lengthRating,
      "average-rating": averageRating,
    };
  }

  void getRatings(int ratingView, List<DocumentSnapshot> ratingDocs) {
    print("ratingView: $ratingView ratingDocs: $ratingDocs");
    if (ratingView == 0) {
      ratings = ratingDocs.asObservable();
    } else {
      List<DocumentSnapshot> opnionsDocs = [];
      for (DocumentSnapshot ratingDoc in ratingDocs) {
        print("product_ratings: ${ratingDoc["rating"]} ");
        if (ratingView == 1 && ratingDoc["rating"] >= 3) {
          opnionsDocs.add(ratingDoc);
        } else if (ratingView == 2 && ratingDoc["rating"] < 3) {
          opnionsDocs.add(ratingDoc);
        }
      }
      ratings = opnionsDocs.asObservable();
    }
    print("ratings: $ratings");
  }

  @action
  Future<void> share() async {
    await FlutterShare.share(
      title: 'Se liga!!',
      text: 'Se liga nesse aplicativo Mercado Expresso',
      linkUrl: 'https://delivery-dev-319ba.web.app/',
      chooserTitle: 'Compartilhar usando'
    );
  }
}
