import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/common/utils/after_layout.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:smooth_corner/smooth_corner.dart';

enum SelectDurationType {
  days,
  weeks;

  bool get isDays => this == SelectDurationType.days;
  bool get isWeeks => this == SelectDurationType.weeks;
}

class SelectDurationBottomSheet extends StatefulWidget {
  final Future<void> Function(BuildContext context)? showCountryBottomSheet;
  final void Function(int? days, SelectDurationType? type) onClickNextTimeSheet;
  const SelectDurationBottomSheet({
    super.key,
    this.isFromSelectCountry = false,
    this.isFromSearch = false,
    required this.showCountryBottomSheet,
    required this.onClickNextTimeSheet,
    this.selectedDays = 0,
    this.selectedType = SelectDurationType.days,
  });

  final bool isFromSelectCountry;
  final bool isFromSearch;
  final int selectedDays;
  final SelectDurationType selectedType;

  @override
  State<SelectDurationBottomSheet> createState() =>
      _SelectDurationBottomSheetState();

  static Future<void> show(
    BuildContext context, {
    bool isFromSelectCountry = false,
    bool isFromSearch = false,
    Future<void> Function(BuildContext context)? showCountryBottomSheet,
    required void Function(int? days, SelectDurationType? type)
    onClickNextTimeSheet,
    int selectedDays = 0,
    SelectDurationType selectedType = SelectDurationType.days,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => SelectDurationBottomSheet(
        isFromSelectCountry: isFromSelectCountry,
        isFromSearch: isFromSearch,
        selectedDays: selectedDays,
        showCountryBottomSheet: showCountryBottomSheet,
        onClickNextTimeSheet: onClickNextTimeSheet,
        selectedType: selectedType,
      ),
    );
  }
}

