import 'dart:io';

import 'package:animated_visibility/animated_visibility.dart';
import 'package:easy_localization/easy_localization.dart' as e;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/common/ui_components/animations/animations_enum.dart';
import 'package:hi_net/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:hi_net/presentation/common/ui_components/custom_cached_image.dart';
import 'package:hi_net/presentation/common/ui_components/custom_form_field/simple_form.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/common/ui_components/default_app_bar.dart';
import 'package:hi_net/presentation/common/ui_components/error_widget.dart';
import 'package:hi_net/presentation/common/ui_components/gradient_border_side.dart'
    as gradient_border_side;
import 'package:hi_net/presentation/common/utils/after_layout.dart';
import 'package:hi_net/presentation/common/utils/state_render.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/checkout/bloc/checkout_bloc.dart';
import 'package:hi_net/presentation/views/checkout/view/widgets/choose_another_plan_bottom_sheet.dart';
import 'package:hi_net/presentation/views/checkout/view/widgets/payment_method_item.dart';
import 'package:hi_net/presentation/views/checkout/view/widgets/payment_success_bottom_sheet.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/plan_item.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:money2/money2.dart' as money;

import '../../../../../app/services/app_rate_services.dart';

class CheckoutView extends StatefulWidget {
  final String packageId;
  final EsimsType type;
  final String? countryCode;
  final String? regionCode;
  final String? renewalOrderId;
  const CheckoutView({
    super.key,
    required this.packageId,
    required this.type,
    this.countryCode,
    this.regionCode,
    this.renewalOrderId,
  });

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> with AfterLayout {
  ValueNotifier<PaymentMethod> paymentMethod = ValueNotifier<PaymentMethod>(
    Platform.isAndroid ? PaymentMethod.card : PaymentMethod.applePay,
  );
  TextEditingController promoCodeController = TextEditingController();
  ValueNotifier<bool> checkTermsAndConditions = ValueNotifier<bool>(false);
  ValueNotifier<bool> isButtonEnabled = ValueNotifier<bool>(false);

  CheckoutState get state => context.read<CheckoutBloc>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          49.verticalSpace,
          DefaultAppBar(
            actionButtons: [
              Expanded(
                child: Row(
                  spacing: 14.w,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(Translation.checkout.tr, style: context.bodyLarge),
                  ],
                ),
              ),
              SizedBox(width: 40.w),
            ],
          ).animatedOnAppear(5, SlideDirection.down),
          BlocBuilder<CheckoutBloc, CheckoutState>(
            builder: (context, state) {
              return ScreenState.setState(
                reqState: state.reqState,
                loading: () {
                  return Expanded(
                    child: const Center(
                      child: MyCircularProgressIndicator(),
                    ).animatedOnAppear(0, SlideDirection.up),
                  );
                },
                error: () {
                  return Expanded(
                    child: MyErrorWidget(
                      errorType: state.errorType,
                      onRetry: () {
                        context.read<CheckoutBloc>().add(
                          GetCheckoutDetailsEvent(
                            packageId: widget.packageId,
                            locale: context.locale,
                          ),
                        );
                      },
                      titleMessage: state.errorMessage,
                    ).animatedOnAppear(0, SlideDirection.up),
                  );
                },
                online: () {
                  return Expanded(
                    child: Column(
                      children: [
                        26.verticalSpace,
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeM.pagePadding.dg,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                plan(
                                  imageUrl: state.imageUrl,
                                  days: state.days,
                                  dataUnit: state.dataUnit!,
                                  dataAmount: state.dataAmount,
                                  title: state.countryName,
                                  type: widget.type,
                                  isUnlimited: state.isUnlimited,
                                ).animatedOnAppear(4, SlideDirection.down),
                                8.verticalSpace,
                                if (!widget.type.isGlobal ||
                                    !widget.type.isRenewal) ...[
                                  switchPlan().animatedOnAppear(
                                    3,
                                    SlideDirection.down,
                                  ),
                                  18.verticalSpace,
                                ],
                                discountFromWallet().animatedOnAppear(
                                  2,
                                  SlideDirection.down,
                                ),
                                18.verticalSpace,
                                Text(
                                  Translation.payment_method.tr,
                                  style: context.bodyMedium,
                                ).animatedOnAppear(1, SlideDirection.down),
                                18.verticalSpace,
                                if (state.showPaymentMethods) ...[
                                  paymentMethods().animatedOnAppear(
                                    0,
                                    SlideDirection.down,
                                  ),
                                  18.verticalSpace,
                                ],
                                promoCode().animatedOnAppear(
                                  0,
                                  SlideDirection.up,
                                ),
                                18.verticalSpace,
                                paymentSummary().animatedOnAppear(
                                  1,
                                  SlideDirection.up,
                                ),
                              ],
                            ),
                          ),
                        ),
                        14.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeM.pagePadding.dg,
                          ),
                          child: ValueListenableBuilder(
                            valueListenable: isButtonEnabled,
                            builder: (context, isEnabled, child) {
                              return CustomInkButton(
                                onTap: () async {
                                  context.read<CheckoutBloc>().add(
                                    CreateInvoiceEvent(
                                      isDark: context.isDark,
                                      locale: context.locale,
                                      packageId: state.id,
                                      paymentMethod: paymentMethod.value,
                                      useWallet: state.isUsingWallet,
                                      renewalOrderId: widget.renewalOrderId,
                                      promoCode: state.isPromoCodeActive
                                          ? state.promoCode
                                          : null,
                                      onSuccess: () async {
                                        if (mounted) {
                                          PaymentSucessBottomSheet.show(
                                            context,
                                          );
                                          AppRateServices.instance
                                              .showRateDialog(context: context);
                                        }
                                      },
                                    ),
                                  );
                                },
                                gradient: LinearGradient(
                                  colors: [ColorM.primary, ColorM.secondary],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.dg,
                                ),
                                borderRadius: SizeM.commonBorderRadius.r,
                                height: 54.h,
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 7.w,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          Translation.pay_now.tr,
                                          style: context.labelLarge.copyWith(
                                            fontWeight: FontWeightM.semiBold,
                                            height: 1,
                                            color: Colors.white,
                                          ),
                                        ),
                                        RotatedBox(
                                          quarterTurns:
                                              Directionality.of(context) ==
                                                  TextDirection.rtl
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

                                    Row(
                                      spacing: 12.w,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 1.w,
                                          height: 20.w,
                                          color: Colors.white.withValues(
                                            alpha: .5,
                                          ),
                                        ),
                                        Text(
                                          money.Money.fromNum(
                                            state.finalPrice,
                                            isoCode: state.currency,
                                          ).format("#.## S"),
                                          style: context.bodyLarge.copyWith(
                                            height: 1.1,
                                            fontWeight: FontWeightM.medium,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ).animatedOnAppear(0, SlideDirection.up),
                        12.verticalSpace,
                        checkBoxs().animatedOnAppear(1, SlideDirection.up),

                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 10.h,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget plan({
    required String imageUrl,
    required int days,
    double? dataAmount,
    required DataUnit dataUnit,
    required String title,
    EsimsType type = EsimsType.country,
    bool isUnlimited = false,
  }) {
    return CustomInkButton(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      borderRadius: 14.r,
      side: gradient_border_side.BorderSide(
        color: context.colorScheme.surface.withValues(alpha: .1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 12.w,
            children: [
              switch (type) {
                EsimsType.country || EsimsType.renewal => CustomCachedImage(
                  imageUrl: imageUrl,
                  width: 28.w,
                  height: 28.w,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                EsimsType.regional => SvgPicture.asset(
                  SvgM.earth,
                  width: 28.w,
                  height: 28.w,
                ),
                EsimsType.global => SvgPicture.asset(
                  SvgM.earth2,
                  width: 28.w,
                  height: 28.w,
                ),
              },
              Text(title, style: context.bodyLarge.copyWith(height: 1.1)),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            spacing: 8.w,
            children: [
              Text(
                Translation.days.trNamed({'days': days.toString()}),
                style: context.bodyLarge.copyWith(
                  height: 1.1,
                  fontWeight: FontWeightM.medium,
                  color: context.colorScheme.surface,
                ),
              ),
              Row(
                children: [
                  Text(
                    isUnlimited
                        ? Translation.unlimited.tr
                        : switch (dataUnit) {
                            DataUnit.MB =>
                              '${Translation.mb.trNamed({'mb': dataAmount! % 1 == 0 ? dataAmount.toInt().toString() : dataAmount.toString()})}',
                            DataUnit.GB =>
                              '${Translation.gb.trNamed({'gb': dataAmount! % 1 == 0 ? dataAmount.toInt().toString() : dataAmount.toString()})}',
                            DataUnit.TB =>
                              '${Translation.tb.trNamed({'tb': dataAmount! % 1 == 0 ? dataAmount.toInt().toString() : dataAmount.toString()})}',
                          },
                    style: context.labelMedium.copyWith(
                      height: 1.1,
                      color: context.colorScheme.surface.withValues(alpha: .7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget switchPlan() {
    return CustomInkButton(
      onTap: () {
        ChooseAnotherPlanBottomSheet.show(
          context,
          widget.type,
          widget.regionCode,
          widget.countryCode,
        );
      },
      padding: EdgeInsets.symmetric(vertical: 10.w),
      borderRadius: 8.r,
      backgroundColor: context.isDark ? ColorM.primaryDark : Color(0xFFF8F8F8),
      child: Row(
        spacing: 12.w,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Translation.choose_another_plan.tr, style: context.bodyMedium),
          SvgPicture.asset(
            SvgM.arrowSwapHorizontal,
            width: 16.w,
            height: 16.h,
            colorFilter: ColorFilter.mode(
              context.colorScheme.surface.withValues(alpha: .7),
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentMethods() {
    return ValueListenableBuilder(
      valueListenable: paymentMethod,
      builder: (context, value, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 13.w,
            children: [
              PaymentMethodItem(
                image: ImagesM.card,
                isSelected: value.isCard,
                isBlackAndWhite: true,
                onChange: (value) {
                  paymentMethod.value = PaymentMethod.card;
                },
              ),
              if (Platform.isIOS)
                PaymentMethodItem(
                  image: ImagesM.applePay,
                  isSelected: value.isApplePay,
                  isBlackAndWhite: true,
                  onChange: (value) {
                    paymentMethod.value = PaymentMethod.applePay;
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget promoCode() {
    return AnimatedVisibility(
      visible: !state.isUsingWallet,
      enter:
          fadeIn(curve: Curves.fastEaseInToSlowEaseOut) +
          expandVertically(curve: Curves.fastEaseInToSlowEaseOut),
      exit:
          fadeOut(curve: Curves.fastEaseInToSlowEaseOut) +
          shrinkVertically(curve: Curves.fastEaseInToSlowEaseOut),
      enterDuration: Duration(milliseconds: 300),
      exitDuration: Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Translation.promo_code.tr, style: context.bodySmall),
          10.verticalSpace,
          Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: SimpleForm(
                  height: 52.w,
                  hintText: Translation.enter_code.tr,
                  keyboardType: TextInputType.text,
                  controller: promoCodeController,
                ),
              ),
              CustomInkButton(
                onTap: () {
                  if (promoCodeController.text.trim().isNotEmpty &&
                      !state.isPromoCodeActive) {
                    context.read<CheckoutBloc>().add(
                      ApplyPromoCodeEvent(
                        promoCode: promoCodeController.text,
                        packageId: state.id,
                      ),
                    );
                  } else {
                    context.read<CheckoutBloc>().add(RemovePromoCodeEvent());
                  }
                },
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                gradient: LinearGradient(
                  colors: [ColorM.primary, ColorM.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: SizeM.commonBorderRadius.r,
                height: 52.w,
                alignment: Alignment.center,
                child: Text(
                  state.isPromoCodeActive
                      ? Translation.cancel.tr
                      : Translation.apply.tr,
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeightM.semiBold,
                    height: 1,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget paymentSummary() {
    return SmoothContainer(
      width: double.infinity,
      smoothness: 1,
      borderRadius: BorderRadius.circular(12.r),
      padding: EdgeInsets.all(10.w),
      color: context.isDark ? ColorM.primaryDark : Color(0xFFFAFAFA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 6.w,
        children: [
          Text(
            Translation.payment_summary.tr,
            style: context.bodySmall.copyWith(
              fontWeight: FontWeightM.light,
              color: context.colorScheme.surface.withValues(alpha: .7),
            ),
          ),
          PaymentSummaryItem(
            title: Translation.subtotal.tr,
            value: money.Money.fromNum(
              state.amount,
              isoCode: state.currency,
            ).format("#.## S"),
            gredientText: false,
          ),
          PaymentSummaryItem(
            title: Translation.taxs.tr,
            value: money.Money.fromNum(
              state.vat,
              isoCode: state.currency,
            ).format("#.## S"),
            gredientText: false,
          ),

          if (state.isUsingWallet)
            PaymentSummaryItem(
              title: Translation.deduction_from_wallet.tr,
              value: money.Money.fromNum(
                state.walletDiscountAmount,
                isoCode: state.currency,
              ).format("#.## S"),
              isRed: true,
            ),

          if (state.isPromoCodeActive)
            PaymentSummaryItem(
              title: Translation.promo_discount_ammount.tr,
              value: money.Money.fromNum(
                state.promoCodeDiscountAmount,
                isoCode: state.currency,
              ).format("#.## S"),
              isRed: true,
            ),
          PaymentSummaryItem(
            title: Translation.total.tr,
            value: money.Money.fromNum(
              state.finalPrice,
              isoCode: state.currency,
            ).format("#.## S"),
            gredientText: true,
          ),
        ],
      ),
    );
  }

  Widget checkBoxs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: Column(
        spacing: 12.w,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckBoxItem(
            key: Key('v1'),
            titlePartOne:
                Translation.by_completing_the_order_you_agree_to_our.tr,
            titlePartTwo: Translation.terms_and_conditions.tr,
            value: checkTermsAndConditions,
            onChange: (value) {
              checkTermsAndConditions.value = value;
              isButtonEnabled.value = checkTermsAndConditions.value;
            },
          ),
          // CheckBoxItem(
          //   key: Key('v2'),
          //   titlePartOne: Translation.my_device_supports_esim.tr,
          //   titlePartTwo: Translation.check_device_compatibility.tr,
          //   underlinePartTwo: true,
          //   value: devicesSupportEsim,
          //   onTapPartTwo: () {
          //     // todo: nav to page
          //   },
          //   onChange: (value) {
          //     devicesSupportEsim.value = value;
          //     isButtonEnabled.value =
          //         checkTermsAndConditions.value && devicesSupportEsim.value;
          //   },
          // ),
        ],
      ),
    );
  }

  Widget discountFromWallet() {
    return state.walletBalanceReqState.isLoading
        ? Shimmer.fromColors(
            baseColor: context.colorScheme.surface.withValues(alpha: .1),
            highlightColor: context.colorScheme.onSurface.withValues(alpha: .1),
            child: SmoothContainer(
              borderRadius: BorderRadius.circular(12.r),
              width: double.infinity,
              height: 50.w,
              color: context.colorScheme.surface,
            ),
          )
        : SmoothContainer(
            padding: EdgeInsets.all(14.w),
            borderRadius: BorderRadius.circular(12.r),
            color: context.isDark ? ColorM.primaryDark : Color(0xFFF8F8F8),
            child: Row(
              spacing: 8.w,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  textScaler: TextScaler.linear(
                    View.of(context).platformDispatcher.textScaleFactor,
                  ),
                  TextSpan(
                    style: context.bodySmall.copyWith(
                      fontWeight: FontWeightM.regular,
                    ),
                    children: [
                      TextSpan(text: Translation.save.tr),
                      TextSpan(text: " "),
                      TextSpan(
                        text: money.Money.fromNum(
                          state.walletDiscountAmount,
                          isoCode: state.currency,
                        ).format("#.## S"),
                        style: TextStyle(
                          fontWeight: FontWeightM.medium,
                          color: ColorM.primary,
                        ),
                      ),
                      TextSpan(text: " "),
                      TextSpan(text: Translation.from_your_wallet.tr),
                    ],
                  ),
                ),

                // apple switch
                Container(
                  width: 40.w,
                  height: 20.w,
                  alignment: Alignment.center,
                  child: CupertinoSwitch(
                    value: state.isUsingWallet,
                    onChanged: (value) {
                      if (state.isWalletAllowed) {
                        context.read<CheckoutBloc>().add(ToggleWalletEvent());
                      }
                    },
                  ),
                ),
              ],
            ),
          );
  }

  @override
  Future<void> afterLayout(BuildContext context) async {
    context.read<CheckoutBloc>().add(
      GetCheckoutDetailsEvent(
        packageId: widget.packageId,
        locale: context.locale,
      ),
    );
  }
}

class PaymentSummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final bool gredientText;
  final bool isRed;
  const PaymentSummaryItem({
    super.key,
    required this.title,
    required this.value,
    this.gredientText = false,
    this.isRed = false,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.bodySmall.copyWith(
            height: 1.5,
            fontWeight: FontWeightM.medium,
            color: gredientText
                ? Colors.white
                : isRed
                ? Color(0xFFFB5C67)
                : context.colorScheme.surface.withValues(alpha: .7),
          ),
        ).mask(!gredientText),
        Text(
          value,
          style: context.bodySmall.copyWith(
            fontWeight: FontWeightM.medium,
            color: gredientText
                ? Colors.white
                : isRed
                ? Color(0xFFFB5C67)
                : context.colorScheme.surface,
          ),
        ).mask(!gredientText),
      ],
    );
  }
}

class CheckBoxItem extends StatelessWidget {
  final String titlePartOne;
  final String titlePartTwo;
  final ValueNotifier<bool> value;
  final VoidCallback? onTapPartTwo;
  final bool underlinePartTwo;
  final void Function(bool value) onChange;
  const CheckBoxItem({
    super.key,
    required this.titlePartOne,
    required this.titlePartTwo,
    required this.value,
    required this.onChange,
    this.onTapPartTwo,
    this.underlinePartTwo = false,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: value,
      builder: (context, valueValue, child) {
        return Row(
          spacing: 8.w,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CustomCheckBox(
            //   value: valueValue,
            //   onChange: onChange,
            //   width: 17.w,
            //   height: 17.w,
            //   borderRadius: 4.r,
            //   checkSize: 11.w,
            // ),
            Flexible(
              child: RichText(
                textScaler: TextScaler.linear(
                  View.of(context).platformDispatcher.textScaleFactor,
                ),
                text: TextSpan(
                  style: context.bodySmall.copyWith(
                    color: context.colorScheme.surface.withValues(alpha: .7),
                  ),
                  children: [
                    TextSpan(text: titlePartOne),
                    TextSpan(text: " "),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      baseline: TextBaseline.alphabetic,
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [Color(0xFF007AFF), ColorM.secondary],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds);
                        },
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: onTapPartTwo ?? () {},
                          child: Text(
                            titlePartTwo,
                            style: context.bodySmall.copyWith(
                              color: Colors.white,
                              decoration: underlinePartTwo
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
