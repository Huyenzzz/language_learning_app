// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDPAnp565Z4oHVIsU1fZVDW376-JHwRhLM',
    appId: '1:334548772190:web:4164e5ee4c443e06229bcf',
    messagingSenderId: '334548772190',
    projectId: 'language-learning-27a19',
    authDomain: 'language-learning-27a19.firebaseapp.com',
    storageBucket: 'language-learning-27a19.firebasestorage.app',
    measurementId: 'G-4YSH4SR7F8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBiZGLmKmYx_Z9-K_YkPsiooxlbuFnuxQc',
    appId: '1:334548772190:android:0ab645b0a639f572229bcf',
    messagingSenderId: '334548772190',
    projectId: 'language-learning-27a19',
    storageBucket: 'language-learning-27a19.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZu_xBhLAj9WA3wGOnD69cAq3Pw28qsEU',
    appId: '1:334548772190:ios:482a66dccd8d87ca229bcf',
    messagingSenderId: '334548772190',
    projectId: 'language-learning-27a19',
    storageBucket: 'language-learning-27a19.firebasestorage.app',
    iosBundleId: 'com.example.languageLearningApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCZu_xBhLAj9WA3wGOnD69cAq3Pw28qsEU',
    appId: '1:334548772190:ios:482a66dccd8d87ca229bcf',
    messagingSenderId: '334548772190',
    projectId: 'language-learning-27a19',
    storageBucket: 'language-learning-27a19.firebasestorage.app',
    iosBundleId: 'com.example.languageLearningApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDPAnp565Z4oHVIsU1fZVDW376-JHwRhLM',
    appId: '1:334548772190:web:a08fde1b611bfde4229bcf',
    messagingSenderId: '334548772190',
    projectId: 'language-learning-27a19',
    authDomain: 'language-learning-27a19.firebaseapp.com',
    storageBucket: 'language-learning-27a19.firebasestorage.app',
    measurementId: 'G-3N6TPHMSQ8',
  );
}