import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/app/dependency_injection.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/app/services/app_preferences.dart';
import 'package:hi_net/domain/model/models.dart';
import 'package:hi_net/presentation/common/ui_components/animations/animations_enum.dart';
import 'package:hi_net/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:hi_net/presentation/common/ui_components/custom_cached_image.dart';
import 'package:hi_net/presentation/common/ui_components/default_app_bar.dart';
import 'package:hi_net/presentation/common/ui_components/error_widget.dart';
import 'package:hi_net/presentation/common/utils/after_layout.dart';
import 'package:hi_net/presentation/common/utils/state_render.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/routes_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/esim_details/bloc/esim_details_bloc.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/plan_item.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/plain_information_bottom_sheet.dart';
import 'package:hi_net/presentation/views/home/view/screens/home_view.dart';
import 'package:smooth_corner/smooth_corner.dart';
import '../../../../common/ui_components/gradient_border_side.dart'
    as gradient_border_side;

class EsimDetailsView extends StatefulWidget {
  final EsimsType type;
  final String displayName;
  final String? countryCode;
  final String? regionCode;
  final Currency? regionCurrency;
  final String? imageUrl;
  final String? featuredImageUrl;
  final String? note;

  const EsimDetailsView({
    super.key,
    required this.type,
    required this.displayName,
    this.countryCode,
    this.regionCode,
    this.regionCurrency,
    this.imageUrl,
    this.featuredImageUrl,
    this.note,
  });

  @override
  State<EsimDetailsView> createState() => _EsimDetailsViewState();
}

class _EsimDetailsViewState extends State<EsimDetailsView> with AfterLayout {
  final ScrollController _scrollController = ScrollController();
  ValueNotifier<double> _scrollOffset = ValueNotifier<double>(0.0);
  
