import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return linux;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'demo-api-key'),
    appId: String.fromEnvironment('FIREBASE_APP_ID', defaultValue: '1:1234567890:web:demo'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '1234567890'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'unbiased-ai-demo'),
    authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN', defaultValue: 'unbiased-ai-demo.firebaseapp.com'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'unbiased-ai-demo.appspot.com'),
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'demo-api-key'),
    appId: String.fromEnvironment('FIREBASE_ANDROID_APP_ID', defaultValue: '1:1234567890:android:demo'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '1234567890'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'unbiased-ai-demo'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'unbiased-ai-demo.appspot.com'),
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'demo-api-key'),
    appId: String.fromEnvironment('FIREBASE_IOS_APP_ID', defaultValue: '1:1234567890:ios:demo'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '1234567890'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'unbiased-ai-demo'),
    iosBundleId: String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID', defaultValue: 'com.unbiased.ai.decision'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'unbiased-ai-demo.appspot.com'),
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'demo-api-key'),
    appId: String.fromEnvironment('FIREBASE_MACOS_APP_ID', defaultValue: '1:1234567890:macos:demo'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '1234567890'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'unbiased-ai-demo'),
    iosBundleId: String.fromEnvironment('FIREBASE_MACOS_BUNDLE_ID', defaultValue: 'com.unbiased.ai.decision'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'unbiased-ai-demo.appspot.com'),
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'demo-api-key'),
    appId: String.fromEnvironment('FIREBASE_WINDOWS_APP_ID', defaultValue: '1:1234567890:web:windowsdemo'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '1234567890'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'unbiased-ai-demo'),
    authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN', defaultValue: 'unbiased-ai-demo.firebaseapp.com'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'unbiased-ai-demo.appspot.com'),
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'demo-api-key'),
    appId: String.fromEnvironment('FIREBASE_LINUX_APP_ID', defaultValue: '1:1234567890:web:linuxdemo'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '1234567890'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'unbiased-ai-demo'),
    authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN', defaultValue: 'unbiased-ai-demo.firebaseapp.com'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'unbiased-ai-demo.appspot.com'),
  );
}
