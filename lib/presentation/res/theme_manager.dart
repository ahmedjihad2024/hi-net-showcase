import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:smooth_corner/smooth_corner.dart';

import 'color_manager.dart';

class ThemeManager {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
    fontFamily: context.locale.languageCode == 'ar' ? FontsM.IBMPlexSansArabic.name : FontsM.Lexend.name,
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: ColorM.primary,
      // black and whie
      surface: Colors.black,
      // while and black
      onSurface: Colors.white,

      // white and ad degree of black colors in dark mode
      secondary: Colors.white,
    ),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextStyles.customTextTheme(Colors.black),
    visualDensity: VisualDensity.comfortable,
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // padding: WidgetStatePropertyAll(EdgeInsets.zero),
        minimumSize: WidgetStatePropertyAll(Size.zero),
        backgroundColor: WidgetStatePropertyAll(ColorM.primary),
        iconColor: WidgetStatePropertyAll(Colors.white),
        iconSize: WidgetStatePropertyAll(12.sp),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size.zero),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.black.withValues(alpha: .5);
          }
          return ColorM.primary;
        }),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        // minimumSize: WidgetStatePropertyAll(Size(double.infinity, 60.w)),
        shape: WidgetStatePropertyAll(
          SmoothRectangleBorder(
            borderRadius: BorderRadius.circular(SizeM.commonBorderRadius.r),
          ),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 18.sp,
            color: Colors.white,
            
          ),
        ),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionColor: Colors.black.withValues(alpha: .1),
      selectionHandleColor: Colors.black,
    ),
  );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
    fontFamily: context.locale.languageCode == 'ar' ? FontsM.IBMPlexSansArabic.name : FontsM.Lexend.name,
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: ColorM.primary,
      // black and whie
      surface: Colors.white,
      // while and black
      onSurface: Colors.black,

      // white and ad degree of black colors in dark mode
      secondary: ColorM.primaryDark,
    ),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextStyles.customTextTheme(Colors.white),
    visualDensity: VisualDensity.comfortable,
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // padding: WidgetStatePropertyAll(EdgeInsets.zero),
        minimumSize: WidgetStatePropertyAll(Size.zero),
        backgroundColor: WidgetStatePropertyAll(ColorM.primary),
        iconColor: WidgetStatePropertyAll(Colors.white),
        iconSize: WidgetStatePropertyAll(12.sp),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size.zero),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.black.withValues(alpha: .5);
          }
          return ColorM.primary;
        }),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        // minimumSize: WidgetStatePropertyAll(Size(double.infinity, 60.w)),
        shape: WidgetStatePropertyAll(
          SmoothRectangleBorder(
            borderRadius: BorderRadius.circular(SizeM.commonBorderRadius.r),
          ),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 18.sp,
            color: Colors.white,
            
          ),
        ),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Colors.white.withValues(alpha: .1),
      selectionHandleColor: Colors.white,
    ),
  );
}

class TextStyles {
  static TextTheme customTextTheme(Color color, [additionalFontSize = 0.0]) =>
      TextTheme(
        labelSmall: TextStyle(
          fontSize: 10.sp,
          color: color,
          fontWeight: FontWeightM.regular,
        ),
        labelMedium: TextStyle(
          fontSize: 12.sp,
          color: color,
          fontWeight: FontWeightM.regular,
        ),
        labelLarge: TextStyle(
          fontSize: 14.sp,
          color: color,
          fontWeight: FontWeightM.regular,
        ),
        bodySmall: TextStyle(
          fontSize: 12.sp,
          color: color,
          fontWeight: FontWeightM.regular,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.sp,
          color: color,
          fontWeight: FontWeightM.regular,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          color: color,
          fontWeight: FontWeightM.regular,
        ),
        titleSmall: TextStyle(
          fontSize: 14.sp,
          color: color,
          fontWeight: FontWeightM.regular,
        ),
        titleMedium: TextStyle(
          fontSize: 16.sp,
          color: color,
          fontWeight: FontWeightM.regular,
        ),
        titleLarge: TextStyle(
          fontSize: 20.sp,
          color: color,
          fontWeight: FontWeightM.regular,
        ),
        headlineSmall: TextStyle(
          fontSize: 18.sp,
          color: color,
          fontWeight: FontWeightM.regular,
          
        ),
        headlineMedium: TextStyle(
          fontSize: 22.sp,
          color: color,
          fontWeight: FontWeightM.regular,
          
        ),
        headlineLarge: TextStyle(
          fontSize: 26.sp,
          color: color,
          fontWeight: FontWeightM.regular,
          
        ),
        displaySmall: TextStyle(
          fontSize: 30.sp,
          color: color,
          fontWeight: FontWeightM.regular,
          
        ),
        displayMedium: TextStyle(
          fontSize: 36.sp,
          color: color,
          fontWeight: FontWeightM.regular,
          
        ),
        displayLarge: TextStyle(
          fontSize: 42.sp,
          color: color,
          fontWeight: FontWeightM.regular,
          
        ),
      );
}
