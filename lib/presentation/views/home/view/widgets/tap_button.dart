import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/common/ui_components/gradient_border_side.dart' as s;
import 'package:hi_net/presentation/res/color_manager.dart';

class TapButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  const TapButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkButton(
      onTap: onTap,
      backgroundColor: isSelected
          ? (context.isDark ? Colors.white : ColorM.primaryDark)
          : context.colorScheme.secondary,
      smoothness: 1,
      borderRadius: 12.r,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.w),
      side: s.BorderSide(
        color: context.colorScheme.surface.withValues(alpha: .3),
        width: 1.w,
      ),
      child: Text(
        title,
        style: context.labelMedium.copyWith(
          color: isSelected
              ? context.colorScheme.onSurface
              : context.colorScheme.surface,
        ),
      ),
    );
  }
}
