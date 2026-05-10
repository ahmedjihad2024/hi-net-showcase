import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/common/ui_components/gradient_border_side.dart'
    as gradient_border_side;
import 'package:money2/money2.dart' as money;

class PlanItem extends StatefulWidget {
  final int days;
  final double price;
  final double? dataAmount;
  final DataUnit dataUnit;
  final Currency currency;
  final bool isSelected;
  final void Function(bool value) onChange;
  final bool isRecommended;
  final bool isUnlimited;
  const PlanItem({
    super.key,
    required this.days,
    required this.price,
    this.dataAmount,
    required this.dataUnit,
    required this.currency,
    this.isSelected = false,
    required this.onChange,
    this.isRecommended = false,
    this.isUnlimited = false,
  });

  @override
  State<PlanItem> createState() => _PlanItemState();
}

class _PlanItemState extends State<PlanItem> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  void _onChange(bool value) {
    setState(() {
      isSelected = value;
    });
  }

  @override
  void didUpdateWidget(PlanItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (mounted) {
      _onChange(widget.isSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomInkButton(
      onTap: () {
        var newValue = !isSelected;
        // if (newValue != widget.isSelected && widget.isSelected == false) {
        _onChange(newValue);
        widget.onChange(newValue);
        // }
      },
      width: 100.w,
      height: 125.w,
      maxWidth: 150.w,
      padding: EdgeInsets.all(14.w),
      borderRadius: 14.r,
      side: isSelected
          ? gradient_border_side.BorderSide.none
          : gradient_border_side.BorderSide(
              color: context.colorScheme.surface.withValues(alpha: .1),
            ),
      gradient: LinearGradient(
        colors: isSelected
            ? [ColorM.primary, ColorM.secondary]
            : [
                context.theme.scaffoldBackgroundColor,
                context.theme.scaffoldBackgroundColor,
              ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 6.w,
            children: [
              // GB/Data - Large and on top
              Text(
                widget.isUnlimited
                    ? Translation.unlimited.tr
                    : switch (widget.dataUnit) {
                        DataUnit.MB =>
                          Translation.mb.trNamed({
                            'mb': widget.dataAmount! % 1 == 0 
                                ? widget.dataAmount!.toInt().toString() 
                                : widget.dataAmount.toString()
                          }),
                        DataUnit.GB =>
                          Translation.gb.trNamed({
                            'gb': widget.dataAmount! % 1 == 0 
                                ? widget.dataAmount!.toInt().toString() 
                                : widget.dataAmount.toString()
                          }),
                        DataUnit.TB =>
                          Translation.tb.trNamed({
                            'tb': widget.dataAmount! % 1 == 0 
                                ? widget.dataAmount!.toInt().toString() 
                                : widget.dataAmount.toString()
                          }),
                      },
                style: context.bodyLarge.copyWith(
                  height: 1.1,
                  fontSize: 18.sp,
                  fontWeight: FontWeightM.semiBold,
                  color: isSelected
                      ? Colors.white
                      : context.colorScheme.surface,
                ),
              ),
              // Days - Bigger and clearer
              Text(
                switch (widget.days) {
                  1 => Translation.one_day.tr,
                  2 => Translation.two_days.tr,
                  >= 3 && <= 10 => Translation.days_plural.trNamed({
                    'days': widget.days.toString(),
                  }),
                  _ => Translation.days.trNamed({
                    'days': widget.days.toString(),
                  }),
                },
                style: context.labelMedium.copyWith(
                  height: 1.1,
                  fontWeight: FontWeightM.medium,
                  color: isSelected
                      ? Colors.white.withValues(alpha: .9)
                      : context.colorScheme.surface.withValues(alpha: .7),
                ),
              ),
            ],
          ),

          Text(
            money.Money.fromNum(
              widget.price,
              isoCode: widget.currency.name,
            ).format("#.## S"),
            style: context.bodyLarge.copyWith(
              height: 1.1,
              fontSize: 16.sp,
              fontWeight: FontWeightM.semiBold,
              color: isSelected ? Colors.white : context.colorScheme.surface,
            ),
          ),
        ],
      ),
    );
  }
}
