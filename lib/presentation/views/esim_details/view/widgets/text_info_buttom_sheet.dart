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

class TextInfoBottomSheet extends StatefulWidget {
  const TextInfoBottomSheet({super.key, this.text});

  final String? text;

  @override
  State<TextInfoBottomSheet> createState() => _TextInfoBottomSheetState();

  static Future<void> show(BuildContext context, {required String text}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => TextInfoBottomSheet(text: text),
    );
  }
}

class _TextInfoBottomSheetState extends State<TextInfoBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 20.w,
        bottom:
            (View.of(context).padding.bottom /
                View.of(context).devicePixelRatio) +
            SizeM.pagePadding.dg,
      ),
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
            Translation.fup_policy.tr,
            style: context.titleLarge.copyWith(fontWeight: FontWeightM.medium),
          ),
          16.verticalSpace,
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
              child: Text(
                widget.text!,
                style: context.bodyLarge.copyWith(
                  height: 2,
                  fontWeight: FontWeightM.medium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
