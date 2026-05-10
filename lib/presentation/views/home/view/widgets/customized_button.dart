import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';

class CustomizedButton extends StatelessWidget {
  final void Function() onPressed;
  final int count;
  final String svgImage;
  final double? size;

  const CustomizedButton({
    super.key,
    required this.onPressed,
    this.count = 0,
    required this.svgImage,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onPressed,
          style: IconButton.styleFrom(
            fixedSize: Size(40.w, 40.w),
            backgroundColor: context.colorScheme.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(99999),
            ),
          ),
          tooltip: Translation.show_hide_notification_usage.tr,
          icon: SvgPicture.asset(
            svgImage,
            width: size ?? 18.w,
            height: size ?? 18.w,
            colorFilter: ColorFilter.mode(
              context.colorScheme.surface,
              BlendMode.srcIn,
            ),
          ),
        ),
        if (count != 0)
          PositionedDirectional(
            start: -2,
            top: -4,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [ColorM.primary, ColorM.secondary],
                ),
                borderRadius: BorderRadius.circular(99999),         
              ),
              alignment: Alignment.center,
              child: Text(
                count > 99 ? '99+' : '$count',
                style: TextStyle(
                  fontSize: 8.sp,
                  color: Colors.white,
                  fontWeight: FontWeightM.semiBold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
