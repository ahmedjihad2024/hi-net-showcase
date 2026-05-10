import 'package:hi_net/app/constants.dart';
import 'package:hi_net/presentation/common/ui_components/animations/animated_on_appear.dart';
import 'package:hi_net/presentation/common/ui_components/animations/animations_enum.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;
import 'dart:io';

import 'app.dart';

extension NonNullString on String? {
  String get orEmpty => this ?? "";
}

extension NonNullInt on int? {
  int get orEmpty => this ?? 0;
}

extension ThemeSettings on BuildContext {
  set setTheme(ThemeMode theme) =>
      findAncestorStateOfType<MyAppState>()?.setTheme = theme;

  ThemeData get theme => Theme.of(this);

  /// 10.sp
  TextStyle get labelSmall => theme.textTheme.labelSmall!;

  /// 12.sp
  TextStyle get labelMedium => theme.textTheme.labelMedium!;

  /// 14.sp
  TextStyle get labelLarge => theme.textTheme.labelLarge!;

  /// 12.sp
  TextStyle get bodySmall => theme.textTheme.bodySmall!;

  /// 14.sp
  TextStyle get bodyMedium => theme.textTheme.bodyMedium!;

  /// 16.sp
  TextStyle get bodyLarge => theme.textTheme.bodyLarge!;

  /// 14.sp
  TextStyle get titleSmall => theme.textTheme.titleSmall!;

  /// 16.sp
  TextStyle get titleMedium => theme.textTheme.titleMedium!;

  /// 20.sp
  TextStyle get titleLarge => theme.textTheme.titleLarge!;

  /// 18.sp
  TextStyle get headlineSmall => theme.textTheme.headlineSmall!;

  /// 22.sp
  TextStyle get headlineMedium => theme.textTheme.headlineMedium!;

  /// 26.sp
  TextStyle get headlineLarge => theme.textTheme.headlineLarge!;

  /// 30.sp
  TextStyle get displaySmall => theme.textTheme.displaySmall!;

  /// 36.sp
  TextStyle get displayMedium => theme.textTheme.displayMedium!;

  /// 42.sp
  TextStyle get displayLarge => theme.textTheme.displayLarge!;

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  // theme mode
  bool get isDark => themeMode == ThemeMode.dark;
  bool get isLight => themeMode == ThemeMode.light;

  ThemeMode get themeMode {
    ThemeMode mode = findAncestorStateOfType<MyAppState>()!.themeMode;
    final Brightness platformBrightness = MediaQuery.platformBrightnessOf(this);
    return switch (mode) {
      ThemeMode.system =>
        platformBrightness == ui.Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
      _ => mode,
    };
  }
}

extension OnlyNumber on String {
  String get onlyDoubles => replaceAll(RegExp(r'[^0-9.]'), '');
  String get onlyNumbers => replaceAll(RegExp(r'[^0-9]'), '');
}

extension ListReplaceExtension<T> on List<T> {
  void replaceWhere(bool Function(T) test, T replacement) {
    for (int i = 0; i < length; i++) {
      if (test(this[i])) {
        this[i] = replacement;
      }
    }
  }

  void replaceFirstWhere(bool Function(T) test, T replacement) {
    for (int i = 0; i < length; i++) {
      if (test(this[i])) {
        this[i] = replacement;
        break;
      }
    }
  }
}

extension AnimationsExtension on Widget {
  Widget animatedOnAppear(
    int index, [
    SlideDirection slideDirection = SlideDirection.down,
  ]) {
    return AnimatedOnAppear(
      delay: Constants.animationDelay + (30 * index),
      animationDuration: Constants.animationDuration,
      animationCurve: Constants.animationCurve,
      animationTypes: {AnimationType.fade, AnimationType.slide},
      slideDirection: slideDirection,
      slideDistance: Constants.animationSlideDistance,
      blurAnimationCurve: Curves.linear,
      blurIntensity: 1,
      blurEnabled: false,
      child: this,
    );
  }
}


extension ColorExtension on Color {
  String toHexARGB() => '0x${toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
}