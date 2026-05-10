import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart' as e;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/common/ui_components/animations/animations_enum.dart';
import 'package:hi_net/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:hi_net/presentation/common/ui_components/custom_cached_image.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/common/ui_components/default_app_bar.dart';
import 'package:hi_net/presentation/common/ui_components/error_widget.dart';
import 'package:hi_net/presentation/common/utils/after_layout.dart';
import 'package:hi_net/presentation/common/utils/fast_function.dart';
import 'package:hi_net/presentation/common/utils/state_render.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/routes_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/networks_bottom_sheet.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/plain_information_bottom_sheet.dart';
import 'package:hi_net/presentation/views/home/view/widgets/half_circle_progress.dart';
import 'package:hi_net/presentation/views/home/view/widgets/useage_progress.dart';
import 'package:hi_net/presentation/views/my_esim_details/bloc/my_esim_details_bloc.dart';
import 'package:hi_net/presentation/views/my_esim_details/view/widgets/plan_item.dart';
import 'package:smooth_corner/smooth_corner.dart';

class MyEsimDetailsView extends StatefulWidget {
  final String orderId;
  final bool canRenew;
  const MyEsimDetailsView({
    super.key,
    required this.orderId,
    required this.canRenew,
  });

  @override
  State<MyEsimDetailsView> createState() => _MyEsimDetailsViewState();
}

