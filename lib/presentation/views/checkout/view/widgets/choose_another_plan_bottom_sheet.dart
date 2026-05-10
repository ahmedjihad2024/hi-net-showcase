import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/common/ui_components/error_widget.dart';
import 'package:hi_net/presentation/common/utils/after_layout.dart';
import 'package:hi_net/presentation/common/utils/state_render.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/checkout/bloc/checkout_bloc.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/plan_item.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/plain_information_bottom_sheet.dart';
import 'package:smooth_corner/smooth_corner.dart';

class ChooseAnotherPlanBottomSheet extends StatefulWidget {
  final BuildContext mainContext;
  final EsimsType type;
  final String? regionCode;
  final String? countryCode;
  const ChooseAnotherPlanBottomSheet({
    super.key,
    required this.mainContext,
    required this.type,
    this.regionCode,
    this.countryCode,
  });

  @override
  State<ChooseAnotherPlanBottomSheet> createState() =>
      _ChooseAnotherPlanBottomSheetState();

  static Future<void> show(
    BuildContext context,
    EsimsType type,
    String? regionCode,
    String? countryCode,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => ChooseAnotherPlanBottomSheet(
        mainContext: context,
        type: type,
        regionCode: regionCode,
        countryCode: countryCode,
      ),
    );
  }
}

class _ChooseAnotherPlanBottomSheetState
    extends State<ChooseAnotherPlanBottomSheet>
    with AfterLayout {
  TextEditingController searchController = TextEditingController();
  ValueNotifier<int> selectedPlanIndex = ValueNotifier(-1);

  CheckoutState get state => widget.mainContext.read<CheckoutBloc>().state;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      bloc: widget.mainContext.read<CheckoutBloc>(),
      builder: (context, state) {
        if (widget.type.isCountries) {
          selectedPlanIndex.value = state.countryPlans.indexWhere(
            (t) => t.id == state.id,
          );
        } else if (widget.type.isRegional) {
          selectedPlanIndex.value = state.regionalPlans.indexWhere(
            (t) => t.id == state.id,
          );
        }
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 20.w,
            left: SizeM.pagePadding.dg,
            right: SizeM.pagePadding.dg,
          ),
          decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
              smoothness: 1,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
            ),
            color: context.colorScheme.onSurface,
          ),
          child: ScreenState.setState(
            reqState: state.plansReqState,
            loading: () {
              return SizedBox(
                height: .5.sh,
                child: const Center(child: MyCircularProgressIndicator()),
              );
            },
            error: () {
              return SizedBox(
                height: .5.sh,
                child: MyErrorWidget(
                  onRetry: () {
                    if (widget.type.isRegional) {
                      widget.mainContext.read<CheckoutBloc>().add(
                        GetRegionPlansEvent(
                          regionCode: widget.regionCode ?? "",
                        ),
                      );
                    } else if (widget.type.isCountries) {
                      widget.mainContext.read<CheckoutBloc>().add(
                        GetCountryPlansEvent(
                          countryCode: widget.countryCode ?? "",
                        ),
                      );
                    }
                  },
                  titleMessage: state.errorMessage,
                ),
              );
            },
            online: () {
              return Column(
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
                  16.verticalSpace,
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [title(), 13.verticalSpace, planItems()],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget title() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(Translation.choose_another_plan.tr, style: context.bodyLarge),
      ],
    );
  }

  Widget planItems() {
    return ValueListenableBuilder(
      valueListenable: selectedPlanIndex,
      builder: (context, value, child) {
        int length = widget.type.isRegional
            ? state.regionalPlans.length
            : state.countryPlans.length;
        return Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom:
                  (View.of(context).padding.bottom /
                      View.of(context).devicePixelRatio) +
                  SizeM.pagePadding.dg,
            ),
            child: Column(
              spacing: 14.w,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < length; i++)
                  Builder(
                    builder: (context) {
                      int days = widget.type.isRegional
                          ? state.regionalPlans[i].days
                          : state.countryPlans[i].validityDays;
                      double dataAmount = widget.type.isRegional
                          ? state.regionalPlans[i].dataAmount
                          : state.countryPlans[i].dataAmount;
                      DataUnit dataUnit = widget.type.isRegional
                          ? state.regionalPlans[i].dataUnit
                          : state.countryPlans[i].dataUnit;
                      double price = widget.type.isRegional
                          ? state.regionalPlans[i].price
                          : state.countryPlans[i].price;
                      Currency currency = widget.type.isRegional
                          ? Currency.fromString(state.currency)!
                          : state.countryPlans[i].currency;
                      bool isUnlimited = widget.type.isRegional
                          ? state.regionalPlans[i].isUnlimited
                          : state.countryPlans[i].isUnlimited;

                      return PlanItem(
                        isRecommended: false,
                        days: days,
                        price: price,
                        dataUnit: dataUnit,
                        currency: currency,
                        isSelected: value == i,
                        dataAmount: dataAmount,
                        isUnlimited: isUnlimited,
                        badge: widget.type.isRegional
                            ? null
                            : state.countryPlans[i].displayBadge(context.locale),
                        onChange: (value) {
                          selectedPlanIndex.value = i;
                          PlainInformationBottomSheet.show(
                            context,
                            networkDtoList: widget.type.isRegional
                                ? state.regionalPlans[i].networkDtoList
                                : state.countryPlans[i].networkDtoList,
                            coveredCountries: widget.type.isRegional
                                ? state.regionalPlans[i].coveredCountries
                                : state.countryPlans[i].coveredCountries,
                            dataAmount: dataAmount,
                            dataUnit: dataUnit,
                            days: days,
                            price: price,
                            currency: currency,
                            isUnlimited: isUnlimited,
                            fupPolicy: widget.type.isRegional
                                ? state.regionalPlans[i].displayFupPolicy(
                                    context.locale,
                                  )
                                : state.countryPlans[i].displayFupPolicy(
                                    context.locale,
                                  ),
                            isRenewable: widget.type.isRegional
                                ? state.regionalPlans[i].isRenewable
                                : state.countryPlans[i].isRenewable,
                            isDayPass: widget.type.isRegional
                                ? state.regionalPlans[i].isDaypass
                                : state.countryPlans[i].isDaypass,
                            type: widget.type,
                            packageId: widget.type.isRegional
                                ? state.regionalPlans[i].id
                                : state.countryPlans[i].id,
                            buttonLabel: Translation.next.tr,
                            onButtonTapped: () {
                              late String packageId;
                              if (widget.type.isCountries) {
                                packageId = state
                                    .countryPlans[selectedPlanIndex.value]
                                    .id;
                              } else if (widget.type.isRegional) {
                                packageId = state
                                    .regionalPlans[selectedPlanIndex.value]
                                    .id;
                              }
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              widget.mainContext.read<CheckoutBloc>().add(
                                GetCheckoutDetailsEvent(
                                  packageId: packageId,
                                  locale: context.locale,
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
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
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 7.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Translation.confirm.tr,
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

  @override
  Future<void> afterLayout(BuildContext context) async {
    if (widget.type.isRegional) {
      widget.mainContext.read<CheckoutBloc>().add(
        GetRegionPlansEvent(regionCode: widget.regionCode ?? ""),
      );
    } else if (widget.type.isCountries) {
      widget.mainContext.read<CheckoutBloc>().add(
        GetCountryPlansEvent(countryCode: widget.countryCode ?? ""),
      );
    }
  }
}
