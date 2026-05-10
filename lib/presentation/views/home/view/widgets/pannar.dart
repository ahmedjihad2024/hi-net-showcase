import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/common/ui_components/custom_cached_image.dart';
import 'package:hi_net/presentation/common/ui_components/notch_container.dart';
import 'package:hi_net/presentation/common/utils/state_render.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/views/home/bloc/home_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_corner/smooth_corner.dart';

class Pannar extends StatefulWidget {
  const Pannar({super.key});

  @override
  State<Pannar> createState() => _PannarState();
}

class _PannarState extends State<Pannar> {
  final ValueNotifier<int> currentIndex = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    HomeState state = context.read<HomeBloc>().state;
    return ScreenState.setState(
      reqState: state.homeSlidersReqState,
      loading: () {
        return Shimmer.fromColors(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
            height: 100.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              color: context.colorScheme.surface,
            ),
          ),
          baseColor: context.colorScheme.surface.withValues(alpha: .1),
          highlightColor: context.colorScheme.onSurface.withValues(alpha: .1),
        );
      },
      online: () {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // ValueListenableBuilder(
            //   valueListenable: currentIndex,
            //   builder: (context, value, __) {
            //     return Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       spacing: 4.w,
            //       children: [
            //         for (int i = 0; i < state.homeSliders!.length; i++)
            //           AnimatedContainer(
            //             duration: Duration(milliseconds: 500),
            //             curve: Curves.fastLinearToSlowEaseIn,
            //             padding: EdgeInsets.all(i == value ? 1.w : 0),
            //             decoration: BoxDecoration(
            //               shape: BoxShape.circle,
            //               border: i == value
            //                   ? Border.all(color: ColorM.primary, width: 1.w)
            //                   : null,
            //             ),
            //             child: AnimatedContainer(
            //               duration: Duration(milliseconds: 500),
            //               curve: Curves.fastLinearToSlowEaseIn,
            //               width: 5.w,
            //               height: 5.w,
            //               decoration: BoxDecoration(
            //                 shape: BoxShape.circle,
            //                 color: i == value
            //                     ? ColorM.primary
            //                     : ColorM.primary.withValues(alpha: .5),
            //               ),
            //             ),
            //           ),
            //       ],
            //     );
            //   },
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
              child: NotchContainer( 
                // enable: state.homeSliders!.length > 1,
                enable: false,
                notchWidth: state.homeSliders!.length * 20.w,
                notchHeight: 12.h,
                notchRadius: 10.r,
                child: SmoothClipRRect(
                  smoothness: 1,
                  borderRadius: BorderRadius.circular(14.r),
                  child: CarouselSlider(
                    items: [
                      for (int i = 0; i < state.homeSliders!.length; i++)
                        CustomCachedImage(
                          imageUrl: state.homeSliders![i].image,
                          width: double.infinity,
                        ),
                    ],
                    options: CarouselOptions(
                      viewportFraction: 1,
                      aspectRatio: 1,
                      height: 100.w,
                      enableInfiniteScroll: state.homeSliders!.length > 1
                          ? true
                          : false,
                      padEnds: false,
                      animateToClosest: false,
                      autoPlay: state.homeSliders!.length > 1 ? true : false,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                      onPageChanged: (index, reason) {
                        currentIndex.value = index;
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
