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
    apiKey: 'AIzaSyDR71NT4hSVAT0UCh5VY8NKscIYyCff_Pk',
    appId: '1:90284857474:web:f83e185ede0779a88f3c9b',
    messagingSenderId: '90284857474',
    projectId: 'carlog-83cb4',
    authDomain: 'carlog-83cb4.firebaseapp.com',
    databaseURL: 'https://carlog-83cb4-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'carlog-83cb4.firebasestorage.app',
    measurementId: 'G-74VSN7N9VZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDCthL_j2xc6-TV9jcqiA-eVB0u-F7cToY',
    appId: '1:90284857474:android:97a928121c9b0b858f3c9b',
    messagingSenderId: '90284857474',
    projectId: 'carlog-83cb4',
    databaseURL: 'https://carlog-83cb4-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'carlog-83cb4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCeBWpu3YFy0elldc9ypsE6XZakSMC1mtM',
    appId: '1:90284857474:ios:385293c41b6b92ba8f3c9b',
    messagingSenderId: '90284857474',
    projectId: 'carlog-83cb4',
    databaseURL: 'https://carlog-83cb4-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'carlog-83cb4.firebasestorage.app',
    iosBundleId: 'com.example.carLog',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCeBWpu3YFy0elldc9ypsE6XZakSMC1mtM',
    appId: '1:90284857474:ios:385293c41b6b92ba8f3c9b',
    messagingSenderId: '90284857474',
    projectId: 'carlog-83cb4',
    databaseURL: 'https://carlog-83cb4-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'carlog-83cb4.firebasestorage.app',
    iosBundleId: 'com.example.carLog',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDR71NT4hSVAT0UCh5VY8NKscIYyCff_Pk',
    appId: '1:90284857474:web:02f895af1b5882188f3c9b',
    messagingSenderId: '90284857474',
    projectId: 'carlog-83cb4',
    authDomain: 'carlog-83cb4.firebaseapp.com',
    databaseURL: 'https://carlog-83cb4-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'carlog-83cb4.firebasestorage.app',
    measurementId: 'G-NZZ1HSZ6RS',
  );
}
