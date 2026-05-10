import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/presentation/common/ui_components/custom_cached_image.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:money2/money2.dart' as money;

class RegionalItem extends StatefulWidget {
  final String imageUrl;
  final String countryName;
  final int planCount;
  final bool isRecommended;
  final double price;
  final Currency currency;
  final void Function() onTap;
  const RegionalItem({
    super.key,
    required this.imageUrl,
    required this.countryName,
    required this.planCount,
    required this.isRecommended,
    required this.price,
    required this.currency,
    required this.onTap,
  });

  @override
  State<RegionalItem> createState() => _RegionalItemState();
}

class _RegionalItemState extends State<RegionalItem> {
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
        spacing: 14.w,
        children: [
          SvgPicture.asset(SvgM.earth, width: 32.w, height: 32.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.w,
            children: [
              Text(
                widget.countryName,
                style: context.labelLarge.copyWith(height: 1.1),
              ),
              Text(
                Translation.plan_count_format.trNamed({
                  'price': money.Money.fromNum(widget.price, isoCode:  widget.currency.name).format('#.## S'),
                }),
                style: context.labelSmall.copyWith(
                  height: 1.1,
                  color: context.colorScheme.surface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const Spacer(),
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

class RegionalItem2 extends StatefulWidget {
  final String countryName;
  final bool circleIcon;
  final List<CoveredCountry> supportedCountries;
  final void Function() onTap;
  const RegionalItem2({
    super.key,
    required this.countryName,
    required this.onTap,
    this.circleIcon = false,
    required this.supportedCountries,
  });

  @override
  State<RegionalItem2> createState() => _RegionalItem2State();
}

class _RegionalItem2State extends State<RegionalItem2> {
  List<CoveredCountry> _supportedCountries = [];
  @override
  void initState() {
    super.initState();
    _supportedCountries = widget.supportedCountries.sublist(
      0,
      widget.supportedCountries.length > 8
          ? 8
          : widget.supportedCountries.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomInkButton(
      onTap: widget.onTap,
      width: double.infinity,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: SizeM.pagePadding.dg,
        vertical: 12.w,
      ),
      borderRadius: 0,
      child: Row(
        spacing: 14.w,
        children: [
          SvgPicture.asset(SvgM.earth, width: 24.w, height: 24.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.w,
              children: [
                Text(
                  widget.countryName,
                  style: context.labelLarge.copyWith(height: 1.1),
                ),
                Row(
                  spacing: 10.w,
                  children: [
                    SizedBox(
                      height: 12.w,
                      width: ((_supportedCountries.length - 1) * 8.w) + 12.w,
                      child: Stack(
                        children: List.generate(_supportedCountries.length, (
                          index,
                        ) {
                          return PositionedDirectional(
                            start: index * 8.w,
                            child: DecoratedBox(
                              position: DecorationPosition.foreground,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: context.colorScheme.surface.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 1.w,
                                ),
                              ),
                              child: CustomCachedImage(
                                imageUrl: _supportedCountries[index].flag,
                                width: 12.w,
                                height: 12.w,
                                isCircle: true,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    Text(
                      Translation.country_count.trNamed({
                        'count': (widget.supportedCountries.length).toString(),
                      }),
                      style: context.labelSmall.copyWith(
                        height: 1.1,
                        color: context.colorScheme.surface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
