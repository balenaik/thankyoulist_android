import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseInitializer {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    _initializeCrashlytics();
  }

  static void _initializeCrashlytics() {
    if(kDebugMode){
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }
  }

  static void setupUserId(String? userId) {
    FirebaseCrashlytics.instance.setUserIdentifier(userId ?? "");
  }
}