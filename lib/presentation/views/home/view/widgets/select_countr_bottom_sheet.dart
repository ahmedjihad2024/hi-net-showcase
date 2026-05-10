import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/app/user_messages.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:hi_net/presentation/common/ui_components/custom_form_field/custom_form_field.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/common/ui_components/error_widget.dart';
import 'package:hi_net/presentation/common/utils/state_render.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/home/view/widgets/country_item.dart';
import 'package:hi_net/presentation/views/home/view/widgets/select_duration_bottom_sheet.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dartz/dartz.dart' as z;
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/domain/usecase/base.dart';
import 'package:hi_net/domain/usecase/get_marketplace_countries_usecase.dart';

class SelectCountrBottomSheet extends StatefulWidget {
  const SelectCountrBottomSheet({
    super.key,
    this.isFromSearch = false,
    required this.onSelect,
    this.initialCountry,
    required this.onClickNextTimeSheet,
    this.selectedTimeNum = 0,
    this.selectedTimeType = SelectDurationType.days,
  });
  final bool isFromSearch;
  final MarketplaceCountry? initialCountry;
  final void Function(MarketplaceCountry? country) onSelect;
  final void Function(int? timeNum, SelectDurationType? type)
  onClickNextTimeSheet;
  final int selectedTimeNum;
  final SelectDurationType selectedTimeType;

  @override
  State<SelectCountrBottomSheet> createState() =>
      _SelectCountrBottomSheetState();

  static Future<void> show(
    BuildContext context, {
    bool isFromSearch = false,
    required void Function(MarketplaceCountry? country) onSelect,
    MarketplaceCountry? initialCountry,
    int selectedTimeNum = 0,
    SelectDurationType selectedTimeType = SelectDurationType.days,
    required void Function(int? timeNum, SelectDurationType? type)
    onClickNextTimeSheet,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => SelectCountrBottomSheet(
        isFromSearch: isFromSearch,
        onSelect: onSelect,
        initialCountry: initialCountry,
        selectedTimeNum: selectedTimeNum,
        selectedTimeType: selectedTimeType,
        onClickNextTimeSheet: onClickNextTimeSheet,
      ),
    );
  }
}

class CountriesSheetState {
  final ReqState reqState;
  final String errorMessage;
  final int countryCount;
  final List<MarketplaceCountry> countries;
  final ErrorType errorType;

  CountriesSheetState({
    this.reqState = ReqState.loading,
    this.errorMessage = '',
    this.countryCount = 0,
    this.countries = const [],
    this.errorType = ErrorType.none,
  });

  CountriesSheetState copyWith({
    ReqState? reqState,
    String? errorMessage,
    int? countryCount,
    List<MarketplaceCountry>? countries,
    ErrorType? errorType,
  }) {
    return CountriesSheetState(
      reqState: reqState ?? this.reqState,
      errorMessage: errorMessage ?? this.errorMessage,
      countryCount: countryCount ?? this.countryCount,
      countries: countries ?? this.countries,
      errorType: errorType ?? this.errorType,
    );
  }
}

class CountriesSheetCubit extends Cubit<CountriesSheetState> {
  CountriesSheetCubit(this._instance) : super(CountriesSheetState());

  final GetIt _instance;

  static List<MarketplaceCountry>? _cachedCountries;
  static int _cachedCount = 0;

  Future<void> fetch() async {
    if (_cachedCountries != null && _cachedCountries!.isNotEmpty) {
      emit(
        state.copyWith(
          reqState: ReqState.success,
          countries: _cachedCountries,
          countryCount: _cachedCount,
        ),
      );
      return;
    }
    emit(state.copyWith(reqState: ReqState.loading));
    z.Either<Failure, MarketplaceCountriesResponse> response =
        await _instance<GetMarketplaceCountriesUseCase>().execute(NoParams());
    await response.fold(
      (failure) {
        emit(
          state.copyWith(
            reqState: ReqState.error,
            errorMessage: failure.userMessage,
            errorType: failure is NoInternetConnection
                ? ErrorType.noInternet
                : ErrorType.none,
          ),
        );
      },
      (res) async {
        _cachedCountries = res.data ?? const [];
        _cachedCount = res.count ?? 0;
        emit(
          state.copyWith(
            reqState: _cachedCountries!.isEmpty
                ? ReqState.empty
                : ReqState.success,
            countries: _cachedCountries,
            countryCount: _cachedCount,
          ),
        );
      },
    );
  }

  static void clearCache() {
    _cachedCountries = null;
    _cachedCount = 0;
  }
}

class _SelectCountrBottomSheetState extends State<SelectCountrBottomSheet> {
  TextEditingController searchController = TextEditingController();

  late ValueNotifier<MarketplaceCountry?> selectedCountry;

