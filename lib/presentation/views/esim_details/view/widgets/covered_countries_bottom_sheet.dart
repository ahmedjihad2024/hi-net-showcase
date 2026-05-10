import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/presentation/common/ui_components/custom_cached_image.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:smooth_corner/smooth_corner.dart';

class CoveredCountriesBottomSheet extends StatefulWidget {
  const CoveredCountriesBottomSheet({super.key, this.coveredCountries});

  final List<CoveredCountry>? coveredCountries;

  @override
  State<CoveredCountriesBottomSheet> createState() =>
      _CoveredCountriesBottomSheetState();

  static Future<void> show(
    BuildContext context, {
    required List<CoveredCountry> coveredCountries,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) =>
          CoveredCountriesBottomSheet(coveredCountries: coveredCountries),
    );
  }
}

class _CoveredCountriesBottomSheetState
    extends State<CoveredCountriesBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 20.w),
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
          smoothness: 1,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        color: context.colorScheme.secondary,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.w,
            height: 5.w,
            decoration: BoxDecoration(
              color: context.colorScheme.surface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(100000),
            ),
          ),

          12.verticalSpace,

          Text(
            Translation.supported_countries.tr,
            style: context.titleLarge.copyWith(fontWeight: FontWeightM.medium),
          ),
          16.verticalSpace,
          Flexible(
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg) +
                  EdgeInsets.only(
                    bottom:
                        (View.of(context).padding.bottom /
                            View.of(context).devicePixelRatio) +
                        SizeM.pagePadding.dg,
                  ),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.w,
                      children: [
                        for (var element in widget.coveredCountries!)
                          SmoothContainer(
                            smoothness: 1,
                            borderRadius: BorderRadius.circular(14.r),
                            padding: EdgeInsets.symmetric(
                              vertical: 10.w,
                              horizontal: 16.w,
                            ),
                            side: BorderSide(
                              color: context.colorScheme.surface.withValues(
                                alpha: 0.1,
                              ),
                              width: 1.w,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 8.w,
                              children: [
                                CustomCachedImage(
                                  imageUrl: element.flag,
                                  width: 24.w,
                                  height: 24.w,
                                  isCircle: true,
                                ),
                                Text(
                                  element.name(context.locale),
                                  style: context.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
