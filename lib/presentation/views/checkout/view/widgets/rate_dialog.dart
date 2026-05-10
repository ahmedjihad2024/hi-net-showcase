import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/app/services/app_rate_services.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/common/ui_components/rate_widget.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:smooth_corner/smooth_corner.dart';

class RateDialog extends StatefulWidget {
  const RateDialog({super.key});

  @override
  State<RateDialog> createState() => _RateDialogState();

  static Future<bool?> show(BuildContext context) async {
    return await showDialog<bool?>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return const RateDialog();
      },
    );
  }
}

class _RateDialogState extends State<RateDialog> {
  double currentRate = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SmoothContainer(
        padding: EdgeInsets.all(16.dg),
        color: context.colorScheme.onSurface,
        smoothness: 1,
        borderRadius: BorderRadius.circular(20.r),
        width: 320.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const IconSection(),
            16.verticalSpace,
            Text(
              Translation.do_you_enjoy.tr,
              textAlign: TextAlign.center,
              style: context.bodyLarge.copyWith(
                fontWeight: FontWeightM.bold,
                fontSize: 18.sp,
              ),
            ),
            4.verticalSpace,
            Text(
              Platform.isAndroid
                  ? Translation.press_to_rate_on_google_play.tr
                  : Translation.press_to_rate_on_app_store.tr,
              textAlign: TextAlign.center,
              style: context.bodySmall.copyWith(
                color: context.colorScheme.surface.withValues(alpha: .7),
                fontWeight: FontWeightM.medium,
              ),
            ),
            20.verticalSpace,
            RateWidget(
              size: 34.sp,
              spacing: 8.w,
              activeColor: ColorM.primary,
              inactiveColor: context.colorScheme.surface.withValues(alpha: .1),
              onRateChange: (value) async {
                setState(() {
                  currentRate = value;
                });

                Future.delayed(const Duration(milliseconds: 300), () async {
                  if (mounted) {
                    Navigator.pop(context, true);
                  }
                });
              },
            ),
            20.verticalSpace,
            CustomInkButton(
              onTap: () {
                Navigator.pop(context, false);
              },
              width: double.infinity,
              height: 48.h,
              borderRadius: 999999,
              backgroundColor: context.colorScheme.surface.withValues(
                alpha: .06,
              ),
              child: Center(
                child: Text(
                  Translation.not_now.tr,
                  style: context.bodyLarge.copyWith(
                    fontWeight: FontWeightM.semiBold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconSection extends StatelessWidget {
  const IconSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
          smoothness: 1,
          borderRadius: BorderRadius.circular(14.r),
        ),
        gradient: LinearGradient(colors: [ColorM.primary, ColorM.secondary]),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .15),
            offset: const Offset(0, 0),
            blurRadius: 10,
          ),
        ],
      ),
      child: Image.asset(ImagesM.logoIcon, height: 60.w, width: 60.w),
    );
  }
}
