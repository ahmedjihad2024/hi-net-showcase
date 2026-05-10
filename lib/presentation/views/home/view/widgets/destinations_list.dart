import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/app/dependency_injection.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/app/services/app_preferences.dart';
import 'package:hi_net/domain/model/models.dart';
import 'package:hi_net/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:hi_net/presentation/common/ui_components/error_widget.dart';
import 'package:hi_net/presentation/common/utils/state_render.dart';
import 'package:hi_net/presentation/res/routes_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/plain_information_bottom_sheet.dart';
import 'package:hi_net/presentation/views/home/bloc/home_bloc.dart';
import 'package:hi_net/presentation/views/home/view/screens/home_view.dart';
import 'package:hi_net/presentation/views/home/view/widgets/country_item.dart';
import 'package:hi_net/presentation/views/home/view/widgets/global_item.dart';
import 'package:hi_net/presentation/views/home/view/widgets/regional_item.dart';

class DestinationsList extends StatelessWidget {
  const DestinationsList({super.key});

  @override
  Widget build(BuildContext context) {
    HomeState state = context.read<HomeBloc>().state;
    return StateRender(
      reqState: state.selectedDestinationTap.isGlobal
          ? state.globalReqState
          : ReqState.success,
      loading: (_) {
        return MyCircularProgressIndicator();
      },
      error: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
          child: MyErrorWidget(
            errorType: state.globalErrorType,
            onRetry: () {
              context.read<HomeBloc>().add(GetGlobalPlansEvent());
            },
            titleMessage: state.globalErrorMessage,
          ),
        );
      },
      empty: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
          child: MyErrorWidget(
            errorType: ErrorType.noResults,
            onRetry: () {
              context.read<HomeBloc>().add(GetGlobalPlansEvent());
            },
            titleMessage: state.globalErrorMessage,
          ),
        );
      },
      success: (context) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: state.isFilterApplied
              ? (state.destinationCountries.length +
                    state.destinationRegions.length +
                    (state.filteredGlobalPlans?.length ?? 0))
              : (state.selectedDestinationTap.isCountry
                    ? state.destinationCountries.length
                    : state.selectedDestinationTap.isRegion
                    ? state.destinationRegions.length
                    : (state.filteredGlobalPlans?.length ?? 0)),
          itemBuilder: (context, index) {
            final int countriesCount = state.destinationCountries.length;
            final int regionsCount = state.destinationRegions.length;

            // When filter is applied, we show all categories in order: Countries -> Regions -> Globals
            if (state.isFilterApplied) {
              if (index < countriesCount) {
                return _buildCountryItem(context, state, index);
              } else if (index < countriesCount + regionsCount) {
                return _buildRegionItem(context, state, index - countriesCount);
              } else {
                return _buildGlobalItem(
                  context,
                  state,
                  index - countriesCount - regionsCount,
                );
              }
            }

            // Normal state: show items based on selected tap
            if (state.selectedDestinationTap.isCountry) {
              return _buildCountryItem(context, state, index);
            } else if (state.selectedDestinationTap.isRegion) {
              return _buildRegionItem(context, state, index);
            } else {
              return _buildGlobalItem(context, state, index);
            }
          },
        );
      },
    );
  }

  Widget _buildCountryItem(BuildContext context, HomeState state, int index) {
    return CountryItem2(
      imageUrl: state.destinationCountries[index].imageUrl,
      countryName: state.destinationCountries[index].displayName(
        context.locale,
      ),
      circleIcon: true,
      onTap: () {
        Navigator.pushNamed(
          context,
          RoutesManager.esimDetails.route,
          arguments: {
            'type': EsimsType.country,
            'country-code': state.destinationCountries[index].code,
            'image-url': state.destinationCountries[index].imageUrl,
            'featured-image-url': state.destinationCountries[index].featuredImageUrl,
            'display-name': state.destinationCountries[index].displayName(
              context.locale,
            ),
            'note': state.destinationCountries[index].displayNote(
              context.locale,
            ),
          },
        );
      },
    );
  }

  Widget _buildRegionItem(BuildContext context, HomeState state, int index) {
    return RegionalItem2(
      countryName: state.destinationRegions[index].displayName(context.locale),
      circleIcon: true,
      supportedCountries: state.destinationRegions[index].coveredCountries,
      onTap: () {
        Navigator.pushNamed(
          context,
          RoutesManager.esimDetails.route,
          arguments: {
            'type': EsimsType.regional,
            'region-code': state.destinationRegions[index].code,
            'image-url': state.destinationRegions[index].imageUrl,
            'display-name': state.destinationRegions[index].displayName(
              context.locale,
            ),
            'region-currency': state.globalCurrency ?? Currency.SAR,
            'note': state.destinationRegions[index].displayNote(context.locale),
          },
        );
      },
    );
  }

  Widget _buildGlobalItem(BuildContext context, HomeState state, int index) {
    return GlobalItem(
      days: state.filteredGlobalPlans![index].days,
      dataAmount: state.filteredGlobalPlans![index].dataAmount,
      dataUnit: state.filteredGlobalPlans![index].dataUnit,
      price: state.filteredGlobalPlans![index].price,
      currency: state.globalCurrency!,
      countryCount: null,
      isRecommended: false,
      isUnlimited: state.filteredGlobalPlans![index].isUnlimited,
      onTap: () {
        PlainInformationBottomSheet.show(
          context,
          networkDtoList: state.filteredGlobalPlans![index].networkDtoList,
          note: state.filteredGlobalPlans![index].displayNote(context.locale),
          coveredCountries: state.filteredGlobalPlans![index].coveredCountries,
          dataAmount: state.filteredGlobalPlans![index].dataAmount,
          dataUnit: state.filteredGlobalPlans![index].dataUnit,
          days: state.filteredGlobalPlans![index].days,
          price: state.filteredGlobalPlans![index].price,
          currency: state.globalCurrency!,
          isRenewable: state.filteredGlobalPlans![index].isRenewable,
          isDayPass: state.filteredGlobalPlans![index].isDaypass,
          type: EsimsType.global,
          packageId: state.filteredGlobalPlans![index].id,
          buttonLabel: Translation.checkout.tr,
          fupPolicy: state.filteredGlobalPlans![index].displayFupPolicy(
            context.locale,
          ),
          isUnlimited: state.filteredGlobalPlans![index].isUnlimited,
          onButtonTapped: () {
            if (!instance<AppPreferences>().isUserRegistered) {
              LastSelectedPlanDetails = PlanDetails(
                networkDtoList:
                    state.filteredGlobalPlans![index].networkDtoList,
                note: state.filteredGlobalPlans![index].displayNote(
                  context.locale,
                ),
                coveredCountries:
                    state.filteredGlobalPlans![index].coveredCountries,
                dataAmount: state.filteredGlobalPlans![index].dataAmount,
                dataUnit: state.filteredGlobalPlans![index].dataUnit,
                days: state.filteredGlobalPlans![index].days,
                price: state.filteredGlobalPlans![index].price,
                currency: state.globalCurrency!,
                isUnlimited: state.filteredGlobalPlans![index].isUnlimited,
                isRenewable: state.filteredGlobalPlans![index].isRenewable,
                isDayPass: state.filteredGlobalPlans![index].isDaypass,
                packageId: state.filteredGlobalPlans![index].id,
                buttonLabel: Translation.checkout.tr,
                fupPolicy: state.filteredGlobalPlans![index].displayFupPolicy(
                  context.locale,
                ),
                esimType: EsimsType.global,
                countryCode: null,
                regionCode: null,
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
                'package-id': state.filteredGlobalPlans![index].id,
                'esim-type': EsimsType.global,
              },
            );
          },
        );
      },
    );
  }
}