  @override
  void initState() {
    super.initState();
    selectedCountry = ValueNotifier(widget.initialCountry);
    searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(covariant SelectCountrBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // final query = searchController.text.toLowerCase();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .75.sh,
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
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.only(
                top: 12.w,
                bottom: 8.w,
                left: 12.w,
                right: 12.w,
              ),
              decoration: ShapeDecoration(
                shape: SmoothRectangleBorder(
                  smoothness: 1,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                color: context.isDark
                    ? ColorM.primaryDark
                    : context.colorScheme.surface.withValues(alpha: 0.05),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Translation.select_country.tr,
                    style: context.titleMedium,
                  ),
                  BlocProvider(
                    create: (context) =>
                        CountriesSheetCubit(GetIt.instance)..fetch(),
                    child: BlocBuilder<CountriesSheetCubit, CountriesSheetState>(
                      builder: (context, sheetState) {
                        return ScreenState.setState(
                          reqState: sheetState.reqState,
                          loading: () {
                            return Expanded(
                              child: MyCircularProgressIndicator(),
                            );
                          },
                          error: () {
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeM.pagePadding.dg,
                                ),
                                child: MyErrorWidget(
                                  svgSize: 170.w,
                                  errorType: sheetState.errorType,
                                  onRetry: () => context
                                      .read<CountriesSheetCubit>()
                                      .fetch(),
                                  titleMessage: sheetState.errorMessage,
                                ),
                              ),
                            );
                          },
                          empty: () {
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeM.pagePadding.dg,
                                ),
                                child: MyErrorWidget(
                                  svgSize: 170.w,
                                  errorType: ErrorType.noResults,
                                  onRetry: () => context
                                      .read<CountriesSheetCubit>()
                                      .fetch(),
                                  titleMessage: sheetState.errorMessage,
                                ),
                              ),
                            );
                          },
                          online: () {
                            return Expanded(
                              child: Column(
                                children: [
                                  10.verticalSpace,
                                  searchField(),
                                  13.verticalSpace,
                                  countriesList(sheetState.countries),
                                  13.verticalSpace,
                                  nextButton(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      SelectDurationBottomSheet.show(
                                        context,
                                        isFromSearch: widget.isFromSearch,
                                        isFromSelectCountry: true,
                                        onClickNextTimeSheet:
                                            widget.onClickNextTimeSheet,
                                        selectedDays: widget.selectedTimeNum,
                                        selectedType: widget.selectedTimeType,
                                        showCountryBottomSheet:
                                            (BuildContext c) async {
                                              await SelectCountrBottomSheet.show(
                                                c,
                                                isFromSearch:
                                                    widget.isFromSearch,
                                                onSelect: widget.onSelect,
                                                selectedTimeNum:
                                                    widget.selectedTimeNum,
                                                selectedTimeType:
                                                    widget.selectedTimeType,
                                                initialCountry:
                                                    selectedCountry.value,
                                                onClickNextTimeSheet:
                                                    widget.onClickNextTimeSheet,
                                              );
                                            },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchField() {
    return NiceTextForm(
      hintText: Translation.search.tr,
      boxDecoration: ShapeDecoration(
        color: context.colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99999),
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
      activeBoxDecoration: ShapeDecoration(
        color: context.colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99999),
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
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      textStyle: context.labelLarge.copyWith(
        fontSize: context.labelLarge.fontSize!,
        fontWeight: FontWeightM.light,
      ),
      hintStyle: context.labelLarge.copyWith(
        color: context.labelLarge.color!.withValues(alpha: .8),
        fontSize: context.labelLarge.fontSize!,
        fontWeight: FontWeightM.light,
      ),
      textEditingController: searchController,
      prefixWidget: SvgPicture.asset(
        SvgM.search,
        colorFilter: ColorFilter.mode(
          context.labelLarge.color!.withValues(alpha: .8),
          BlendMode.srcIn,
        ),
        width: 16.w,
        height: 16.w,
      ),
    );
  }

  Widget countriesList(List<MarketplaceCountry> allCountries) {
    return Expanded(
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white, Colors.transparent],
            stops: [0, .75, 1],
            tileMode: TileMode.clamp,
          ).createShader(rect);
        },
        child: ValueListenableBuilder(
          valueListenable: selectedCountry,
          builder: (context, selected, child) {
            final query = searchController.text.toLowerCase();
            final filteredCountries = query.isEmpty
                ? allCountries
                : allCountries.where((element) {
                    return element
                        .displayName(context.locale)
                        .toLowerCase()
                        .contains(query);
                  }).toList();
            return ListView.separated(
              itemCount: filteredCountries.length,
              padding: EdgeInsets.only(top: 13.h, bottom: 13.h),
              separatorBuilder: (context, index) {
                return 10.verticalSpace;
              },
              itemBuilder: (context, index) {
                final country = filteredCountries[index];
                final isSelected = selected?.countryCode == country.countryCode;
                return CountryItem(
                  key: ValueKey("${country.countryCode}_$isSelected"),
                  imageUrl: country.imageUrl,
                  countryName: country.displayName(context.locale),
                  isSelected: isSelected,
                  onChange: (value) {
                    if (value) {
                      selectedCountry.value = country;
                    } else if (isSelected) {
                      selectedCountry.value = null;
                    }
                    widget.onSelect(selectedCountry.value);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget nextButton({required VoidCallback onTap}) {
    return ValueListenableBuilder(
      valueListenable: selectedCountry,
      builder: (context, selected, child) {
        // selected == null
        //       ? null
        //       :

        // selected == null
        //       ? LinearGradient(
        //           colors: [Colors.grey.shade400, Colors.grey.shade400],
        //         )
        //       :
        return CustomInkButton(
          onTap: () {
            widget.onSelect(selected);
            onTap();
          },
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
                Translation.next.tr,
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
      },
    );
  }
}
