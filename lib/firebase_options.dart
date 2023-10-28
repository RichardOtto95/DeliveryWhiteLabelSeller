// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCTUAfmSX1NMYr051PvEglm-Fznv1Q8r6U',
    appId: '1:344629308261:web:0b531a4cbcea3231b20f8c',
    messagingSenderId: '344629308261',
    projectId: 'white-label-cca4f',
    authDomain: 'white-label-cca4f.firebaseapp.com',
    storageBucket: 'white-label-cca4f.appspot.com',
    measurementId: 'G-SXBVG56098',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCI-DfU8gnIqEoSPM3mWv8zF6lJJXaGaNY',
    appId: '1:344629308261:android:ce5a94299cda1f64b20f8c',
    messagingSenderId: '344629308261',
    projectId: 'white-label-cca4f',
    storageBucket: 'white-label-cca4f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5qy4kGUqsmUqV72nNNuIjdZEm0yMwEFE',
    appId: '1:344629308261:ios:3df22573afeff7ddb20f8c',
    messagingSenderId: '344629308261',
    projectId: 'white-label-cca4f',
    storageBucket: 'white-label-cca4f.appspot.com',
    androidClientId: '344629308261-2s6lbmha69msbieltnlflugeubhl6poq.apps.googleusercontent.com',
    iosClientId: '344629308261-84oe0tkean8ls3nahvd7oln56ov6q2lb.apps.googleusercontent.com',
    iosBundleId: 'com.example.deliverySellerWhiteLabel',
  );
}
