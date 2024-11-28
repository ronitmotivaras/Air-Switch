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
    apiKey: 'AIzaSyBlToxVrIhRhGkBNIKnTO48AmC0RlkG-t0',
    appId: '1:389429163098:web:88815ed9332d7925a15463',
    messagingSenderId: '389429163098',
    projectId: 'air-switch-96e32',
    authDomain: 'air-switch-96e32.firebaseapp.com',
    storageBucket: 'air-switch-96e32.firebasestorage.app',
    measurementId: 'G-GW0E1S0ELB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDNcxq9ZY-5Ob1HpyKZkT6PeZ1VZxBrYjY',
    appId: '1:389429163098:android:d9f0019840072ba4a15463',
    messagingSenderId: '389429163098',
    projectId: 'air-switch-96e32',
    storageBucket: 'air-switch-96e32.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCifGaUbxLrFzXeWt2SCw5WZYdQV6wTgcc',
    appId: '1:389429163098:ios:ceae342356affbf3a15463',
    messagingSenderId: '389429163098',
    projectId: 'air-switch-96e32',
    storageBucket: 'air-switch-96e32.firebasestorage.app',
    iosBundleId: 'com.example.airSwitch',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCifGaUbxLrFzXeWt2SCw5WZYdQV6wTgcc',
    appId: '1:389429163098:ios:ceae342356affbf3a15463',
    messagingSenderId: '389429163098',
    projectId: 'air-switch-96e32',
    storageBucket: 'air-switch-96e32.firebasestorage.app',
    iosBundleId: 'com.example.airSwitch',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBlToxVrIhRhGkBNIKnTO48AmC0RlkG-t0',
    appId: '1:389429163098:web:be03aa6c29f39e94a15463',
    messagingSenderId: '389429163098',
    projectId: 'air-switch-96e32',
    authDomain: 'air-switch-96e32.firebaseapp.com',
    storageBucket: 'air-switch-96e32.firebasestorage.app',
    measurementId: 'G-5Q9Z7RVE93',
  );
}
