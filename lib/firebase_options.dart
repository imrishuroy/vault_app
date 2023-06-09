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
    apiKey: 'AIzaSyDDqxQuMK1RAXCPXMiUA-ewGoxOk9ywfE0',
    appId: '1:213173857456:web:cedcc06c9b5a5555651f75',
    messagingSenderId: '213173857456',
    projectId: 'secret-vault-1fde8',
    authDomain: 'secret-vault-1fde8.firebaseapp.com',
    storageBucket: 'secret-vault-1fde8.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCMQLgaXOUoIe6b4FES1Y_jWIIFzbHnCek',
    appId: '1:213173857456:android:df8c10b1cb9bb7df651f75',
    messagingSenderId: '213173857456',
    projectId: 'secret-vault-1fde8',
    storageBucket: 'secret-vault-1fde8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAgsEeQdejNGGeIAhsPL8pZS4oZxWsJCug',
    appId: '1:213173857456:ios:47dc07398c2cbfbc651f75',
    messagingSenderId: '213173857456',
    projectId: 'secret-vault-1fde8',
    storageBucket: 'secret-vault-1fde8.appspot.com',
    androidClientId: '213173857456-s2ng5onab4pnahas7jk0motr4ueahh5e.apps.googleusercontent.com',
    iosClientId: '213173857456-rf2ltpm15525j2siopefkv3n2eijuedi.apps.googleusercontent.com',
    iosBundleId: 'com.example.verygoodcore.vault-app',
  );
}
