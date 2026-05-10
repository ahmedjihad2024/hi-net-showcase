import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:hi_net/app/constants.dart';
import 'package:hi_net/app/custom_currencies.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/app/flavor.dart';
import 'package:hi_net/app/services/app_preferences.dart';
import 'package:hi_net/app/supported_locales.dart';
import 'package:hi_net/firebase_options.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/app/services/live_activity_manager.dart';
import 'app/app.dart';
import 'app/dependency_injection.dart';
import 'app/services/firebase_messeging_services.dart';
import 'app/services/flutter_background_services.dart';
import 'app/services/local_notification_services.dart';

// # Run dev flavor on Android
// flutter run --flavor dev -t lib/main_dev.dart
// # Run prod flavor on Android
// flutter run --flavor prod -t lib/main_prod.dart
// # Build Android APK
// flutter build apk --flavor dev --release -t lib/main_dev.dart
// flutter build apk --flavor prod --release -t lib/main_prod.dart
// flutter build appbundle --flavor prod --release -t lib/main_prod.dart

// # Run dev flavor on IOS
// flutter run --flavor dev -t lib/main_dev.dart
// # Run prod flavor on IOS
// flutter run --flavor prod -t lib/main_prod.dart
// # Build release
// flutter build ios --flavor dev --release -t lib/main_dev.dart
// flutter build ios --flavor prod --release -t lib/main_prod.dart

// final LiveActivities LIVE_ACTIVITIES = LiveActivities();

void mainCommon({required Flavor flavor}) {
  runZonedGuarded(
    () async {
      FlavorConfig.fromFlavor(flavor);

      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await MyLocalNotifications.instance.initialize();

      await FirebaseMessegingServices.instance.initialize();
      await initAppModules();

      FirebaseMessegingServices.instance.subscribeToTopicsTryUntilSuccess(
        topics: [flavor.isProd ? "all" : "all_dev"],
      );

      loadMyCurrencies();

      await EasyLocalization.ensureInitialized();

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: null,
          // systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: null,
          statusBarBrightness: null,
        ),
      );

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      runApp(
        EasyLocalization(
          supportedLocales: SupportedLocales.allLocales,
          path: Constants.translationsPath,
          child: MyApp(),
        ),
      );
    },
    (_, error) {
      print(error);
    },
  );
}
