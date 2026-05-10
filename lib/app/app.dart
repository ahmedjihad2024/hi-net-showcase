import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hi_net/app/dependency_injection.dart';
import 'package:hi_net/app/services/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:hi_net/presentation/common/utils/after_layout.dart';
import 'package:hi_net/presentation/common/utils/global_keyboard_dismissal.dart';

import 'package:hi_net/presentation/res/routes_manager.dart';
import 'package:hi_net/presentation/res/theme_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

GlobalKey<ScaffoldMessengerState> SCAFFOLD_MESSENGER_KEY =
    GlobalKey<ScaffoldMessengerState>();
GlobalKey<NavigatorState> NAVIGATOR_KEY = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static const MyApp _instance = MyApp._internal();

  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver, AfterLayout {
  late ThemeMode _themeMode;
  Locale? _currentLocale;

  @override
  void initState() {
    SCAFFOLD_MESSENGER_KEY = GlobalKey<ScaffoldMessengerState>();
    NAVIGATOR_KEY = GlobalKey<NavigatorState>();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    if (locales == null || locales.isEmpty) return;

    final newLocale = locales.first;
    if (_currentLocale?.languageCode != newLocale.languageCode) {
      if (mounted) {
        handleLocale(newLocale);
      }
    }
  }

  Future<void> handleLocale(Locale newLocale) async {
    if (EasyLocalization.of(context)!.savedLocale == null) {
      _currentLocale = newLocale;
      await EasyLocalization.of(context)!.setLocale(newLocale);
      await EasyLocalization.of(context)!.resetLocale();
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeMode = switch (instance<AppPreferences>().isDark) {
      true => ThemeMode.dark,
      false => ThemeMode.light,
      null => ThemeMode.system,
    };
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, details) {
        return MaterialApp(
          scrollBehavior: NoBounceScrollBehavior(),
          scaffoldMessengerKey: SCAFFOLD_MESSENGER_KEY,
          navigatorKey: NAVIGATOR_KEY,
          debugShowCheckedModeBanner: false,
          initialRoute: RoutesManager.splash.route,
          theme: ThemeManager.lightTheme(context),
          darkTheme: ThemeManager.darkTheme(context),
          themeMode: _themeMode,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          onGenerateRoute: RoutesGeneratorManager.getRoute,
          builder: (context, child) {
            return GlobalKeyboardDismissal(child: child!);
          },
        );
      },
    );
  }

  set setTheme(ThemeMode themeMode) {
    instance<AppPreferences>().setTheme(themeMode == ThemeMode.dark);
    setState(() {
      _themeMode = themeMode;
    });
    // Phoenix.rebirth(context);
  }

  ThemeMode get themeMode => _themeMode;

  @override
  Future<void> afterLayout(BuildContext context) async {
    _currentLocale = context.locale;
  }
}

class NoBounceScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      ClampingScrollPhysics();
}
