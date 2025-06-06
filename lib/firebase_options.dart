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
    apiKey: 'AIzaSyCickN5jndv6cvqTMG5dBatlDzpyCoX6kE',
    appId: '1:575287548585:web:2ef8673998303682e227b8',
    messagingSenderId: '575287548585',
    projectId: 'libro-662a8',
    authDomain: 'libro-662a8.firebaseapp.com',
    storageBucket: 'libro-662a8.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBanHZNPD6grm39pZHhBzklQMneZ3E0qOQ',
    appId: '1:575287548585:android:4f9216a01135b9e8e227b8',
    messagingSenderId: '575287548585',
    projectId: 'libro-662a8',
    storageBucket: 'libro-662a8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBfDUzZowd-sPWpjP0S2cryOQTsasgIKR0',
    appId: '1:575287548585:ios:5c33e0b4ac01f75ae227b8',
    messagingSenderId: '575287548585',
    projectId: 'libro-662a8',
    storageBucket: 'libro-662a8.firebasestorage.app',
    iosBundleId: 'com.example.libroAdmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBfDUzZowd-sPWpjP0S2cryOQTsasgIKR0',
    appId: '1:575287548585:ios:5c33e0b4ac01f75ae227b8',
    messagingSenderId: '575287548585',
    projectId: 'libro-662a8',
    storageBucket: 'libro-662a8.firebasestorage.app',
    iosBundleId: 'com.example.libroAdmin',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCickN5jndv6cvqTMG5dBatlDzpyCoX6kE',
    appId: '1:575287548585:web:8204cd0bc2bd7063e227b8',
    messagingSenderId: '575287548585',
    projectId: 'libro-662a8',
    authDomain: 'libro-662a8.firebaseapp.com',
    storageBucket: 'libro-662a8.firebasestorage.app',
  );
}
