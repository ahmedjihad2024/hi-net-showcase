import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomizedSmartRefresh extends StatelessWidget {
  final Widget child;
  final RefreshController controller;
  final ScrollController? scrollController;
  final void Function()? onLoading;
  final void Function()? onRefresh;
  final bool enableLoading;
  final bool enableRefresh;
  final EdgeInsetsGeometry? classicFooterPadding;
  final ScrollPhysics? physics;

  const CustomizedSmartRefresh({
    super.key,
    required this.child,
    required this.controller,
    this.scrollController,
    this.onLoading,
    this.onRefresh,
    this.enableLoading = false,
    this.enableRefresh = true,
    this.classicFooterPadding,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      scrollController: scrollController,
      enablePullUp: enableLoading,
      enablePullDown: enableRefresh,
      physics: physics,
      header: ClassicHeader(
        idleIcon: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [ColorM.primary, ColorM.secondary],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.2, .6],
            ).createShader(bounds);
          },
          child: const Icon(Icons.arrow_downward, color: Colors.white),
        ),
        releaseIcon: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [ColorM.primary, ColorM.secondary],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.2, .6],
            ).createShader(bounds);
          },
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
        refreshingIcon: SizedBox(
          width: 25.0,
          height: 50.0.w,
          child: Center(
            child: SizedBox(
              width: 25.0,
              height: 25.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(ColorM.primary),
              ),
            ),
          ),
        ),

        idleText: '',
        refreshingText: '',
        completeText: '',
        failedText: '',
        releaseText: '',
        canTwoLevelText: '',
        textStyle: TextStyle(fontSize: 0, height: 0),
      ),
      footer: ClassicFooter(
        outerBuilder: (child) {
          return Padding(
            padding: classicFooterPadding ?? EdgeInsets.zero,
            child: child,
          );
        },
        textStyle: context.labelSmall.copyWith(
          color: context.colorScheme.surface.withValues(alpha: .5),
          fontWeight: FontWeightM.medium,
        ),
        loadingText: Translation.loading.tr,
        noDataText: Translation.no_more.tr,
        failedText: Translation.failed_loading.tr,
        idleText: Translation.load_more.tr,
        canLoadingText: Translation.load_more.tr,
        spacing: 12.w,
        height: 50 + (classicFooterPadding?.vertical ?? 0),
        loadingIcon: SizedBox(
          width: 15.w,
          height: 15.w,
          child: CircularProgressIndicator(
            color: ColorM.primary,
            valueColor: AlwaysStoppedAnimation<Color>(ColorM.primary),
            backgroundColor: Colors.transparent,
            strokeWidth: 2.2,
            strokeCap: StrokeCap.round,
          ),
        ),
      ),
      onLoading: onLoading,
      onRefresh: onRefresh != null
          ? () {
              HapticFeedback.mediumImpact();
              onRefresh!();
            }
          : null,
      child: child,
    );
  }
}
