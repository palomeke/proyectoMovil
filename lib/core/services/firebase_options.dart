import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBR4c1QN1IpDfuyeo4fNu6jgDANNMDs1O4",
    authDomain: "proyectofinal-837ba.firebaseapp.com",
    projectId: "proyectofinal-837ba",
    storageBucket: "proyectofinal-837ba.firebasestorage.app",
    messagingSenderId: "1066616370601",
    appId: "1:1066616370601:web:870619fed97ddf2b3440b8",
    measurementId: "G-7ZMLPR99LN",
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBNPHyjj2L0njzm6bBGLW_lSP-4cpfR98g",
    authDomain: "proyectomovil-adcb4.firebaseapp.com",
    projectId: "proyectomovil-adcb4",
    storageBucket: "proyectomovil-adcb4.firebasestorage.app",
    messagingSenderId: "335321512309",
    appId: "1:335321512309:web:536b99c19c3c905c18bb3c",
    measurementId: "G-R7PHV8LJYX",
  );
}
