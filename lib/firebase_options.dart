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
    apiKey: 'AIzaSyDHPCt3-dibd3BAUa11lEiGkWpmQSpaYKc',
    appId: '1:335153254797:web:f368fac26ac574a4286dc4',
    messagingSenderId: '335153254797',
    projectId: 'websocket-chat-42ccc',
    authDomain: 'websocket-chat-42ccc.firebaseapp.com',
    storageBucket: 'websocket-chat-42ccc.appspot.com',
    measurementId: 'G-X9MWCPMKRY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB58KBXP1uF--OdHNmLJL4u_VNvrjewAO8',
    appId: '1:335153254797:android:fecae8a047852231286dc4',
    messagingSenderId: '335153254797',
    projectId: 'websocket-chat-42ccc',
    storageBucket: 'websocket-chat-42ccc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDwa65WnBdn-K_JoMxp3WKRjY9aGm-2YwA',
    appId: '1:335153254797:ios:659c74ac2eebba13286dc4',
    messagingSenderId: '335153254797',
    projectId: 'websocket-chat-42ccc',
    storageBucket: 'websocket-chat-42ccc.appspot.com',
    iosBundleId: 'com.example.chatAppAyna',
  );
}
