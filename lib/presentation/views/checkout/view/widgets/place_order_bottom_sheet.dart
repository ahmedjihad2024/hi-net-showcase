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
import 'package:hi_net/presentation/views/checkout/view/widgets/payment_success_bottom_sheet.dart';
import 'package:hi_net/presentation/views/home/view/widgets/filter_menu.dart';
import 'package:hi_net/presentation/views/home/view/widgets/select_countr_bottom_sheet.dart';
import 'package:smooth_corner/smooth_corner.dart';

class PlaceOrderBottomSheet extends StatefulWidget {
  const PlaceOrderBottomSheet({super.key, this.isFromSelectCountry = false});

  final bool isFromSelectCountry;

  @override
  State<PlaceOrderBottomSheet> createState() => _PlaceOrderBottomSheetState();

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
          PlaceOrderBottomSheet(isFromSelectCountry: isFromSelectCountry),
    );
  }
}

class _PlaceOrderBottomSheetState extends State<PlaceOrderBottomSheet> {
  PageController pageController = PageController(viewportFraction: 0.2);
  PageController pageController2 = PageController(viewportFraction: 0.2);
  ValueNotifier<int> selectedPaymentMethod = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 20.w,
        left: 16.w,
        right: 16.w,
        bottom: 27.w,
      ),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
          ValueListenableBuilder(
            valueListenable: selectedPaymentMethod,
            builder: (context, value, child) {
              return SmoothClipRRect(
                smoothness: 1,
                borderRadius: BorderRadius.circular(14.r),
                child: FilterPopupMenu<int>(
                  onFilterSelected: (value) {
                    selectedPaymentMethod.value = value;
                  },
                  borderRadius: 5.r,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedPaymentMethod.value == 0
                            ? "Debit Card"
                            : "Credit Card",
                        style: context.bodyLarge.copyWith(
                          fontWeight: FontWeightM.regular,
                          height: 1.2,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20.w,
                        color: context.labelMedium.color!.withValues(alpha: .8),
                      ),
                    ],
                  ),
                  backgroundColor: context.isDark
                      ? ColorM.primaryDark
                      : Color(0xFFFAFAFA),
                  options: [
                    FilterOption(value: 0, label: "Debit Card"),
                    FilterOption(value: 1, label: "Credit Card"),
                  ],
                ),
              );
            },
          ),

          16.verticalSpace,

          SimpleForm(
            height: 52.w,
            hintText: "0000 0000 0000 0000",
            keyboardType: TextInputType.number,
            controller: TextEditingController(),
            focusNode: FocusNode(),
            label2: Text(
              Translation.card_number.tr,
              style: context.labelLarge.copyWith(
                color: context.colorScheme.surface.withValues(alpha: .5),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CreditCardNumberFormatter(),
            ],
          ),

          16.verticalSpace,

          Row(
            spacing: 14.w,
            children: [
              Expanded(
                child: SimpleForm(
                  height: 52.w,
                  hintText: "MM/YY",
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  label2: Text(
                    Translation.expiration.tr,
                    style: context.labelLarge.copyWith(
                      color: context.colorScheme.surface.withValues(alpha: .5),
                    ),
                  ),
                  inputFormatters: [ExpiryDateFormatter()],
                ),
              ),
              Expanded(
                child: SimpleForm(
                  height: 52.w,
                  hintText: "CVV",
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  label2: Text(
                    Translation.cvv.tr,
                    style: context.labelLarge.copyWith(
                      color: context.colorScheme.surface.withValues(alpha: .5),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                ),
              ),
            ],
          ),

          16.verticalSpace,

          nextButton(
            onTap: () {
              Navigator.of(context).pop();
              PaymentSucessBottomSheet.show(context);
            },
          ),
        ],
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
            Translation.place_order_.tr,
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
