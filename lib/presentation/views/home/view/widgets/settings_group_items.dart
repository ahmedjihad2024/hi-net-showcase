import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/plan_item.dart';
import 'package:smooth_corner/smooth_corner.dart';

class SettingsGroupItems extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const SettingsGroupItems({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.labelMedium.copyWith(
            color: context.colorScheme.surface.withValues(alpha: .6),
            fontWeight: FontWeightM.light,
          ),
        ),
        SizedBox(height: 8.w),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
              smoothness: 1,
              borderRadius: BorderRadius.circular(10.r),
              side: BorderSide(
                color: context.colorScheme.surface.withValues(alpha: .03),
                width: 1.w,
              ),
            ),
            color: context.colorScheme.secondary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < items.length; i++) ...[
                items[i],
                if (i != items.length - 1)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Divider(
                      color: context.colorScheme.surface.withValues(alpha: .1),
                      height: 1.w,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class SettingItem extends StatelessWidget {
  final String title;
  final String? lable;
  final String svg;
  final VoidCallback? onTap;
  final Widget? suffix;
  final double? verticalPadding;
  final bool gradientTitleAndSvg;
  const SettingItem({
    super.key,
    required this.title,
    required this.svg,
    this.onTap,
    this.suffix,
    this.verticalPadding = 16,
    this.lable,
    this.gradientTitleAndSvg = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkButton(
      onTap: onTap,
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding ?? 16.w,
        horizontal: 24.w,
      ),
      backgroundColor: Colors.transparent,
      borderRadius: 0,
      child: Row(
        spacing: 12.w,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: 12.w,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: SvgPicture.asset(
                  svg,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                    gradientTitleAndSvg ? Colors.white : context.colorScheme.surface.withValues(alpha: .8),
                    BlendMode.srcIn,
                  ),
                ),
              ).mask(!gradientTitleAndSvg),
              Text(
                title,
                style: context.labelLarge.copyWith(
                  color: gradientTitleAndSvg ? Colors.white : context.labelLarge.color!.withValues(alpha: .8),
                ),
              ).mask(!gradientTitleAndSvg),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 5.w,
            children: [
              if (lable != null)
                Text(
                  lable!,
                  style: context.labelMedium.copyWith(
                    color: context.labelMedium.color!.withValues(alpha: .5),
                  ),
                ),
              suffix ??
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 13.w,
                    color: context.colorScheme.surface.withValues(alpha: .5),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
