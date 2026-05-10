import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';

class DefaultAppBar extends StatelessWidget {
  const DefaultAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.backFunction,
    this.actionButtons,
    this.customBackButton,
    this.hideBackButton = false,
    this.titleAlignment = Alignment.center,
    this.titleTextAlign = TextAlign.center,
    this.padding,
    this.forceWhiteArrow = false,
  });

  final String? title;
  final Widget? titleWidget;
  final VoidCallback? backFunction;
  final List<Widget>? actionButtons;
  final Widget? customBackButton;
  final bool hideBackButton;
  final AlignmentGeometry titleAlignment;
  final TextAlign titleTextAlign;
  final EdgeInsetsGeometry? padding;
  final bool forceWhiteArrow;


  EdgeInsetsGeometry get _defaultPadding =>
      EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg);

  Widget? _buildLeading(BuildContext context) {
    if (hideBackButton) return null;
    if (customBackButton != null) return customBackButton;

    // Determine arrow color based on background
    bool useWhiteArrow = forceWhiteArrow;
    Color arrowColor = useWhiteArrow ? Colors.white : context.colorScheme.surface;
    Color backgroundColor = useWhiteArrow 
        ? Colors.white.withValues(alpha: 0.25)
        : context.colorScheme.surface.withValues(alpha: context.isLight ? 0.06 : 0.15);

    return CustomInkButton(
      onTap: backFunction ?? () => Navigator.of(context).maybePop(),
      padding: EdgeInsets.zero,
      width: 40.w,
      height: 40.w,
      backgroundColor: backgroundColor,
      borderRadius: SizeM.commonBorderRadius.r,
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeM.commonBorderRadius.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: useWhiteArrow ? 0.3 : 0.1),
              blurRadius: useWhiteArrow ? 10 : 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: RotatedBox(
          quarterTurns: Directionality.of(context) == TextDirection.rtl ? 2 : 0,
          child: SvgPicture.asset(
            SvgM.arrowLeft, 
            width: 14.w, 
            height: 14.w, 
            colorFilter: ColorFilter.mode(
              arrowColor, 
              BlendMode.srcIn
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildTitle(BuildContext context) {
    if (titleWidget == null && (title == null || title!.isEmpty)) {
      return SizedBox.shrink();
    }

    final Widget? resolvedTitle =
        titleWidget ??
        (title == null ? null : Text(
          title!,
          textAlign: titleTextAlign,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.bodyLarge.copyWith(
            height: 1,
            fontWeight: FontWeightM.semiBold,
          ),
        ));

    return resolvedTitle != null ? Align(alignment: titleAlignment, child: resolvedTitle) : null;
  }

  @override
  Widget build(BuildContext context) {
    final leading = _buildLeading(context);
    final title = _buildTitle(context);
    final actions = actionButtons ?? const [];

    return Padding(
      padding: padding ?? _defaultPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 40.w, child: leading),
      
          if(title != null) title,
      
          Expanded(
            child: SizedBox(
              child: actions.isEmpty
                  ? null
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions
                          .map(
                            (action) => action,
                          )
                          .toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
