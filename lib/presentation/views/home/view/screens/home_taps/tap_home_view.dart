import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hi_net/app/app.dart';
import 'package:hi_net/app/constants.dart';
import 'package:hi_net/app/dependency_injection.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/presentation/common/utils/fast_function.dart';
import 'package:hi_net/presentation/views/checkout/view/widgets/rate_dialog.dart';
import 'package:hi_net/presentation/views/home/view/widgets/useage_progress.dart';
import 'package:money2/money2.dart' as money;
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/app/services/app_preferences.dart';
import 'package:hi_net/domain/model/models.dart';
import 'package:hi_net/presentation/common/ui_components/animated_tap_bar.dart';
import 'package:hi_net/presentation/common/ui_components/animations/animated_on_appear.dart';
import 'package:hi_net/presentation/common/ui_components/animations/animations_enum.dart';
import 'package:hi_net/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:hi_net/presentation/common/ui_components/custom_cached_image.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/common/ui_components/customized_smart_refresh.dart';
import 'package:hi_net/presentation/common/ui_components/error_widget.dart';
import 'package:hi_net/presentation/common/utils/after_layout.dart';
import 'package:hi_net/presentation/common/utils/snackbar_helper.dart';
import 'package:hi_net/presentation/common/utils/state_render.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/routes_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/plain_information_bottom_sheet.dart';
import 'package:hi_net/presentation/views/home/view/screens/home_view.dart';
import 'package:hi_net/presentation/views/home/view/widgets/country_item.dart';
import 'package:hi_net/presentation/views/home/view/widgets/customized_button.dart';
import 'package:hi_net/presentation/views/home/view/widgets/esim_card.dart';
import 'package:hi_net/presentation/views/home/view/widgets/global_item.dart';
import 'package:hi_net/presentation/views/home/view/widgets/half_circle_progress.dart';
import 'package:hi_net/presentation/views/home/view/widgets/pannar.dart';
import 'package:hi_net/presentation/views/home/view/widgets/regional_item.dart';
import 'package:hi_net/presentation/views/home/view/widgets/select_countr_bottom_sheet.dart';
import 'package:hi_net/presentation/views/home/view/widgets/select_duration_bottom_sheet.dart';
import 'package:hi_net/presentation/views/home/view/widgets/sign_in_button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_corner/smooth_corner.dart';
import '../../../bloc/home_bloc.dart';

enum TapHomeViewType { countries, regional, global }

class TapHomeView extends StatefulWidget {
  const TapHomeView({super.key});

  @override
  State<TapHomeView> createState() => _TapHomeViewState();
}

