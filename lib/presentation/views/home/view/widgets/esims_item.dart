import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/common/ui_components/custom_cached_image.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/common/utils/fast_function.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/esim_details/view/screens/esim_details_view.dart';
import 'package:hi_net/presentation/views/home/view/widgets/half_circle_progress.dart';
import 'package:hi_net/presentation/common/ui_components/gradient_border_side.dart'
    as gradient_border_side;
import 'package:hi_net/presentation/views/home/view/widgets/useage_progress.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:money2/money2.dart' as money;

class EsimsItem extends StatelessWidget {
  final EsimStatus esimStatus;
  final Function() onSeeDetails;
  final Function() onRenew;
  final Function() onActivationWay;
  final double? dataAmount;
  final DataUnit? dataUnit;
  final int days;
  final String iccid;
  final String countryName;
  final String countryFlag;
  final double? price;
  final Currency? currency;
  final double? usagePercentage;
  final double? dataRemainingMB;
  final bool canRenew;
  final bool isUnlimited;
  const EsimsItem({
    super.key,
    required this.esimStatus,
    required this.onSeeDetails,
    required this.onRenew,
    required this.onActivationWay,
    this.dataAmount,
    this.dataUnit,
    required this.days,
    required this.iccid,
    required this.countryName,
    required this.countryFlag,
    this.isUnlimited = false,
    this.price,
    this.currency,
    this.usagePercentage,
    this.dataRemainingMB,
    required this.canRenew,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: ShapeDecoration(
        color: context.colorScheme.secondary,
        shape: SmoothRectangleBorder(
          smoothness: 1,
          borderRadius: BorderRadius.circular(14.r),
          side: BorderSide(
            color: context.isDark ? Color(0xFF171717) : Color(0xFFF0F0F0),
            width: 1.w,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 18.w,
        children: [
          // first row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  spacing: 12.w,
                  children: [
                    CustomCachedImage(
                      imageUrl: countryFlag,
                      width: 28.w,
                      height: 28.w,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    Flexible(
                      child: Text(
                        countryName,
                        style: context.bodyLarge.copyWith(),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 9.w),
                decoration: BoxDecoration(
                  color: esimStatus.color(context).withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4.w,
                  children: [
                    SvgPicture.asset(
                      esimStatus.isActive ? SvgM.activeCircle : SvgM.danger,
                      width: 12.w,
                      height: 12.w,
                      colorFilter: ColorFilter.mode(
                        esimStatus.color(context),
                        BlendMode.srcIn,
                      ),
                    ),
                    Text(
                      esimStatus.tr,
                      style: context.labelMedium.copyWith(
                        fontWeight: FontWeightM.light,
                        color: esimStatus.color(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // second row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UseageProgress(
                  key: key,
                  leftTextSize: 22.sp,
                  amountTextSize: 11.sp,
                  dataAmount: dataAmount ?? 0,
                  dataRemainingMB: dataRemainingMB ?? 0,
                  usagePercentage: usagePercentage ?? 100,
                  dataUnit: dataUnit ?? DataUnit.GB,
                  size: 164.w,
                  enableDarkLight: true,
                  strokeWidth: 15,
                  isUnlimited: isUnlimited,
                ),
            ],
          ),

          // third row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PlansInfoItem(
                title: Translation.cost.tr,
                value: price != null && currency != null
                    ? money.Money.fromNum(
                        price!,
                        isoCode: currency!.name,
                      ).format('#.## S')
                    : '-',
                flex: 1,
              ),

              Container(
                width: 1.w,
                height: 25.w,
                color: context.colorScheme.surface.withValues(alpha: .5),
              ),

              PlansInfoItem(
                title: Translation.iccid.tr,
                value: iccid,
                singleLine: true,
                flex: 2,
              ),

              Container(
                width: 1.w,
                height: 25.w,
                color: context.colorScheme.surface.withValues(alpha: .5),
              ),

              PlansInfoItem(
                title: Translation.duration.tr,
                value: switch (days) {
                  1 => Translation.one_day.tr,
                  2 => Translation.two_days.tr,
                  _ => Translation.days.trNamed({'days': days.toString()}),
                },
                flex: 1,
              ),
            ],
          ),

          // fourth row
          Row(
            spacing: 12.w,
            children: [
              // see esim details button
              Expanded(
                child: CustomInkButton(
                  onTap: onSeeDetails,
                  borderRadius: SizeM.commonBorderRadius.r,
                  height: 42.h,
                  alignment: Alignment.center,
                  backgroundColor: context.isDark ? Colors.black : ColorM.gray,
                  child: Row(
                    spacing: 7.w,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [ColorM.primary, ColorM.secondary],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds);
                        },
                        child: Text(
                          Translation.see_details.tr,
                          style: context.labelLarge.copyWith(
                            fontWeight: FontWeightM.regular,
                            height: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SvgPicture.asset(SvgM.arrowUp, width: 16.w, height: 16.w),
                    ],
                  ),
                ),
              ),

              // review and activation way button
              if (esimStatus.isActive || esimStatus.isReady || canRenew)
                Expanded(
                  child: CustomInkButton(
                    onTap: () {
                      if (esimStatus.isActive || canRenew) {
                        onRenew();
                      } else {
                        onActivationWay();
                      }
                    },
                    borderRadius: SizeM.commonBorderRadius.r,
                    height: 42.h,
                    alignment: Alignment.center,
                    side: gradient_border_side.BorderSide(
                      gradient: LinearGradient(
                        colors: [ColorM.primary, ColorM.secondary],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Row(
                      spacing: 7.w,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [ColorM.primary, ColorM.secondary],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds);
                          },
                          child: Text(
                            esimStatus.isActive || canRenew
                                ? Translation.renew.tr
                                : Translation.activation_way.tr,
                            style: context.labelLarge.copyWith(
                              fontWeight: FontWeightM.regular,
                              height: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        RotatedBox(
                          quarterTurns:
                              Directionality.of(context) == TextDirection.rtl
                              ? 2
                              : 0,
                          child: SvgPicture.asset(
                            SvgM.doubleArrow3,
                            width: 12.w,
                            height: 12.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
