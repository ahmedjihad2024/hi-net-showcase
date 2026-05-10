import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/common/ui_components/custom_form_field/simple_form.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/common/utils/custom_text_formatter.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/routes_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/home/bloc/home_bloc.dart';
import 'package:hi_net/presentation/views/home/view/screens/home_view.dart';
import 'package:smooth_corner/smooth_corner.dart';

class PaymentSucessBottomSheet extends StatefulWidget {
  const PaymentSucessBottomSheet({super.key, this.isFromSelectCountry = false});

  final bool isFromSelectCountry;

  @override
  State<PaymentSucessBottomSheet> createState() =>
      _PaymentSucessBottomSheetState();

  static Future<void> show(
    BuildContext context, [
    bool isFromSelectCountry = false,
  ]) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) =>
          PaymentSucessBottomSheet(isFromSelectCountry: isFromSelectCountry),
    );
  }
}

class _PaymentSucessBottomSheetState extends State<PaymentSucessBottomSheet> {
  PageController pageController = PageController(viewportFraction: 0.2);
  PageController pageController2 = PageController(viewportFraction: 0.2);
  ValueNotifier<int> selectedPaymentMethod = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: 20.w,
          left: 16.w,
          right: 16.w,
          bottom: 27.w,
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: ShapeDecoration(
          shape: SmoothRectangleBorder(
            smoothness: 1,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          ),
          color: context.colorScheme.onSurface,
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

            28.verticalSpace,
            SvgPicture.asset(SvgM.successCheck, width: 301.w, height: 140.h),

            16.verticalSpace,
            Text(
              Translation.payment_succesful.tr,
              style: context.headlineSmall.copyWith(
                fontWeight: FontWeightM.medium,
                height: 1,
              ),
            ),
            8.verticalSpace,
            Text(
              Translation.your_purchase_is_complete.tr,
              style: context.bodyMedium.copyWith(
                fontWeight: FontWeightM.light,
                height: 1,
              ),
            ),

            32.verticalSpace,

            nextButton(
              onTap: () {
                Navigator.of(
                  context,
                ).popUntil(ModalRoute.withName(RoutesManager.home.route));
                BOTTOM_NAV_BAR_SELECTED_TAB.value = 2;
                BOTTOM_NAV_BAR_SLIDER_CONTROLLER.animateToPage(
                  2,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastLinearToSlowEaseIn,
                );
                HomeView.homeBloc?.add(GetOrderEvent(true));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget nextButton({required VoidCallback onTap}) {
    return CustomInkButton(
      onTap: onTap,
      gradient: LinearGradient(
        colors: [ColorM.primary, ColorM.secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: SizeM.commonBorderRadius.r,
      height: 48.h,
      alignment: Alignment.center,
      child: Row(
        spacing: 7.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Translation.go_to_my_esim.tr,
            style: context.labelLarge.copyWith(
              fontWeight: FontWeightM.semiBold,
              height: 1,
              color: Colors.white,
            ),
          ),
          RotatedBox(
            quarterTurns: Directionality.of(context) == TextDirection.rtl
                ? 2
                : 0,
            child: SvgPicture.asset(
              SvgM.doubleArrow2,
              width: 12.w,
              height: 12.w,
            ),
          ),
        ],
      ),
    );
  }
}
