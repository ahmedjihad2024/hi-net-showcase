import 'package:hi_net/app/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/presentation/common/ui_components/animations/animations_enum.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../../../../res/color_manager.dart';
import '../../../../res/fonts_manager.dart';

class BottomNavItem {
  final String title;
  final String svgPath;
  final String selectedSvgPath;
  BottomNavItem({
    required this.title,
    required this.svgPath,
    required this.selectedSvgPath,
  });
}

class BottomNavBar extends StatefulWidget {
  final ValueNotifier<int> selectedTap;
  final double bottomNavHeight;
  final double bottomNavWidth;
  final double bottomNavMargin;
  final double bottomNavPadding;
  final double bottomItemWidth;
  final List<BottomNavItem> bottomNavItems;
  final double spaceBetweenItems;
  final Function(int) onTap;
  const BottomNavBar({
    super.key,
    required this.selectedTap,
    required this.bottomNavHeight,
    required this.bottomNavWidth,
    required this.bottomNavMargin,
    required this.bottomNavPadding,
    required this.bottomItemWidth,
    required this.bottomNavItems,
    required this.onTap,
    required this.spaceBetweenItems,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.selectedTap,
      builder: (context, value, child) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height:
                widget.bottomNavHeight +
                (View.of(context).viewPadding.bottom /
                    View.of(context).devicePixelRatio),
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.colorScheme.onSurface,
              border: Border(
                top: BorderSide(
                  color: context.colorScheme.surface.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              bottom: true,
              left: false,
              right: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // buttons
                  for (int i = 0; i < widget.bottomNavItems.length; i++)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          widget.onTap(i);
                        },
                        child: ShaderMask(
                          blendMode: BlendMode.srcATop,
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              stops: [0.2, .6],
                              colors: value == i
                                  ? [ColorM.primary, ColorM.secondary]
                                  : [
                                      Colors.black.withValues(alpha: 0.55),
                                      Colors.black.withValues(alpha: 0.55),
                                    ],
                            ).createShader(bounds);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            spacing: 2.w,
                            children: [
                              // icon
                              SvgPicture.asset(
                                value == i
                                    ? widget.bottomNavItems[i].selectedSvgPath
                                    : widget.bottomNavItems[i].svgPath,
                                width: 19.w,
                                height: 19.w,
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),

                              // lable
                              Align(
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  widget.bottomNavItems[i].title,
                                  maxLines: 2,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: context.bodySmall.copyWith(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animatedOnAppear(2 + (i + 1), SlideDirection.up),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
