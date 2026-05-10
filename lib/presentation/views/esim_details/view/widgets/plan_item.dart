import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final DataUnit dataUnit;
  final Currency currency;
  final double? dataAmount;
  final bool isSelected;
  final void Function(bool value) onChange;
  final bool isRecommended;
  final bool showDays;
  final bool isUnlimited;
  final String? badge;
  const PlanItem({
    super.key,
    required this.days,
    required this.price,
    required this.dataUnit,
    required this.currency,
    required this.onChange,
    this.isRecommended = false,
    this.dataAmount,
    this.isSelected = false,
    this.showDays = true,
    this.isUnlimited = false,
    this.badge,
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
        if (newValue != widget.isSelected && widget.isSelected == false) {
          _onChange(newValue);
          widget.onChange(newValue);
        } else {
          widget.onChange(newValue);
        }
      },
      width: double.infinity,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 8.w,
            children: [
              if (widget.showDays)
                Text(
                  switch (widget.days) {
                    1 => Translation.one_day.tr,
                    2 => Translation.two_days.tr,
                    _ => Translation.days.trNamed({'days': widget.days.toString()}),
                  },
                  style: context.bodyLarge.copyWith(
                    height: 1.1,
                    fontWeight: FontWeightM.medium,
                    color: isSelected
                        ? Colors.white
                        : context.colorScheme.surface,
                  ),
                ),
              Row(
                children: [
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
                    style: context.bodyLarge.copyWith(
                      height: 1.1,
                      fontWeight: FontWeightM.medium,
                      color: isSelected
                          ? Colors.white
                          : context.colorScheme.surface,
                    ),
                  ),
                  if (widget.badge != null) ...[
                    12.horizontalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 3.w,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isSelected
                              ? [Colors.white.withValues(alpha: .2), Colors.white.withValues(alpha: .2)]
                              : [ColorM.primary, ColorM.secondary],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        widget.badge!,
                        style: context.labelSmall.copyWith(
                          height: 1.1,
                          color: Colors.white,
                          letterSpacing: 0,
                          fontWeight: FontWeightM.medium,
                        ),
                      ),
                    ),
                  ],
                  if (widget.isRecommended) ...[
                    12.horizontalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 3.w,
                      ),
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
                          SvgPicture.asset(
                            SvgM.like,
                            width: 10.w,
                            height: 10.w,
                          ),
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
                  ],
                ],
              ),
            ],
          ),

          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 12.w,
              children: [
                Flexible(
                  child: FittedBox(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      money.Money.fromNum(
                        widget.price,
                        isoCode: widget.currency.name,
                      ).format("#.## S"),
                      style: context.bodyLarge.copyWith(
                        fontWeight: FontWeightM.medium,
                        color: Colors.white,
                      ),
                    ),
                  ).mask(isSelected),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension maskOnText on Widget {
  Widget mask(bool doIt) {
    return doIt
        ? this
        : ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [ColorM.primary, ColorM.secondary],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds);
            },
            child: this,
          );
  }
}