class _MyEsimDetailsViewState extends State<MyEsimDetailsView>
    with AfterLayout {
  ValueNotifier<int> selectedPlanIndex = ValueNotifier(-1);
  MyEsimDetailsState get state => context.read<MyEsimDetailsBloc>().state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDark ? ColorM.primaryDark : Color(0xFFF8F8F8),
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
                    Text(Translation.esim_details.tr, style: context.bodyLarge),
                  ],
                ),
              ),
            ],
          ).animatedOnAppear(5, SlideDirection.down),
          BlocBuilder<MyEsimDetailsBloc, MyEsimDetailsState>(
            builder: (context, state) {
              return Expanded(
                child: ScreenState.setState(
                  reqState: state.reqState,
                  loading: () {
                    return MyCircularProgressIndicator();
                  },
                  error: () {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeM.pagePadding.dg,
                      ),
                      child: MyErrorWidget(
                        errorType: state.errorType,
                        onRetry: () {
                          context.read<MyEsimDetailsBloc>().add(
                            GetMyEsimDetailsEvent(
                              orderId: widget.orderId,
                              canRenew: widget.canRenew,
                            ),
                          );
                        },
                        titleMessage: state.errorMessage ?? "",
                      ),
                    );
                  },
                  online: () {
                    return Column(
                      children: [
                        24.verticalSpace,
                        usage().animatedOnAppear(4, SlideDirection.down),
                        24.verticalSpace,
                        esimInfo(),
                        24.verticalSpace,
                        Expanded(
                          child: Container(
                            color: context.colorScheme.onSurface,
                            child: Column(
                              children: [
                                if (state.order!.status.isReady)
                                  viewInstructionsButton(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        RoutesManager.instructions.route,
                                        arguments: {
                                          "smdp-address": state
                                              .order!
                                              .esimCards
                                              .first
                                              .smdpAddress,
                                          "activation-code": state
                                              .order!
                                              .esimCards
                                              .first
                                              .activationCode,
                                          "qr-code": state
                                              .order!
                                              .esimCards
                                              .first
                                              .qrCode,
                                          "ios-install-link": state
                                              .order!
                                              .esimCards
                                              .first
                                              .iosInstallLink,
                                        },
                                      );
                                    },
                                  ).animatedOnAppear(1, SlideDirection.up),
                                Container(
                                  height: 1.w,
                                  color: context.colorScheme.surface.withValues(
                                    alpha: 0.1,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: SizeM.pagePadding.dg,
                                  ),
                                ).animatedOnAppear(2, SlideDirection.up),
                                10.verticalSpace,
                                currentProvider().animatedOnAppear(
                                  3,
                                  SlideDirection.up,
                                ),

                                if (widget.canRenew) ...[
                                  Container(
                                    height: 1.w,
                                    color: context.colorScheme.surface
                                        .withValues(alpha: 0.1),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: SizeM.pagePadding.dg,
                                    ),
                                  ),
                                  (state.renewalReqState.isSuccess ? 38 : 10)
                                      .verticalSpace,
                                  buyTopUp().animatedOnAppear(
                                    4,
                                    SlideDirection.up,
                                  ),
                                ],
                                // const Spacer(),
                                // checkoutButton().animatedOnAppear(
                                //   6,
                                //   SlideDirection.up,
                                // ),
                                // SizedBox(
                                //   height:
                                //       MediaQuery.of(context).padding.bottom +
                                //       16.w,
                                // ),
                              ],
                            ),
                          ).animatedOnAppear(0, SlideDirection.up),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget usage() {
    return UseageProgress(
      leftTextSize: 32.sp,
      amountTextSize: 12.5.sp,
      dataAmount: state.order!.dataAmount,
      dataRemainingMB: state.order!.esimCards.first.dataRemainingMB ?? 0,
      usagePercentage: state.order!.esimCards.first.usagePercentage ?? 100,
      dataUnit: state.order!.dataUnit,
      size: 210.w,
      enableDarkLight: true,
      strokeWidth: 18,
      isUnlimited: state.order!.isUnlimited,
    );
  }

  Widget esimInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      alignment: Alignment.center,
      height: 85.h,
      decoration: ShapeDecoration(
        color: context.colorScheme.onSurface,
        shape: SmoothRectangleBorder(
          smoothness: 1,
          borderRadius: BorderRadius.circular(18.r),
          side: BorderSide(
            color: context.isDark ? Color(0xFF171717) : Color(0xFFE0E1E3),
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        spacing: 10.w,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              spacing: 13.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // simcard and country name
                Row(
                  spacing: 6.w,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [ColorM.primary, ColorM.secondary],
                          stops: [0.2, .6],
                        ).createShader(bounds);
                      },
                      child: SvgPicture.asset(
                        SvgM.simcard,
                        width: 22.w,
                        height: 22.w,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        state.order!.getCountryName(context.locale),
                        style: context.bodyLarge.copyWith(height: 1.2),
                      ),
                    ),
                  ],
                ).animatedOnAppear(2, SlideDirection.down),

                // day active usage
                Row(
                  spacing: 4.w,
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: state.order!.status.color(context),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      state.order!.status.tr,
                      style: context.bodySmall.copyWith(
                        height: 1.2,
                        color: context.bodySmall.color!.withValues(alpha: 0.8),
                        fontWeight: FontWeightM.medium,
                      ),
                    ),
                    // if (state.order!.status == EsimStatus.active) ...[
                    //   Container(
                    //     width: 15.w,
                    //     height: .7.w,
                    //     color: context.colorScheme.surface.withValues(
                    //       alpha: 0.5,
                    //     ),
                    //   ),
                    //   Text(
                    //     Translation.days_left.trNamed({
                    //       'days':
                    //           state.order!.esimCards.first.daysRemaining
                    //               ?.toString() ??
                    //           "#",
                    //     }),
                    //     style: context.bodySmall.copyWith(
                    //       height: 1.2,
                    //       color: context.bodySmall.color!.withValues(
                    //         alpha: 0.5,
                    //       ),
                    //       fontWeight: FontWeightM.light,
                    //     ),
                    //   ),
                    // ],
                  ],
                ).animatedOnAppear(1, SlideDirection.down),
              ],
            ),
          ),

          Container(
            width: 57.w,
            height: 57.w,
            padding: EdgeInsets.all(16.w),
            decoration: ShapeDecoration(
              color: context.isDark ? ColorM.primaryDark : ColorM.gray,
              shape: SmoothRectangleBorder(
                smoothness: 1,
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: CustomCachedImage(
              imageUrl: state.order!.countryImage,
              width: 24.w,
              height: 24.w,
              borderRadius: BorderRadius.circular(7.r),
            ),
          ).animatedOnAppear(3, SlideDirection.down),
        ],
      ),
    ).animatedOnAppear(0, SlideDirection.down);
  }

  Widget viewInstructionsButton({required VoidCallback onTap}) {
    return CustomInkButton(
      onTap: onTap,
      borderRadius: 0,
      padding: EdgeInsets.symmetric(
        horizontal: SizeM.pagePadding.dg,
        vertical: 16.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12.w,
            children: [
              SvgPicture.asset(
                SvgM.import,
                width: 24.w,
                height: 24.w,
                colorFilter: ColorFilter.mode(
                  context.colorScheme.surface,
                  BlendMode.srcIn,
                ),
              ),
              Text(
                Translation.view_instructions.tr,
                style: context.bodyLarge.copyWith(height: 1.2),
              ),
            ],
          ),

          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16.w,
            color: context.colorScheme.surface,
          ),
        ],
      ),
    );
  }

  Widget currentProvider() {
    return CustomInkButton(
      onTap: () async {
        await NetworksBottomSheet.show(
          context,
          networks: state.order!.networkDtoList,
        );
      },
      borderRadius: 0,
      padding: EdgeInsets.symmetric(
        horizontal: SizeM.pagePadding.dg,
        vertical: 16.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12.w,
            children: [
              SvgPicture.asset(
                SvgM.radar,
                width: 24.w,
                height: 24.w,
                colorFilter: ColorFilter.mode(
                  context.colorScheme.surface,
                  BlendMode.srcIn,
                ),
              ),
              Text(
                Translation.current_provider.tr,
                style: context.bodyLarge.copyWith(height: 1.2),
              ),
            ],
          ),

          Text(
            state.order!.networkDtoList.length == 1
                ? Translation.one_network.tr
                : state.order!.networkDtoList.length == 2
                ? Translation.two_networks.tr
                : Translation.networks_count.trNamed({
                    'count': state.order!.networkDtoList.length.toString(),
                  }),
            style: context.bodySmall.copyWith(
              height: 1.2,
              color: context.isDark
                  ? Colors.white
                  : Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget buyTopUp() {
    return StateRender(
      reqState: state.renewalReqState,
      loading: (_) {
        return MyCircularProgressIndicator();
      },
      error: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
          child: MyErrorWidget(
            errorType: state.renewalErrorType,
            svgSize: 70.w,
            onRetry: () {
              if (state.order != null)
                context.read<MyEsimDetailsBloc>().add(
                  GetRenewalOptionsEvent(id: state.order!.id),
                );
            },
            titleMessage: state.renewalErrorMessage ?? "",
          ),
        );
      },
      empty: (_) {
        return SizedBox.shrink();
      },
      success: (_) {
        return Column(
          spacing: 18.w,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
              child: Row(
                spacing: 12.w,
                children: [
                  Icon(
                    Icons.add,
                    size: 24.w,
                    color: context.colorScheme.surface,
                  ),
                  Text(
                    Translation.buy_top_up.tr,
                    style: context.bodyLarge.copyWith(height: 1.2),
                  ),
                ],
              ),
            ),

            // top up options
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
              child: ValueListenableBuilder(
                valueListenable: selectedPlanIndex,
                builder: (context, selectedValue, child) {
                  return Row(
                    spacing: 18.w,
                    children: [
                      for (var i = 0; i < state.renewalOptions.length; i++)
                        PlanItem(
                          days: state.renewalOptions[i].days,
                          price: state.renewalOptions[i].price,
                          dataAmount: state.renewalOptions[i].dataAmount,
                          dataUnit: state.renewalOptions[i].dataUnit,
                          currency: state.renewalOptions[i].currency,
                          isSelected: selectedValue == i,
                          isRecommended: i == 0,
                          isUnlimited: state.renewalOptions[i].isUnlimited,
                          onChange: (value) {
                            selectedPlanIndex.value = i;
                            PlainInformationBottomSheet.show(
                              context,
                              networkDtoList: [],
                              coveredCountries: [],
                              dataAmount: state.renewalOptions[i].dataAmount,
                              dataUnit: state.renewalOptions[i].dataUnit,
                              days: state.renewalOptions[i].days,
                              price: state.renewalOptions[i].price,
                              currency: state.renewalOptions[i].currency,
                              fupPolicy: state.renewalOptions[i]
                                  .displayFupPolicy(context.locale),
                              isDayPass: state.renewalOptions[i].isDaypass,
                              type: EsimsType.renewal,
                              packageId: state.renewalOptions[i].packageId,
                              buttonLabel: Translation.checkout.tr,
                              isUnlimited: state.renewalOptions[i].isUnlimited,
                              onButtonTapped: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                  context,
                                  RoutesManager.checkout.route,
                                  arguments: {
                                    'package-id':
                                        state.renewalOptions[i].packageId,
                                    'renewal-order-id': state.order!.id,
                                    'esim-type': EsimsType.renewal,
                                  },
                                );
                              },
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget checkoutButton() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
  //     child: CustomInkButton(
  //       onTap: () {
  //         Navigator.pushNamed(context, RoutesManager.checkout.route);
  //       },
  //       gradient: LinearGradient(
  //         colors: [ColorM.primary, ColorM.secondary],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       padding: EdgeInsets.symmetric(horizontal: 16.dg),
  //       borderRadius: SizeM.commonBorderRadius.r,
  //       height: 54.h,
  //       alignment: Alignment.center,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Row(
  //             spacing: 7.w,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 Translation.checkout.tr,
  //                 style: context.labelLarge.copyWith(
  //                   fontWeight: FontWeightM.semiBold,
  //                   height: 1,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //               RotatedBox(
  //                 quarterTurns: Directionality.of(context) == TextDirection.rtl
  //                     ? 2
  //                     : 0,
  //                 child: SvgPicture.asset(
  //                   SvgM.doubleArrow2,
  //                   width: 12.w,
  //                   height: 12.w,
  //                 ),
  //               ),
  //             ],
  //           ),

  //           Row(
  //             spacing: 12.w,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(
  //                 width: 1.w,
  //                 height: 20.w,
  //                 color: Colors.white.withValues(alpha: .5),
  //               ),
  //               Text(
  //                 Translation.sar.trNamed({'sar': '100'}),
  //                 style: context.bodyLarge.copyWith(
  //                   height: 1.1,
  //                   fontWeight: FontWeightM.medium,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Future<void> afterLayout(BuildContext context) async {
    context.read<MyEsimDetailsBloc>().add(
      GetMyEsimDetailsEvent(orderId: widget.orderId, canRenew: widget.canRenew),
    );
  }
}