class _SelectDurationBottomSheetState extends State<SelectDurationBottomSheet>
    with AfterLayout {
  PageController pageController = PageController(viewportFraction: 0.2);
  PageController pageController2 = PageController(viewportFraction: 0.2);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .5.sh,
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 20.w,
        left: 16.w,
        right: 16.w,
        bottom: 27.w,
      ),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
          smoothness: 1,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        color: context.colorScheme.onSurface,
      ),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 5.w,
            decoration: BoxDecoration(
              color: context.colorScheme.surface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(100000),
            ),
          ),
          16.verticalSpace,
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.only(
                top: 12.w,
                bottom: 8.w,
                left: 12.w,
                right: 12.w,
              ),
              decoration: ShapeDecoration(
                shape: SmoothRectangleBorder(
                  smoothness: 1,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                color: context.isDark
                    ? ColorM.primaryDark
                    : context.colorScheme.surface.withValues(alpha: 0.05),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      CustomInkButton(
                        onTap: () {
                          Navigator.of(context).pop();
                          if (widget.isFromSelectCountry) {
                            widget.showCountryBottomSheet?.call(context);
                          }
                        },
                        padding: EdgeInsets.zero,
                        width: 40.w,
                        height: 40.w,
                        backgroundColor: Colors.transparent,
                        borderRadius: SizeM.commonBorderRadius.r,
                        alignment: Alignment.center,
                        child: RotatedBox(
                          quarterTurns:
                              Directionality.of(context) == TextDirection.rtl
                              ? 2
                              : 0,
                          child: SvgPicture.asset(
                            SvgM.arrowLeft,
                            width: 14.w,
                            height: 14.w,
                            colorFilter: ColorFilter.mode(
                              context.colorScheme.surface,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        Translation.select_duration.tr,
                        style: context.titleMedium,
                      ),
                    ],
                  ),
                  24.verticalSpace,
                  durationsList(),
                  13.verticalSpace,
                  nextButton(
                    onTap: () {
                      // so it select all times
                      if ((pageController.page?.toInt() ?? 0) == 0) {
                        widget.onClickNextTimeSheet(null, null);
                      } else {
                        widget.onClickNextTimeSheet(
                          (pageController.page?.toInt() ?? 0),
                          (pageController2.page?.toInt() ?? 0) == 0
                              ? SelectDurationType.days
                              : SelectDurationType.weeks,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget durationsList() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // left side
          SizedBox(
            width: 150.w,
            child: ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white,
                    Colors.transparent,
                  ],
                  stops: [0, .5, 1],
                  tileMode: TileMode.clamp,
                ).createShader(rect);
              },
              child: PageView(
                controller: pageController,
                scrollDirection: Axis.vertical,
                children: [
                  Row(
                    children: [
                      AnimatedBuilder(
                        animation: pageController,
                        builder: (context, child) {
                          // is in viewportFraction
                          bool isInViewport =
                              ((pageController.page ??
                                      pageController.initialPage.toDouble() -
                                          0) -
                                  0) ==
                              0;
                          return Text(
                            Translation.all_duration.tr,
                            style: context.headlineSmall.copyWith(
                              fontWeight: FontWeightM.regular,
                              height: 1,
                              color: isInViewport
                                  ? ColorM.primary
                                  : context.colorScheme.surface.withValues(
                                      alpha: 0.5,
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  for (var i = 1; i < 100; i++)
                    Row(
                      children: [
                        AnimatedBuilder(
                          animation: pageController,
                          builder: (context, child) {
                            // is in viewportFraction
                            bool isInViewport =
                                ((pageController.page ??
                                        pageController.initialPage.toDouble() -
                                            i) -
                                    i) ==
                                0;
                            return Text(
                              '$i',
                              style: context.headlineSmall.copyWith(
                                fontWeight: FontWeightM.regular,
                                height: 1,
                                color: isInViewport
                                    ? ColorM.primary
                                    : context.colorScheme.surface.withValues(
                                        alpha: 0.5,
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // right side
          SizedBox(
            width: 65.w,
            child: ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white,
                    Colors.transparent,
                  ],
                  stops: [0, .5, 1],
                  tileMode: TileMode.clamp,
                ).createShader(rect);
              },
              child: PageView(
                controller: pageController2,
                scrollDirection: Axis.vertical,
                children: [
                  for (var i = 0; i < 2; i++)
                    Row(
                      children: [
                        AnimatedBuilder(
                          animation: pageController2,
                          builder: (context, child) {
                            // is in viewportFraction
                            bool isInViewport =
                                ((pageController2.page ??
                                        pageController2.initialPage.toDouble() -
                                            i) -
                                    i) ==
                                0;
                            return ShaderMask(
                              shaderCallback: (rect) {
                                return LinearGradient(
                                  tileMode: TileMode.clamp,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: isInViewport
                                      ? [ColorM.primary, ColorM.secondary]
                                      : [
                                          context.colorScheme.surface
                                              .withValues(alpha: 0.5),
                                          context.colorScheme.surface
                                              .withValues(alpha: 0.5),
                                        ],
                                ).createShader(rect);
                              },
                              child: Text(
                                i == 0
                                    ? Translation.days_.tr
                                    : Translation.weeks.tr,
                                style: context.headlineSmall.copyWith(
                                  fontWeight: FontWeightM.regular,
                                  height: 1.3,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nextButton({required VoidCallback onTap}) {
    return CustomInkButton(
      onTap: onTap,
      gradient: LinearGradient(
        colors: [ColorM.primary, ColorM.secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: SizeM.commonBorderRadius.r,
      height: 48.h,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 7.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Translation.search.tr.replaceAll('..', ''),
            style: context.labelLarge.copyWith(
              fontWeight: FontWeightM.semiBold,
              height: 1,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> afterLayout(BuildContext context) async {
    pageController.animateToPage(
      widget.selectedDays,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    pageController2.animateToPage(
      widget.selectedType == SelectDurationType.days ? 0 : 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastEaseInToSlowEaseOut,
    );
  }
}