  // Filter states
  String _selectedDataType = 'all'; // 'all', 'unlimited', 'fixed'
  // int? _selectedDays; // null means 'All' - Commented out for now

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset.value = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  EsimDetailsState get state => context.read<EsimDetailsBloc>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EsimDetailsBloc, EsimDetailsState>(
        builder: (context, state) {
          return Column(
            children: [
              // Sticky header
              CountryfCard(
                scrollOffset: _scrollOffset,
                widget: widget,
              ).animatedOnAppear(0, SlideDirection.down),
              ScreenState.setState(
                reqState: state.reqState,
                loading: () {
                  return Expanded(child: MyCircularProgressIndicator());
                },
                empty: () {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeM.pagePadding.dg,
                      ),
                      child: MyErrorWidget(
                        svgSize: 180.w,
                        errorType: ErrorType.noResults,
                        onRetry: () {
                          if (widget.type.isRegional) {
                            context.read<EsimDetailsBloc>().add(
                              GetRegionPlansEvent(
                                regionCode: widget.regionCode!,
                              ),
                            );
                          } else if (widget.type.isCountries) {
                            context.read<EsimDetailsBloc>().add(
                              GetCountryPlansEvent(
                                countryCode: widget.countryCode!,
                              ),
                            );
                          }
                        },
                        titleMessage: state.errorMessage,
                      ),
                    ).animatedOnAppear(0, SlideDirection.up),
                  );
                },
                error: () {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeM.pagePadding.dg,
                      ),
                      child: MyErrorWidget(
                        svgSize: 180.w,
                        errorType: state.errorType,
                        onRetry: () {
                          if (widget.type.isRegional) {
                            context.read<EsimDetailsBloc>().add(
                              GetRegionPlansEvent(
                                regionCode: widget.regionCode!,
                              ),
                            );
                          } else if (widget.type.isCountries) {
                            context.read<EsimDetailsBloc>().add(
                              GetCountryPlansEvent(
                                countryCode: widget.countryCode!,
                              ),
                            );
                          }
                        },
                        titleMessage: state.errorMessage,
                      ),
                    ).animatedOnAppear(0, SlideDirection.up),
                  );
                },
                online: () {
                  return Expanded(
                    child: Column(
                      children: [
                        // Scrollable content
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: ClampingScrollPhysics(),
                            padding: EdgeInsets.only(top: 24.w),
                            child: Column(
                              children: [
                                if (widget.note != null && widget.note!.trim().isNotEmpty) ...[
                                  NoteCard(
                                    message: widget.note!,
                                  ).animatedOnAppear(1, SlideDirection.up),
                                  14.verticalSpace,
                                ],
                                _buildFilters().animatedOnAppear(1, SlideDirection.up),
                                24.verticalSpace,
                                planItems().animatedOnAppear(
                                  2,
                                  SlideDirection.up,
                                ),
                                SizedBox(
                                  height:
                                      (View.of(context).padding.bottom /
                                          View.of(context).devicePixelRatio) +
                                      SizeM.pagePadding.dg,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilters() {
    bool hasUnlimitedAndFixed = _hasBothUnlimitedAndFixed();
    
    // Reset data type filter if there's only one type
    if (!hasUnlimitedAndFixed && _selectedDataType != 'all') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedDataType = 'all';
        });
      });
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: Column(
        spacing: 12.w,
        children: [
          // Data type filters - only show if there are both unlimited and fixed plans
          if (hasUnlimitedAndFixed)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8.w,
                children: [
                  _buildFilterChip(
                    label: Translation.unlimited.tr,
                    icon: Icons.all_inclusive,
                    isSelected: _selectedDataType == 'unlimited',
                    onTap: () {
                      setState(() {
                        _selectedDataType = _selectedDataType == 'unlimited' ? 'all' : 'unlimited';
                      });
                    },
                  ),
                  _buildFilterChip(
                    label: Translation.fixed_data.tr,
                    icon: Icons.signal_cellular_alt,
                    isSelected: _selectedDataType == 'fixed',
                    onTap: () {
                      setState(() {
                        _selectedDataType = _selectedDataType == 'fixed' ? 'all' : 'fixed';
                      });
                    },
                  ),
                ],
              ),
            ),
          // Days filters - Commented out for now
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     spacing: 8.w,
          //     children: [
          //       _buildFilterChip(
          //         label: Translation.all.tr,
          //         isSelected: _selectedDays == null,
          //         onTap: () {
          //           setState(() {
          //             _selectedDays = null;
          //           });
          //         },
          //       ),
          //       ..._getAvailableDays().map((days) {
          //         bool isArabic = context.locale.languageCode == 'ar';
          //         return _buildFilterChip(
          //           label: _getDayLabel(days, isArabic),
          //           isSelected: _selectedDays == days,
          //           onTap: () {
          //             setState(() {
          //               _selectedDays = _selectedDays == days ? null : days;
          //             });
          //           },
          //         );
          //       }),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
        decoration: ShapeDecoration(
          shape: SmoothRectangleBorder(
            smoothness: 1,
            borderRadius: BorderRadius.circular(100.r),
            side: BorderSide(
              color: isSelected
                  ? ColorM.primary
                  : context.colorScheme.surface.withValues(alpha: 0.2),
              width: 1.w,
            ),
          ),
          color: isSelected 
              ? ColorM.primary.withValues(alpha: 0.15)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6.w,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 16.w,
                color: isSelected
                    ? ColorM.primary
                    : context.colorScheme.surface.withValues(alpha: 0.6),
              ),
            Text(
              label,
              style: context.labelLarge.copyWith(
                color: isSelected
                    ? ColorM.primary
                    : context.colorScheme.surface.withValues(alpha: 0.6),
                fontWeight: isSelected ? FontWeightM.semiBold : FontWeightM.regular,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasBothUnlimitedAndFixed() {
    int plansLength = widget.type.isRegional
        ? state.regionalPlans.length
        : state.countryPlans.length;
    
    bool hasUnlimited = false;
    bool hasFixed = false;
    
    for (var i = 0; i < plansLength; i++) {
      bool isUnlimited = widget.type.isRegional
          ? state.regionalPlans[i].isUnlimited
          : state.countryPlans[i].isUnlimited;
      
      if (isUnlimited) {
        hasUnlimited = true;
      } else {
        hasFixed = true;
      }
      
      // If we found both types, we can stop checking
      if (hasUnlimited && hasFixed) {
        return true;
      }
    }
    
    return false;
  }

  // Commented out for now - might be added later
  // List<int> _getAvailableDays() {
  //   int plansLength = widget.type.isRegional
  //       ? state.regionalPlans.length
  //       : state.countryPlans.length;
  //   
  //   Set<int> daysSet = {};
  //   for (var i = 0; i < plansLength; i++) {
  //     int days = widget.type.isRegional
  //         ? state.regionalPlans[i].days
  //         : state.countryPlans[i].validityDays;
  //     daysSet.add(days);
  //   }
  //   
  //   List<int> daysList = daysSet.toList()..sort();
  //   return daysList;
  // }

  String _getDayLabel(int days, bool isArabic) {
    if (isArabic) {
      switch (days) {
        case 1:
          return 'يوم واحد';
        case 2:
          return 'يومين';
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
          return '$days أيام';
        default:
          return '$days يوم';
      }
    } else {
      switch (days) {
        case 1:
          return '1 Day';
        case 2:
          return '2 Days';
        default:
          return '$days Days';
      }
    }
  }

  Widget planItems() {
    return Builder(
      builder: (context) {
        int plansLength = widget.type.isRegional
            ? state.regionalPlans.length
            : state.countryPlans.length;

        // Filter plans based on selected filters
        List<int> filteredIndices = [];
        for (var i = 0; i < plansLength; i++) {
          // int days = widget.type.isRegional
          //     ? state.regionalPlans[i].days
          //     : state.countryPlans[i].validityDays;
          bool isUnlimited = widget.type.isRegional
              ? state.regionalPlans[i].isUnlimited
              : state.countryPlans[i].isUnlimited;
          
          // Apply data type filter
          bool matchesDataType = _selectedDataType == 'all' ||
              (_selectedDataType == 'unlimited' && isUnlimited) ||
              (_selectedDataType == 'fixed' && !isUnlimited);
          
          // Apply days filter - Commented out for now
          // bool matchesDays = _selectedDays == null || _selectedDays == days;
          
          if (matchesDataType) { // && matchesDays
            filteredIndices.add(i);
          }
        }

        // Group filtered plans by days
        Map<int, List<int>> plansByDays = {};
        for (var i in filteredIndices) {
          int days = widget.type.isRegional
              ? state.regionalPlans[i].days
              : state.countryPlans[i].validityDays;
          if (!plansByDays.containsKey(days)) {
            plansByDays[days] = [];
          }
          plansByDays[days]!.add(i);
        }

        // Sort days
        List<int> sortedDays = plansByDays.keys.toList()..sort();

        // Check if Arabic
        bool isArabic = context.locale.languageCode == 'ar';
        
        // Show empty state if no plans match the filters
        if (filteredIndices.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg, vertical: 40.w),
            child: Center(
              child: Text(
                isArabic ? 'لا توجد خطط تطابق الفلاتر المحددة' : 'No plans match the selected filters',
                style: context.bodyLarge.copyWith(
                  color: context.colorScheme.surface.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
          child: Column(
            children: [
              for (var dayKey in sortedDays) ...[
                // Add spacing before each day group (except the first one)
                if (dayKey != sortedDays.first) 24.verticalSpace,
                // Day header
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    _getDayLabel(dayKey, isArabic),
                    style: context.bodyLarge.copyWith(
                      height: 1.1,
                      fontWeight: FontWeightM.semiBold,
                      color: context.colorScheme.surface.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                ),
                12.verticalSpace,
                // Plans for this day wrapped in a Column with smaller spacing
                Column(
                  spacing: 8.w,
                  children: [
                    for (var i in plansByDays[dayKey]!)
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
                          ? widget.regionCurrency!
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
                        dataAmount: dataAmount,
                        isUnlimited: isUnlimited,
                        isSelected: state.selectedPlanIndex == i,
                        showDays: false,
                        badge: widget.type.isRegional
                            ? null
                            : state.countryPlans[i].displayBadge(context.locale),
                        onChange: (value) {
                          PlainInformationBottomSheet.show(
                            context,
                            networkDtoList: widget.type.isRegional
                                ? state.regionalPlans[i].networkDtoList
                                : state.countryPlans[i].networkDtoList,
                            note: widget.type.isRegional
                                ? state.regionalPlans[i].displayNote(
                                    context.locale,
                                  )
                                : state.countryPlans[i].displayNote(
                                    context.locale,
                                  ),
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
                            buttonLabel: Translation.checkout.tr,
                            onButtonTapped: () {
                              if (!instance<AppPreferences>()
                                  .isUserRegistered) {
                                LastSelectedPlanDetails = PlanDetails(
                                  coveredCountries: widget.type.isRegional
                                      ? state.regionalPlans[i].coveredCountries
                                      : state.countryPlans[i].coveredCountries,
                                  packageId: widget.type.isRegional
                                      ? state.regionalPlans[i].id
                                      : state.countryPlans[i].id,
                                  esimType: widget.type,
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
                                  networkDtoList: widget.type.isRegional
                                      ? state.regionalPlans[i].networkDtoList
                                      : state.countryPlans[i].networkDtoList,
                                  note: widget.type.isRegional
                                      ? state.regionalPlans[i].displayNote(
                                          context.locale,
                                        )
                                      : state.countryPlans[i].displayNote(
                                          context.locale,
                                        ),
                                  buttonLabel: Translation.checkout.tr,
                                  countryCode: widget.countryCode,
                                  regionCode: widget.regionCode,
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
                                  'package-id': widget.type.isRegional
                                      ? state.regionalPlans[i].id
                                      : state.countryPlans[i].id,
                                  'esim-type': widget.type,
                                  'country-code': widget.countryCode,
                                  'region-code': widget.regionCode,
                                },
                              );
                            },
                          );
                          context.read<EsimDetailsBloc>().add(
                            SelectPlanEvent(index: i),
                          );
                        },
                      );
                    },
                  ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget plansInfo() {
    return FaqExpansionTileCard(
      titleWidget: RichText(
        text: TextSpan(
          style: context.bodyLarge.copyWith(height: 1.2),
          children: [
            TextSpan(
              text: "(${state.supportedCountriesCount})",
              style: TextStyle(color: ColorM.primary),
            ),
            TextSpan(text: " "),
            TextSpan(text: Translation.supported_countries.tr),
          ],
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.w),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 10.w,
                  runSpacing: 10.w,
                  children: [
                    for (var i = 0; i < state.supportedCountriesCount; i++) ...[
                      Row(
                        spacing: 4.w,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomCachedImage(
                            imageUrl: state.supportedCountries[i].flag,
                            width: 14.w,
                            height: 14.w,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          Text(
                            state.supportedCountries[i].name(context.locale),
                            style: context.labelSmall.copyWith(height: 1.2),
                          ),

                          2.horizontalSpace,
                          if (i != state.supportedCountriesCount - 1)
                            Container(
                              width: 1.w,
                              height: 14.w,
                              color: context.colorScheme.surface.withValues(
                                alpha: .5,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Future<void> afterLayout(BuildContext context) async {
    if (widget.type.isRegional) {
      context.read<EsimDetailsBloc>().add(
        GetRegionPlansEvent(regionCode: widget.regionCode!),
      );
    } else if (widget.type.isCountries) {
      context.read<EsimDetailsBloc>().add(
        GetCountryPlansEvent(countryCode: widget.countryCode!),
      );
    }
  }
}

class CountryfCard extends StatelessWidget {
  const CountryfCard({
    super.key,
    required ValueNotifier<double> scrollOffset,
    required this.widget,
  }) : _scrollOffset = scrollOffset;

  final ValueNotifier<double> _scrollOffset;
  final EsimDetailsView widget;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _scrollOffset,
      builder: (context, value, child) {
        String? backgroundImageUrl = widget.featuredImageUrl;
        double topPadding =
            View.of(context).padding.top / View.of(context).devicePixelRatio;

        // Calculate scroll-based effects
        double scrollFactor = (_scrollOffset.value / 200).clamp(0.0, 1.0);
        double scale = 1.0 + (scrollFactor * 0.3); // Zoom from 1.0 to 1.3
        double blur = scrollFactor * 8; // Blur from 0 to 8

        // Calculate collapsing header height
        double maxHeight = 200.w + topPadding;
        double minHeight = 120.w + topPadding;
        double currentHeight = (maxHeight - (_scrollOffset.value * 0.5)).clamp(
          minHeight,
          maxHeight,
        );

        // Calculate content scale based on scroll
        double contentScale =
            1.0 - (scrollFactor * 0.25); // Scale from 1.0 to 0.85
        return Container(
          width: double.infinity,
          height: currentHeight,
          clipBehavior: Clip.hardEdge,
          decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
              smoothness: 1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
            ),
          ),
          child: Stack(
            children: [
              // Background layer with blur (only the background image)
              if (backgroundImageUrl != null)
                Positioned.fill(
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: blur,
                      sigmaY: blur,
                      tileMode: TileMode.decal,
                    ),
                    child: Transform.scale(
                      scale: scale,
                      alignment: Alignment.center,
                      child: CustomCachedImage(
                        imageUrl: backgroundImageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                )
              else
                // Solid background when no image - similar full-width style
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: context.isDark
                            ? [Color(0xFF1A1A1A), Color(0xFF0D0D0D)]
                            : [Color(0xFFF8F8F8), Color(0xFFEFEFEF)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

              // Dark overlay (on top of blurred background)
              if (backgroundImageUrl != null)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(
                            alpha: .5 + (scrollFactor * 0.2),
                          ),
                          Colors.black.withValues(
                            alpha: .3 + (scrollFactor * 0.2),
                          ),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

              // Content layer (SHARP - NO BLUR, scales on scroll)
              Align(
                alignment: Alignment.center,
                child: Transform.scale(
                  scale: contentScale,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: topPadding + 35.w,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Flag/Icon - SHARP (always show flag for countries)
                        if (widget.type == EsimsType.country)
                          CustomCachedImage(
                            imageUrl: widget.imageUrl ?? '',
                            width: 100.w,
                            height: 32.w,
                            fit: BoxFit.contain,
                            borderRadius: BorderRadius.circular(6.r),
                          )
                        else
                          SvgPicture.asset(
                            SvgM.earth,
                            width: 40.w,
                            height: 40.w,
                            colorFilter: ColorFilter.mode(
                              backgroundImageUrl != null
                                  ? Colors.white
                                  : context.colorScheme.surface,
                              BlendMode.srcIn,
                            ),
                          ),
                        8.verticalSpace,
                        // Country Name - SHARP
                        Text(
                          widget.displayName,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.headlineSmall.copyWith(
                            height: 1.2,
                            fontWeight: FontWeightM.bold,
                            color: backgroundImageUrl != null
                                ? Colors.white
                                : context.colorScheme.surface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Floating back button - white only on dark backgrounds
              Positioned(
                top: 49.w,
                left: SizeM.pagePadding.dg,
                right: SizeM.pagePadding.dg,
                child: DefaultAppBar(
                  actionButtons: [],
                  forceWhiteArrow: widget.featuredImageUrl != null,
                ).animatedOnAppear(0, SlideDirection.down),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PlansInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final CrossAxisAlignment crossAxisAlignment;
  final bool singleLine;
  final int flex;
  const PlansInfoItem({
    super.key,
    required this.title,
    required this.value,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.singleLine = false,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      child: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          spacing: 5.w,
          children: [
            Text(
              title,
              style: context.labelMedium.copyWith(
                height: 1.2,
                fontWeight: FontWeightM.light,
                fontSize: 11.sp,
                color: context.labelMedium.color!.withValues(alpha: .5),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: singleLine
                  ? FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.labelMedium.copyWith(
                          height: 1.2,
                          fontSize: 13.sp,
                        ),
                      ),
                    )
                  : Text(
                      value,
                      softWrap: true,
                      style: context.labelMedium.copyWith(
                        height: 1.2,
                        fontSize: 13.sp,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaqExpansionTileCard extends StatefulWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget> children;
  const FaqExpansionTileCard({
    super.key,
    this.title,
    this.titleWidget,
    required this.children,
  });

  @override
  State<FaqExpansionTileCard> createState() => _FaqExpansionTileCardState();
}

class _FaqExpansionTileCardState extends State<FaqExpansionTileCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      expandedAlignment: Alignment.topLeft,
      iconColor: context.colorScheme.onSurface,
      onExpansionChanged: (value) {
        setState(() {
          isExpanded = value;
        });
      },
      trailing: Icon(
        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        size: 18.w,
        color: context.colorScheme.surface.withValues(alpha: .5),
      ),
      collapsedIconColor: context.colorScheme.surface,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: BorderSide.none,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: BorderSide.none,
      ),
      collapsedBackgroundColor: null,
      backgroundColor: Colors.transparent,

      tilePadding: EdgeInsets.symmetric(horizontal: 16.dg),
      childrenPadding:
          EdgeInsets.symmetric(horizontal: 16.dg) +
          EdgeInsets.only(bottom: 16.dg),
      title: widget.title != null
          ? Text(widget.title!, style: context.bodyLarge.copyWith(height: 1.2))
          : widget.titleWidget ?? const SizedBox.shrink(),
      children: widget.children,
    );
  }
}

class NoteCard extends StatelessWidget {
  final String message;
  const NoteCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.dg),
      margin: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      decoration: ShapeDecoration(
        shape: gradient_border_side.SmoothRectangleBorder(
          smoothness: 1,
          borderRadius: BorderRadius.circular(16.r),
          side: gradient_border_side.BorderSide(
            gradient: LinearGradient(
              colors: [
                ColorM.primary.withValues(alpha: .8),
                ColorM.secondary.withValues(alpha: .8),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            SvgM.messageText,
            width: 26.w,
            height: 26.w,
            colorFilter: ColorFilter.mode(ColorM.primary, BlendMode.srcIn),
          ),
          16.horizontalSpace,
          Expanded(
            child: Text(
              message,
              style: context.bodyMedium.copyWith(
                height: 1.2,
                color: Colors.white.withValues(alpha: .8),
              ),
            ).mask(false),
          ),
        ],
      ),
    );
  }
}
