import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/plan_item.dart';
import 'package:hi_net/presentation/views/home/view/widgets/half_circle_progress.dart';

class UseageProgress extends StatelessWidget {
  final DataUnit dataUnit;
  final double dataAmount;
  final double dataRemainingMB;
  final double usagePercentage;
  final double size;
  final bool enableDarkLight;
  final double leftTextSize;
  final double amountTextSize;
  final double strokeWidth;
  final bool isUnlimited;
  const UseageProgress({
    super.key,
    required this.dataUnit,
    required this.dataAmount,
    required this.dataRemainingMB,
    required this.usagePercentage,
    required this.size,
    required this.leftTextSize,
    required this.amountTextSize,
    this.enableDarkLight = false,
    this.strokeWidth = 11,
    this.isUnlimited = false,
  });

  String _formatValue(double valueMB) {
    final converted = switch (dataUnit) {
      DataUnit.MB => (Decimal.parse(valueMB.toString())).toDouble(),
      DataUnit.GB =>
        (Decimal.parse(valueMB.toString()) / Decimal.parse('1024')).toDouble(),
      DataUnit.TB =>
        (Decimal.parse(
              (Decimal.parse(valueMB.toString()) / Decimal.parse('1024'))
                  .toString(),
            ) /
            Decimal.parse('1024'))
        .toDouble(),
    };
    return converted % 1 == 0
        ? converted.toInt().toString()
        : converted.toStringAsFixed(1);
  }

  String get _unitLabel => switch (dataUnit) {
    DataUnit.MB => Translation.mb.trNamed({'mb': ''}).trim(),
    DataUnit.GB => Translation.gb.trNamed({'gb': ''}).trim(),
    DataUnit.TB => Translation.tb.trNamed({'tb': ''}).trim(),
  };

  @override
  Widget build(BuildContext context) {
    if (isUnlimited) {
      return HalfCircleProgress(
        key: key,
        delay: Duration(milliseconds: 500),
        size: size,
        progress: 1.0,
        strokeWidth: strokeWidth,
        progressGradient: enableDarkLight
            ? LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.2, .6],
                colors: [ColorM.primary, ColorM.secondary],
              )
            : null,
        progressColor: enableDarkLight ? null : Colors.white,
        backgroundColor: enableDarkLight
            ? ColorM.primary.withValues(alpha: 0.17)
            : Colors.white.withValues(alpha: 0.2),
        animationDuration: Duration(milliseconds: 600),
        child: SizedBox(
          width: size * 0.59,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              Translation.unlimited.tr,
              style: TextStyle(
                fontSize: leftTextSize,
                fontWeight: FontWeightM.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),
        ).mask(!enableDarkLight),
      );
    }

    final double totalMB = switch (dataUnit) {
      DataUnit.MB => dataAmount,
      DataUnit.GB => dataAmount * 1024,
      DataUnit.TB => dataAmount * 1024 * 1024,
    };
    final double usedMB = (totalMB - dataRemainingMB).clamp(0, totalMB);
    final String usedStr = _formatValue(usedMB);
    final String totalStr = dataAmount % 1 == 0
        ? dataAmount.toInt().toString()
        : dataAmount.toStringAsFixed(1);

    return HalfCircleProgress(
      key: key,
      delay: Duration(milliseconds: 500),
      size: size,
      progress: usagePercentage / 100,
      strokeWidth: strokeWidth,
      progressGradient: enableDarkLight
          ? LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.2, .6],
              colors: [ColorM.primary, ColorM.secondary],
            )
          : null,
      progressColor: enableDarkLight ? null : Colors.white,
      backgroundColor: enableDarkLight
          ? ColorM.primary.withValues(alpha: 0.17)
          : Colors.white.withValues(alpha: 0.2),
      animationDuration: Duration(milliseconds: 600),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size * 0.65,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Translation.used.tr,
                        style: TextStyle(
                          fontSize: amountTextSize,
                          color: enableDarkLight ? null : Colors.white,
                          fontWeight: FontWeightM.regular,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 2.w),
                      Text(
                        usedStr,
                        style: TextStyle(
                          fontSize: leftTextSize,
                          fontWeight: FontWeightM.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      '/',
                      style: TextStyle(
                        fontSize: leftTextSize,
                        fontWeight: FontWeightM.bold,
                        color: (enableDarkLight ? null : Colors.white)
                            ?? Colors.grey,
                        height: 1.2,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Translation.total.tr,
                        style: TextStyle(
                          fontSize: amountTextSize,
                          color: enableDarkLight ? null : Colors.white,
                          fontWeight: FontWeightM.regular,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 2.w),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            totalStr,
                            style: TextStyle(
                              fontSize: leftTextSize,
                              fontWeight: FontWeightM.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            _unitLabel,
                            style: TextStyle(
                              fontSize: amountTextSize,
                              fontWeight: FontWeightM.medium,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).mask(!enableDarkLight),
        ],
      ),
    );
  }
}