class _TapHomeViewState extends State<TapHomeView>
    with AutomaticKeepAliveClientMixin, AfterLayout {
  final RefreshController _refreshController = RefreshController();
  final ValueNotifier<int> _selectedTap = ValueNotifier(0);
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  HomeState get state => context.read<HomeBloc>().state;

  // void _onClickNextTimeSheet(int? timeNum, SelectDurationType? type) {
  //   if (timeNum != null && type != null) {
  //     context.read<HomeBloc>().add(SelectDurationEvent(timeNum, type));
  //   } else {
  //     context.read<HomeBloc>().add(UnselectDurationEvent());
  //   }
  //   Navigator.of(context).pop();
  //   Navigator.of(context).pushNamed(
  //     RoutesManager.search.route,
  //     arguments: {
  //       'show-history': true,
  //       'initial-country': state.selectedCountry,
  //       'selected-time-num': timeNum,
  //       'selected-time-type': type,
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final topPadding =
        View.of(context).viewPadding.top / View.of(context).devicePixelRatio;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return CustomizedSmartRefresh(
          controller: _refreshController,
          enableRefresh:
              state.mostRequestedCountriesReqState.isSuccess &&
              state.homeSlidersReqState.isSuccess,
          onRefresh: () async {
            _refreshController.refreshCompleted();
            if (state.mostRequestedCountriesReqState.isSuccess) {
              context.read<HomeBloc>().add(GetMostRequestedCountriesEvent());
            }

            if (state.homeSlidersReqState.isSuccess) {
              context.read<HomeBloc>().add(GetHomeSlidersEvent());
            }

            if (state.currentActiveEsimReqState.isSuccess) {
              context.read<HomeBloc>().add(GetCurrentActiveEsimEvent());
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (20 + topPadding).verticalSpace,
                topAppBar().animatedOnAppear(3),
                16.verticalSpace,
                Pannar().animatedOnAppear(2),
                if (instance<AppPreferences>().isUserRegistered) ...[
                  16.verticalSpace,
                  internetUsage().animatedOnAppear(1),
                ],
                16.verticalSpace,
                searchAndFilter().animatedOnAppear(0),
                16.verticalSpace,
                mostRequested().animatedOnAppear(0, SlideDirection.up),
                32.verticalSpace,
                Container(
                  color: context.colorScheme.onSurface,
                  child: Column(
                    children: [
                      tapNavigator().animatedOnAppear(2, SlideDirection.up),
                      taps().animatedOnAppear(3, SlideDirection.up),
                    ],
                  ),
                ).animatedOnAppear(0, SlideDirection.up),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget topAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // name and subtitle
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 7.h,
              children: [
                AnimatedOnAppear(
                  delay: Constants.animationDelay + (30 * 4),
                  animationDuration: Constants.animationDuration,
                  animationCurve: Constants.animationCurve,
                  animationTypes: {AnimationType.pulse},
                  slideDirection: SlideDirection.up,
                  slideDistance: Constants.animationSlideDistance,
                  child: Text(
                    Translation.hi_name.trNamed({
                      'name': state.userName.split(" ")[0],
                    }),
                    style: context.titleLarge.copyWith(
                      fontWeight: FontWeightM.medium,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // actions
          Row(
            spacing: 8.w,
            children: [
              ValueListenableBuilder(
                valueListenable: context
                    .read<HomeBloc>()
                    .unreadNotificationsCount,
                builder: (context, count, _) {
                  return CustomizedButton(
                    onPressed: () {
                      if (!instance<AppPreferences>().isUserRegistered) {
                        SnackbarHelper.showMessage(
                          Translation.please_sign_in.tr,
                          ErrorMessage.snackBar,
                          actions: [LoginButton(), 10.horizontalSpace],
                        );
                      } else {
                        context
                                .read<HomeBloc>()
                                .unreadNotificationsCount
                                .value =
                            0;
                        Navigator.of(
                          context,
                        ).pushNamed(RoutesManager.notifications.route);
                      }
                    },
                    svgImage: SvgM.notification,
                    count: count,
                  );
                },
              ),
              if (instance<AppPreferences>().isUserRegistered)
                CustomCachedImage(
                  imageUrl: state.profileImage ?? '',
                  width: 40.w,
                  height: 40.w,
                  isCircle: true,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget internetUsage() {
    return StateRender(
      reqState: state.currentActiveEsimReqState,
      loading: (_) {
        return Shimmer.fromColors(
          child: SmoothContainer(
            margin: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
            height: 85.h,
            smoothness: 1,
            borderRadius: BorderRadius.circular(14.r),
            color: context.colorScheme.surface,
          ),
          baseColor: context.colorScheme.surface.withValues(alpha: .1),
          highlightColor: context.colorScheme.onSurface.withValues(alpha: .1),
        );
      },
      success: (context) {
        return InkWell(
          onTap: () {
            if (state.currentActiveEsim != null)
              Navigator.of(context).pushNamed(
                RoutesManager.myEsimDetails.route,
                arguments: {
                  'order-id': state.currentActiveEsim!.orderId,
                  'can-renew': state.currentActiveEsim!.canRenew,
                },
              );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 3.9, sigmaY: 3.9),
                enabled: !state.hasActiveEsim,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: SizeM.pagePadding.dg,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  alignment: Alignment.center,
                  height: 85.h,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      stops: [0.0, 1.0],
                      colors: [ColorM.primary, ColorM.secondary],
                      begin: AlignmentDirectional.centerStart,
                      end: AlignmentDirectional.centerEnd,
                    ),
                    shape: SmoothRectangleBorder(
                      smoothness: 1,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                  child: Row(
                    spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Column(
                          spacing: 6.w,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // simcard and country name
                            Row(
                              spacing: 6.w,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  SvgM.simcard,
                                  width: 22.w,
                                  height: 22.w,
                                  colorFilter: ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    (state.currentActiveEsim?.countryNameLocale(
                                          context.locale,
                                        ) ??
                                        'no country'),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.bodyLarge.copyWith(
                                      height: 1.05,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // day active usage
                            Row(
                              spacing: 4.w,
                              children: [
                                Container(
                                  width: 12.w,
                                  height: 12.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          state.currentActiveEsim?.status.color(
                                            context,
                                          ) ??
                                          Colors.white,
                                      width: 3.w,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: RichText(
                                    textScaler: TextScaler.linear(
                                      View.of(
                                        context,
                                      ).platformDispatcher.textScaleFactor,
                                    ),
                                    text: TextSpan(
                                      text: state.currentActiveEsim?.status.tr,
                                      style: context.bodyLarge.copyWith(
                                        height: 1.2,
                                        color: Colors.white,
                                        fontWeight: FontWeightM.light,
                                      ),
                                      // children: [
                                      //   TextSpan(
                                      //     text: ' — ',
                                      //     style: context.bodyLarge.copyWith(
                                      //       height: 1.2,
                                      //       color: Colors.white,
                                      //       fontWeight: FontWeightM.light,
                                      //     ),
                                      //   ),
                                      //   TextSpan(
                                      //     text: Translation.days_left.trNamed({
                                      //       'days':
                                      //           state
                                      //               .currentActiveEsim
                                      //               ?.esimCards
                                      //               .firstOrNull
                                      //               ?.daysRemaining
                                      //               ?.toString() ??
                                      //           '#',
                                      //     }),
                                      //     style: context.bodyLarge.copyWith(
                                      //       height: 1.2,
                                      //       color: Colors.white,
                                      //       fontWeight: FontWeightM.light,
                                      //     ),
                                      //   ),
                                      // ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      UseageProgress(
                              leftTextSize: 16.sp,
                              amountTextSize: 10.sp,
                              dataAmount:
                                  state.currentActiveEsim?.dataAmount ?? 0,
                              dataRemainingMB:
                                  state
                                      .currentActiveEsim
                                      ?.esimCards
                                      .firstOrNull
                                      ?.dataRemainingMB ??
                                  0,
                              usagePercentage:
                                  state
                                      .currentActiveEsim
                                      ?.esimCards
                                      .first
                                      .usagePercentage ??
                                  100,
                              dataUnit:
                                  state.currentActiveEsim?.dataUnit ??
                                  DataUnit.GB,
                              size: 110.w,
                              isUnlimited:
                                  state.currentActiveEsim?.isUnlimited == true,
                            ),
                    ],
                  ),
                ),
              ),
              if (!state.hasActiveEsim)
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: SizeM.pagePadding.dg,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  alignment: Alignment.center,
                  height: 85.h,
                  decoration: ShapeDecoration(
                    color: Colors.black.withValues(alpha: 0.1),
                    shape: SmoothRectangleBorder(
                      smoothness: 1,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                  child: Text(
                    Translation.no_esim_active.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeightM.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget searchAndFilter() {
    return InkWell(
      onTap: () {
        BOTTOM_NAV_BAR_SELECTED_TAB.value = 1;
        BOTTOM_NAV_BAR_SLIDER_CONTROLLER.animateToPage(
          1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn,
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
        decoration: ShapeDecoration(
          color: context.colorScheme.onSurface,
          shape: SmoothRectangleBorder(
            smoothness: 1,
            borderRadius: BorderRadius.circular(14.r),
          ),
          shadows: [
            BoxShadow(
              color: ColorM.primary.withValues(alpha: 0.02),
              blurRadius: 0,
              spreadRadius: 2,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Translation.search_for_your_destination.tr,
              style: context.labelLarge.copyWith(),
            ),
            // Expanded(
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       Expanded(
            //         flex: 1,
            //         child: Filter(
            //           scale: 1.1,
            //           selectedFilter:
            //               (state.selectedCountry?.displayName(context.locale) ??
            //               Translation.all_countries.tr),
            //           label: Translation.country.tr,
            //           onTap: () {
            //             SelectCountrBottomSheet.show(
            //               context,
            //               initialCountry: state.selectedCountry,
            //               selectedTimeNum: state.selectedTimeNum ?? 0,
            //               selectedTimeType:
            //                   state.selectedTimeType ?? SelectDurationType.days,
            //               onClickNextTimeSheet: _onClickNextTimeSheet,

            //               onSelect: (country) {
            //                 if (country != null) {
            //                   context.read<HomeBloc>().add(
            //                     SelectCountryEvent(country),
            //                   );
            //                 } else {
            //                   context.read<HomeBloc>().add(
            //                     UnselectCountryEvent(),
            //                   );
            //                 }
            //               },
            //             );
            //           },
            //         ),
            //       ),
            //       13.horizontalSpace,
            //       Container(
            //         width: 1.w,
            //         height: 28.h,
            //         color: context.colorScheme.surface.withValues(alpha: 0.2),
            //       ),
            //       13.horizontalSpace,
            //       Expanded(
            //         flex: 1,
            //         child: Filter(
            //           scale: 1.1,
            //           selectedFilter: state.selectedTimeNum == null
            //               ? Translation.all_duration.tr
            //               : (state.selectedTimeType!.isDays
            //                     ? Translation.time.trDay(state.selectedTimeNum!)
            //                     : Translation.time.trWeek(
            //                         state.selectedTimeNum!,
            //                       )),
            //           label: Translation.duration.tr,
            //           onTap: () {
            //             SelectDurationBottomSheet.show(
            //               context,
            //               selectedDays: state.selectedTimeNum ?? 0,
            //               selectedType:
            //                   state.selectedTimeType ?? SelectDurationType.days,
            //               onClickNextTimeSheet: _onClickNextTimeSheet,
            //             );
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox.shrink(),
            CustomInkButton(
              // onTap: () {
              //   Navigator.of(context).pushNamed(
              //     RoutesManager.search.route,
              //     arguments: {
              //       'show-history': true,
              //       'initial-country': state.selectedCountry,
              //       'selected-time-num': state.selectedTimeNum,
              //       'selected-time-type': state.selectedTimeType,
              //     },
              //   );
              // },
              width: 34.w,
              height: 34.w,
              alignment: Alignment.center,
              gradient: LinearGradient(
                colors: [ColorM.primary, ColorM.secondary],
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
              ),
              borderRadius: 100000,
              child: SvgPicture.asset(
                SvgM.search,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                width: 16.w,
                height: 16.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mostRequested() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
          child: Text(
            Translation.most_requested.tr,
            style: context.titleMedium,
          ),
        ),
        12.verticalSpace,
        ScreenState.setState(
          reqState: state.mostRequestedCountriesReqState,
          loading: () {
            return Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeM.pagePadding.dg,
                    ),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12.w,
                      children: [
                        for (var i = 0; i < 3; i++)
                          Shimmer.fromColors(
                            child: Container(
                              width: 124.w,
                              height: 138.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.r),
                                color: context.colorScheme.surface,
                              ),
                            ),
                            baseColor: context.colorScheme.surface.withValues(
                              alpha: .1,
                            ),
                            highlightColor: context.colorScheme.onSurface
                                .withValues(alpha: .1),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          online: () {
            return Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeM.pagePadding.dg,
                    ),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12.w,
                      children: [
                        for (
                          var i = 0;
                          i < state.mostRequestedCountries.length;
                          i++
                        )
                          EsimCard(
                            imageUrl:
                                state
                                    .mostRequestedCountries[i]
                                    .featuredImageUrl ??
                                state.mostRequestedCountries[i].imageUrl,
                            countryName: state.mostRequestedCountries[i]
                                .displayName(context.locale),
                            label:
                                state.mostRequestedCountries[i].startAt != null
                                ? 'from_price_format'.tr(
                                    namedArgs: {
                                      'price': money.Money.fromNum(
                                        state
                                            .mostRequestedCountries[i]
                                            .startAt!,
                                        isoCode:
                                            state.globalCurrency?.name ??
                                            (state
                                                    .mostRequestedCountries[i]
                                                    .currency ??
                                                'SAR'),
                                      ).format('#.## S'),
                                    },
                                  )
                                : null,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RoutesManager.esimDetails.route,
                                arguments: {
                                  'type': EsimsType.country,
                                  'country-code': state
                                      .mostRequestedCountries[i]
                                      .countryCode,
                                  'image-url':
                                      state.mostRequestedCountries[i].imageUrl,
                                  'featured-image-url': state
                                      .mostRequestedCountries[i]
                                      .featuredImageUrl,
                                  'display-name': state
                                      .mostRequestedCountries[i]
                                      .displayName(context.locale),
                                  'note': state.mostRequestedCountries[i]
                                      .displayNote(context.locale),
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget tapNavigator() {
    return ValueListenableBuilder(
      valueListenable: _selectedTap,
      builder: (context, selectedTapValue, child) {
        return AnimatedTapsNavigator(
          tabs: [
            Translation.countries.tr,
            Translation.regional.tr,
            Translation.global.tr,
          ],
          selectedTap: selectedTapValue,
          onTap: (index) {
            _selectedTap.value = index;
            _carouselController.animateToPage(index);
          },
          margin: 0,
          padding: 0,
          isStickStyle: true,
          stickHeight: 1.5.w,
          stickWidth: 83.w,
          borderRadius: 0,
          stickTopMargin: 45.h - 1.5.w,
          // Position stick at bottom of container
          isStickAtTop: false,
          containerHeight: 45.h,
          backgroundColor: Colors.transparent,
          borderColor: Colors.transparent,
          borderWidth: 0,
          activeTextColor: ColorM.primary,
          // Dark Teal
          inactiveTextColor: context.colorScheme.surface.withValues(alpha: 0.7),
          // gray-400
          fontSize: 15.sp,
          fontWeight: FontWeightM.light,
          stickColor: ColorM.primary,
          // Dark Teal
          stickBorderRadius: 50.r,
          animationDuration: const Duration(milliseconds: 300),
          animationCurve: Curves.easeInOut,
        );
      },
    );
  }

  Widget taps() {
    return CarouselSlider(
      items: [
        CountriesTap(type: TapHomeViewType.countries),
        CountriesTap(type: TapHomeViewType.regional),
        CountriesTap(type: TapHomeViewType.global),
      ],
      options: CarouselOptions(
        viewportFraction: 1,
        aspectRatio: 1,
        height: 0.5.sh,
        enableInfiniteScroll: false,
        padEnds: false,
        animateToClosest: false,
        scrollPhysics: const NeverScrollableScrollPhysics(),
      ),
      carouselController: _carouselController,
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> afterLayout(BuildContext context) async {}
}

class Filter extends StatefulWidget {
  final String selectedFilter;
  final Function() onTap;
  final String label;
  final double scale;

  const Filter({
    super.key,
    required this.selectedFilter,
    required this.onTap,
    required this.label,
    this.scale = 1,
  });

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6.w,
        children: [
          Text(
            widget.label,
            style: context.labelSmall.copyWith(
              fontWeight: FontWeightM.light,
              height: 1.2,
              fontSize: 10.sp * widget.scale,
              color: context.labelMedium.color!.withValues(alpha: 0.9),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 120.w),
                child: Text(
                  widget.selectedFilter,
                  style: TextStyle(
                    fontSize: 10.sp * widget.scale,
                    fontWeight: FontWeight.w400,
                    height: 1.0,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
              10.horizontalSpace,
              Transform.rotate(
                angle: 90 * 3.14159 / 180, // 90 degrees in radians
                child: Icon(
                  textDirection: TextDirection.ltr,
                  Icons.arrow_forward_ios,
                  size: 12.w,
                  color: context.labelMedium.color!.withValues(alpha: .8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CountriesTap extends StatefulWidget {
  final TapHomeViewType type;

  const CountriesTap({super.key, required this.type});

  @override
  State<CountriesTap> createState() => _CountriesTapState();
}

class _CountriesTapState extends State<CountriesTap>
    with AutomaticKeepAliveClientMixin, AfterLayout {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomeState state = context.read<HomeBloc>().state;
    super.build(context);
    return ScreenState.setState(
      reqState: switch (widget.type) {
        TapHomeViewType.countries => state.countryReqState,
        TapHomeViewType.regional => state.regionReqState,
        TapHomeViewType.global => state.globalReqState,
      },
      loading: () {
        return MyCircularProgressIndicator();
      },
      error: () {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
          child: MyErrorWidget(
            errorType: switch (widget.type) {
              TapHomeViewType.countries => state.countryErrorType,
              TapHomeViewType.regional => state.regionErrorType,
              TapHomeViewType.global => state.globalErrorType,
            },
            onRetry: () {
              switch (widget.type) {
                case TapHomeViewType.countries:
                  context.read<HomeBloc>().add(GetCountriesEvent());
                  break;
                case TapHomeViewType.regional:
                  context.read<HomeBloc>().add(GetRegionsEvent());
                  break;
                case TapHomeViewType.global:
                  context.read<HomeBloc>().add(GetGlobalPlansEvent());
                  break;
              }
            },
            svgSize: 100.w,
            titleMessage: switch (widget.type) {
              TapHomeViewType.countries => state.countryErrorMessage,
              TapHomeViewType.regional => state.regionErrorMessage,
              TapHomeViewType.global => state.globalErrorMessage,
            },
          ),
        );
      },
      empty: () {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
          child: MyErrorWidget(
            errorType: ErrorType.noResults,
            svgSize: 100.w,
            onRetry: () {
              switch (widget.type) {
                case TapHomeViewType.countries:
                  context.read<HomeBloc>().add(GetCountriesEvent());
                  break;
                case TapHomeViewType.regional:
                  context.read<HomeBloc>().add(GetRegionsEvent());
                  break;
                case TapHomeViewType.global:
                  context.read<HomeBloc>().add(GetGlobalPlansEvent());
                  break;
              }
            },
            titleMessage: "",
          ),
        );
      },
      online: () {
        return CustomizedSmartRefresh(
          controller: _refreshController,
          onRefresh: () {
            _refreshController.refreshCompleted();
            switch (widget.type) {
              case TapHomeViewType.countries:
                context.read<HomeBloc>().add(GetCountriesEvent());
                break;
              case TapHomeViewType.regional:
                context.read<HomeBloc>().add(GetRegionsEvent());
                break;
              case TapHomeViewType.global:
                context.read<HomeBloc>().add(GetGlobalPlansEvent());
                break;
            }
          },
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: switch (widget.type) {
              TapHomeViewType.countries => state.countries.length,
              TapHomeViewType.regional => state.regions.length,
              TapHomeViewType.global => state.globalPlansCount,
            },
            itemBuilder: (context, index) => switch (widget.type) {
              TapHomeViewType.countries => CountryItem2(
                imageUrl: state.countries[index].imageUrl,
                countryName: state.countries[index].displayName(context.locale),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RoutesManager.esimDetails.route,
                    arguments: {
                      'type': EsimsType.country,
                      'country-code': state.countries[index].countryCode,
                      'image-url': state.countries[index].imageUrl,
                      'featured-image-url':
                          state.countries[index].featuredImageUrl,
                      'display-name': state.countries[index].displayName(
                        context.locale,
                      ),
                      'note': state.countries[index].displayNote(
                        context.locale,
                      ),
                    },
                  );
                },
              ),
              TapHomeViewType.regional => RegionalItem(
                imageUrl: '',
                countryName: state.regions[index].regionName(context.locale),
                planCount: state.regions[index].plansCount,
                isRecommended: false,
                price: state.regions[index].startFromPrice,
                currency: state.regions[index].currency,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RoutesManager.esimDetails.route,
                    arguments: {
                      'type': EsimsType.regional,
                      'region-code': state.regions[index].regionCode,
                      'display-name': state.regions[index].regionName(
                        context.locale,
                      ),
                      'note': state.regions[index].displayNote(context.locale),
                      'region-currency': state.regions[index].currency,
                    },
                  );
                },
              ),
              TapHomeViewType.global => GlobalItem(
                days: state.globalPlans![index].days,
                dataAmount: state.globalPlans![index].dataAmount,
                dataUnit: state.globalPlans![index].dataUnit,
                price: state.globalPlans![index].price,
                currency: state.globalCurrency!,
                countryCount: null,
                isRecommended: false,
                isUnlimited: state.globalPlans![index].isUnlimited,

                onTap: () {
                  PlainInformationBottomSheet.show(
                    context,
                    networkDtoList: state.globalPlans![index].networkDtoList,
                    note: state.globalPlans![index].displayNote(context.locale),
                    coveredCountries:
                        state.globalPlans![index].coveredCountries,
                    dataAmount: state.globalPlans![index].dataAmount,
                    dataUnit: state.globalPlans![index].dataUnit,
                    days: state.globalPlans![index].days,
                    price: state.globalPlans![index].price,
                    currency: state.globalCurrency!,
                    isRenewable: state.globalPlans![index].isRenewable,
                    isDayPass: state.globalPlans![index].isDaypass,
                    type: EsimsType.global,
                    packageId: state.globalPlans![index].id,
                    buttonLabel: Translation.checkout.tr,
                    fupPolicy: state.globalPlans![index].displayFupPolicy(
                      context.locale,
                    ),
                    isUnlimited: state.globalPlans![index].isUnlimited,
                    onButtonTapped: () {
                      if (!instance<AppPreferences>().isUserRegistered) {
                        LastSelectedPlanDetails = PlanDetails(
                          networkDtoList:
                              state.globalPlans![index].networkDtoList,
                          note: state.globalPlans![index].displayNote(
                            context.locale,
                          ),
                          coveredCountries:
                              state.globalPlans![index].coveredCountries,
                          dataAmount: state.globalPlans![index].dataAmount,
                          dataUnit: state.globalPlans![index].dataUnit,
                          days: state.globalPlans![index].days,
                          price: state.globalPlans![index].price,
                          currency: state.globalCurrency!,
                          isRenewable: state.globalPlans![index].isRenewable,
                          isDayPass: state.globalPlans![index].isDaypass,
                          packageId: state.globalPlans![index].id,
                          buttonLabel: Translation.checkout.tr,
                          fupPolicy: state.globalPlans![index].displayFupPolicy(
                            context.locale,
                          ),
                          esimType: EsimsType.global,
                          countryCode: null,
                          regionCode: null,
                          isUnlimited: state.globalPlans![index].isUnlimited,
                        );
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesManager.signIn.route,
                          (route) => false,
                        );
                        return;
                      }
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        RoutesManager.checkout.route,
                        arguments: {
                          'package-id': state.globalPlans![index].id,
                          'esim-type': EsimsType.global,
                        },
                      );
                    },
                  );
                },
              ),
            },
            separatorBuilder: (context, index) => Container(
              height: 1.w,
              margin: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
              color: context.colorScheme.surface.withValues(alpha: 0.2),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> afterLayout(BuildContext context) async {
    switch (widget.type) {
      case TapHomeViewType.countries:
        context.read<HomeBloc>().add(GetCountriesEvent());
        break;
      case TapHomeViewType.regional:
        context.read<HomeBloc>().add(GetRegionsEvent());
        break;
      case TapHomeViewType.global:
        context.read<HomeBloc>().add(GetGlobalPlansEvent());
        break;
    }
  }
}
