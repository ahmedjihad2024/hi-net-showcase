import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/common/ui_components/custom_cached_image.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:smooth_corner/smooth_corner.dart';

class EsimCard extends StatefulWidget {
  final String imageUrl;
  final String countryName;
  final String? label;
  final VoidCallback onTap;

  const EsimCard({
    super.key,
    required this.imageUrl,
    required this.countryName,
    this.label,
    required this.onTap,
  });

  @override
  State<EsimCard> createState() => _EsimCardState();
}

class _EsimCardState extends State<EsimCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: 124.w,
        height: 138.h,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            CustomCachedImage(
              imageUrl: widget.imageUrl,
              width: 124.w,
              height: 138.h,
              borderRadius: BorderRadius.circular(12.r),
            ),
            Container(
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Color(0xFF020610).withOpacity(0.6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.5, 1],
                  tileMode: TileMode.clamp,
                ),
                shape: SmoothRectangleBorder(
                  smoothness: 1,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
      
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 2.w,
                  children: [
                    Text(
                      widget.countryName,
                      textAlign: TextAlign.center,
                      style: context.bodyLarge.copyWith(
                        fontWeight: FontWeightM.extraBold,
                        height: 1.2,
                        color: Colors.white,
                      ),
                    ),
                    if (widget.label != null)
                      Text(
                        widget.label!,
                        textAlign: TextAlign.center,
                        style: context.labelSmall.copyWith(
                          fontWeight: FontWeightM.light,
                          height: 1.2,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
