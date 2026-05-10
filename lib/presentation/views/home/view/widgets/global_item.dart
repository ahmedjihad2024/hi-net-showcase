import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:intl/intl.dart';
import 'package:money2/money2.dart' as money;

class GlobalItem extends StatefulWidget {
  final int days;
  final double? dataAmount;
  final DataUnit dataUnit;
  final bool isRecommended;
  final double price;
  final Currency currency;
  final int? countryCount;
  final VoidCallback onTap;
  final bool isUnlimited;
  const GlobalItem({
    super.key,
    this.isRecommended = false,
    required this.price,
    required this.currency,
    required this.days,
    this.dataAmount,
    required this.dataUnit,
    this.countryCount,
    required this.onTap,
    this.isUnlimited = false,
  });

  @override
  State<GlobalItem> createState() => _GlobalItemState();
}

class _GlobalItemState extends State<GlobalItem> {
  @override
  Widget build(BuildContext context) {
    return CustomInkButton(
      onTap: widget.onTap,
      width: double.infinity,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: SizeM.pagePadding.dg.w,
        vertical: 12.w,
      ),
      borderRadius: 0,
      child: Row(
        children: [
          SvgPicture.asset(SvgM.earth2, width: 32.w, height: 32.w),
          14.horizontalSpace,
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.w,
            children: [
              Text(
                switch (widget.days) {
                  1 => Translation.one_day.tr,
                  2 => Translation.two_days.tr,
                  _ => Translation.days.trNamed({'days': widget.days.toString()}),
                },
                style: context.labelLarge.copyWith(height: 1.1),
              ),
              Text(
                widget.isUnlimited
                    ? Translation.unlimited.tr
                    : switch (widget.dataUnit) {
                        DataUnit.MB =>
                          '${Translation.mb.trNamed({'mb': widget.dataAmount! % 1 == 0 ? widget.dataAmount!.toInt().toString() : widget.dataAmount.toString()})}',
                        DataUnit.GB =>
                          '${Translation.gb.trNamed({'gb': widget.dataAmount! % 1 == 0 ? widget.dataAmount!.toInt().toString() : widget.dataAmount.toString()})}',
                  DataUnit.TB =>
                    '${Translation.tb.trNamed({'tb': widget.dataAmount! % 1 == 0 ? widget.dataAmount!.toInt().toString() : widget.dataAmount.toString()})}',
                },
                style: context.labelSmall.copyWith(
                  height: 1.1,
                  color: context.colorScheme.surface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          14.horizontalSpace,
          if (widget.isRecommended) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorM.primary, ColorM.secondary],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                spacing: 4.w,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(SvgM.like, width: 10.w, height: 10.w),
                  Text(
                    Translation.recommended.tr,
                    style: context.labelSmall.copyWith(
                      height: 1.1,
                      color: Colors.white,
                      letterSpacing: 0,
                      fontWeight: FontWeightM.light,
                    ),
                  ),
                ],
              ),
            ),
            14.horizontalSpace,
          ],
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 4.w,
            children: [
              Text(
                money.Money.fromNum(
                  widget.price,
                  isoCode: widget.currency.name,
                ).format("#.## S"),
                style: context.labelLarge.copyWith(
                  height: 1.1,
                  color: ColorM.primary,
                ),
              ),
              if (widget.countryCount != null) ...[
                Text(
                  '${Translation.countries_count.trNamed({'countries': widget.countryCount.toString()})}',
                  style: context.labelSmall.copyWith(
                    height: 1.1,
                    color: context.colorScheme.surface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ],
          ),
          14.horizontalSpace,
          Icon(
            Icons.arrow_forward_ios,
            size: 16.w,
            color: context.colorScheme.surface.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
