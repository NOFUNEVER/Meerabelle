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
        return macos;
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
    apiKey: 'AIzaSyBW4QoXim7TfOgNE31qUX58MBEyri0EdZw',
    appId: '1:774833527223:web:d90c8fb23d628145b63032',
    messagingSenderId: '774833527223',
    projectId: 'meerabelle-88ee6',
    authDomain: 'meerabelle-88ee6.firebaseapp.com',
    storageBucket: 'meerabelle-88ee6.appspot.com',
    measurementId: 'G-Q4MRH8ZTP2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB9xrKAHtysfLKwcQ8ylJZ8q_dyikM1ydI',
    appId: '1:774833527223:android:cef4875311a66e96b63032',
    messagingSenderId: '774833527223',
    projectId: 'meerabelle-88ee6',
    storageBucket: 'meerabelle-88ee6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDltJy5I66rxKdE35YwpcqeaSgSuNdGCVA',
    appId: '1:774833527223:ios:699c6bbba4615576b63032',
    messagingSenderId: '774833527223',
    projectId: 'meerabelle-88ee6',
    storageBucket: 'meerabelle-88ee6.appspot.com',
    androidClientId: '774833527223-tp6nt7k6ae61gkk1dea7q7n1pf41k4ln.apps.googleusercontent.com',
    iosClientId: '774833527223-2b4k4n379917f614hn9duqdarnqmb461.apps.googleusercontent.com',
    iosBundleId: 'com.nofunever.org.meerabelle',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDltJy5I66rxKdE35YwpcqeaSgSuNdGCVA',
    appId: '1:774833527223:ios:699c6bbba4615576b63032',
    messagingSenderId: '774833527223',
    projectId: 'meerabelle-88ee6',
    storageBucket: 'meerabelle-88ee6.appspot.com',
    androidClientId: '774833527223-tp6nt7k6ae61gkk1dea7q7n1pf41k4ln.apps.googleusercontent.com',
    iosClientId: '774833527223-2b4k4n379917f614hn9duqdarnqmb461.apps.googleusercontent.com',
    iosBundleId: 'com.nofunever.org.meerabelle',
  );
}
