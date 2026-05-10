import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:smooth_corner/smooth_corner.dart';

class NetworksBottomSheet extends StatefulWidget {
  const NetworksBottomSheet({super.key, this.networks});

  final List<NetworkDto>? networks;

  @override
  State<NetworksBottomSheet> createState() => _NetworksBottomSheetState();

  static Future<void> show(
    BuildContext context, {
    required List<NetworkDto> networks,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => NetworksBottomSheet(networks: networks),
    );
  }
}

class _NetworksBottomSheetState extends State<NetworksBottomSheet> {
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
            Translation.networks.tr,
            style: context.titleLarge.copyWith(fontWeight: FontWeightM.medium),
          ),
          16.verticalSpace,
          Directionality(
            textDirection: TextDirection.ltr,
            child: Flexible(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg) +
                    EdgeInsets.only(
                      bottom:
                          (View.of(context).padding.bottom /
                              View.of(context).devicePixelRatio) +
                          SizeM.pagePadding.dg,
                    ),
                child: Column(
                  spacing: 8.w,
                  children: [
                    for (var element in widget.networks!)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${element.operator} ${element.type}',
                              style: context.bodyMedium,
                            ),
                              
                            Text(element.nameEn, style: context.bodyMedium),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
