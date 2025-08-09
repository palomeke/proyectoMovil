import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// OJO: alias para no chocar con prod
import 'firebase_options_dev.dart' as dev;

import 'smoke_test.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Evita [core/duplicate-app] en hot-restart/hot-reload
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: dev.DefaultFirebaseOptions.currentPlatform,
    );
  }

  // (Opcional) Desactiva Crashlytics en debug
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode);

  // Captura errores Flutter + no-Flutter
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SmokeTestScreen());
  }
}
