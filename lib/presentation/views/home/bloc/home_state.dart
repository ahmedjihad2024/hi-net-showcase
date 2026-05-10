part of 'home_bloc.dart';

class HomeState extends Equatable {
  final String userName;
  final String? profileImage;
  // final Currency? selectedCurrency;

  final MarketplaceCountry? selectedCountry;
  final int? selectedTimeNum;
  final SelectDurationType? selectedTimeType;

  final ReqState countryReqState;
  final String countryErrorMessage;
  final ErrorType countryErrorType;
  final int countryCount;
  final List<MarketplaceCountry> countries;

  final ReqState regionReqState;
  final String regionErrorMessage;
  final ErrorType regionErrorType;
  final List<MarketplaceRegion> regions;

  final ReqState globalReqState;
  final String globalErrorMessage;
  final ErrorType globalErrorType;
  final int globalPlansCount;
  final num globalStartFromPrice;
  final Currency? globalCurrency;
  final List<MarketplaceGlobalPlan>? globalPlans;

  final ReqState homeSlidersReqState;
  final int homeSlidersCount;
  final List<HomeSlider>? homeSliders;

  final ReqState myOrdersReqState;
  final String myOrdersErrorMessage;
  final ErrorType myOrdersErrorType;
  final List<MyOrderItem> myOrders;

  final ReqState mostRequestedCountriesReqState;
  final List<FeaturedCountry> mostRequestedCountries;

  final ReqState destinationsReqState;
  final String destinationsErrorMessage;
  final ErrorType destinationsErrorType;
  final List<MarketplaceCountrySearchItem> destinationCountries;
  final List<MarketplaceCountrySearchItem> destinationRegions;
  final List<MarketplaceGlobalPlan>? filteredGlobalPlans;
  final DestinationTap selectedDestinationTap;
  final bool isFilterApplied;

  final ReqState currentActiveEsimReqState;
  final MyOrderItem? currentActiveEsim;
  final bool hasActiveEsim;

  final String appVersion;

  final ReqState pagesReqState;
  final List<LegalPolicyItemResponse> pages;

  final UserLevel userLevel;

  final bool isLiveActivityEnabled;

  const HomeState({
    this.userName = '',
    this.countryCount = 0,
    this.countries = const [],
    this.selectedCountry,
    this.countryReqState = ReqState.loading,
    this.countryErrorMessage = '',
    this.regionReqState = ReqState.loading,
    this.regionErrorMessage = '',
    this.regions = const [],
    this.globalReqState = ReqState.loading,
    this.globalErrorMessage = '',
    this.globalPlansCount = 0,
    this.globalStartFromPrice = 0,
    this.globalCurrency,
    this.globalPlans,
    this.selectedTimeNum,
    this.selectedTimeType,
    this.profileImage,
    // this.selectedCurrency,
    this.homeSlidersReqState = ReqState.loading,
    this.homeSlidersCount = 0,
    this.homeSliders,
    this.myOrdersReqState = ReqState.loading,
    this.myOrdersErrorMessage = '',
    this.myOrders = const [],
    this.mostRequestedCountriesReqState = ReqState.loading,
    this.mostRequestedCountries = const [],
    this.destinationsReqState = ReqState.loading,
    this.destinationsErrorMessage = '',
    this.destinationCountries = const [],
    this.destinationRegions = const [],
    this.filteredGlobalPlans,
    this.selectedDestinationTap = DestinationTap.country,
    this.isFilterApplied = false,
    this.appVersion = '',
    this.currentActiveEsimReqState = ReqState.loading,
    this.currentActiveEsim,
    this.hasActiveEsim = false,
    this.countryErrorType = ErrorType.none,
    this.regionErrorType = ErrorType.none,
    this.globalErrorType = ErrorType.none,
    this.myOrdersErrorType = ErrorType.none,
    this.destinationsErrorType = ErrorType.none,
    this.pagesReqState = ReqState.loading,
    this.pages = const [],
    this.userLevel = UserLevel.bronze,
    this.isLiveActivityEnabled = false,
  });

  HomeState copyWith({
    String? userName,
    int? countryCount,
    List<MarketplaceCountry>? countries,
    MarketplaceCountry? selectedCountry,
    ReqState? countryReqState,
    String? countryErrorMessage,
    ReqState? regionReqState,
    String? regionErrorMessage,
    List<MarketplaceRegion>? regions,
    ReqState? globalReqState,
    String? globalErrorMessage,
    int? globalPlansCount,
    num? globalStartFromPrice,
    Currency? globalCurrency,
    List<MarketplaceGlobalPlan>? globalPlans,
    int? selectedTimeNum,
    SelectDurationType? selectedTimeType,
    String? profileImage,
    // Currency? selectedCurrency,
    ReqState? homeSlidersReqState,
    int? homeSlidersCount,
    List<HomeSlider>? homeSliders,
    ReqState? myOrdersReqState,
    String? myOrdersErrorMessage,
    List<MyOrderItem>? myOrders,
    ReqState? mostRequestedCountriesReqState,
    List<FeaturedCountry>? mostRequestedCountries,
    ReqState? destinationsReqState,
    String? destinationsErrorMessage,
    List<MarketplaceCountrySearchItem>? destinationCountries,
    List<MarketplaceCountrySearchItem>? destinationRegions,
    DestinationTap? selectedDestinationTap,
    bool? isFilterApplied,
    String? appVersion,
    ReqState? currentActiveEsimReqState,
    MyOrderItem? currentActiveEsim,
    bool? hasActiveEsim,
    List<MarketplaceGlobalPlan>? filteredGlobalPlans,
    ErrorType? countryErrorType,
    ErrorType? regionErrorType,
    ErrorType? globalErrorType,
    ErrorType? myOrdersErrorType,
    ErrorType? destinationsErrorType,
    ReqState? pagesReqState,
    List<LegalPolicyItemResponse>? pages,
    UserLevel? userLevel,
    bool? isLiveActivityEnabled,
  }) {
    return HomeState(
      userName: userName ?? this.userName,
      countryCount: countryCount ?? this.countryCount,
      countries: countries ?? this.countries,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      countryReqState: countryReqState ?? this.countryReqState,
      countryErrorMessage: countryErrorMessage ?? this.countryErrorMessage,
      regionReqState: regionReqState ?? this.regionReqState,
      regionErrorMessage: regionErrorMessage ?? this.regionErrorMessage,
      regions: regions ?? this.regions,
      globalReqState: globalReqState ?? this.globalReqState,
      globalErrorMessage: globalErrorMessage ?? this.globalErrorMessage,
      globalPlansCount: globalPlansCount ?? this.globalPlansCount,
      globalStartFromPrice: globalStartFromPrice ?? this.globalStartFromPrice,
      globalCurrency: globalCurrency ?? this.globalCurrency,
      globalPlans: globalPlans ?? this.globalPlans,
      selectedTimeNum: selectedTimeNum ?? this.selectedTimeNum,
      selectedTimeType: selectedTimeType ?? this.selectedTimeType,
      profileImage: profileImage ?? this.profileImage,
      // selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      homeSlidersReqState: homeSlidersReqState ?? this.homeSlidersReqState,
      homeSlidersCount: homeSlidersCount ?? this.homeSlidersCount,
      homeSliders: homeSliders ?? this.homeSliders,
      myOrdersReqState: myOrdersReqState ?? this.myOrdersReqState,
      myOrdersErrorMessage: myOrdersErrorMessage ?? this.myOrdersErrorMessage,
      myOrders: myOrders ?? this.myOrders,
      mostRequestedCountriesReqState:
          mostRequestedCountriesReqState ?? this.mostRequestedCountriesReqState,
      mostRequestedCountries:
          mostRequestedCountries ?? this.mostRequestedCountries,
      destinationsReqState: destinationsReqState ?? this.destinationsReqState,
      destinationsErrorMessage:
          destinationsErrorMessage ?? this.destinationsErrorMessage,
      destinationCountries: destinationCountries ?? this.destinationCountries,
      destinationRegions: destinationRegions ?? this.destinationRegions,
      selectedDestinationTap:
          selectedDestinationTap ?? this.selectedDestinationTap,
      isFilterApplied: isFilterApplied ?? this.isFilterApplied,
      appVersion: appVersion ?? this.appVersion,
      currentActiveEsimReqState:
          currentActiveEsimReqState ?? this.currentActiveEsimReqState,
      currentActiveEsim: currentActiveEsim ?? this.currentActiveEsim,
      hasActiveEsim: hasActiveEsim ?? this.hasActiveEsim,
      filteredGlobalPlans: filteredGlobalPlans ?? this.filteredGlobalPlans,
      countryErrorType: countryErrorType ?? this.countryErrorType,
      regionErrorType: regionErrorType ?? this.regionErrorType,
      globalErrorType: globalErrorType ?? this.globalErrorType,
      myOrdersErrorType: myOrdersErrorType ?? this.myOrdersErrorType,
      destinationsErrorType: destinationsErrorType ?? this.destinationsErrorType,
      pagesReqState: pagesReqState ?? this.pagesReqState,
      pages: pages ?? this.pages,
      userLevel: userLevel ?? this.userLevel,
      isLiveActivityEnabled: isLiveActivityEnabled ?? this.isLiveActivityEnabled,
    );
  }

  HomeState unselectCountry() {
    return HomeState(
      userName: userName,
      countryCount: countryCount,
      countries: countries,
      selectedCountry: null,
      countryReqState: countryReqState,
      countryErrorMessage: countryErrorMessage,
      regionReqState: regionReqState,
      regionErrorMessage: regionErrorMessage,
      regions: regions,
      globalReqState: globalReqState,
      globalErrorMessage: globalErrorMessage,
      globalPlansCount: globalPlansCount,
      globalStartFromPrice: globalStartFromPrice,
      globalCurrency: globalCurrency,
      globalPlans: globalPlans,
      selectedTimeNum: selectedTimeNum,
      selectedTimeType: selectedTimeType,
      profileImage: profileImage,
      // selectedCurrency: selectedCurrency,
      homeSlidersReqState: homeSlidersReqState,
      homeSlidersCount: homeSlidersCount,
      homeSliders: homeSliders,
      myOrdersReqState: myOrdersReqState,
      myOrdersErrorMessage: myOrdersErrorMessage,
      myOrders: myOrders,
      mostRequestedCountriesReqState: mostRequestedCountriesReqState,
      mostRequestedCountries: mostRequestedCountries,
      destinationsReqState: destinationsReqState,
      destinationsErrorMessage: destinationsErrorMessage,
      destinationCountries: destinationCountries,
      destinationRegions: destinationRegions,
      selectedDestinationTap: selectedDestinationTap,
      isFilterApplied: isFilterApplied,
      appVersion: appVersion,
      currentActiveEsimReqState: currentActiveEsimReqState,
      currentActiveEsim: currentActiveEsim,
      hasActiveEsim: hasActiveEsim,
      filteredGlobalPlans: filteredGlobalPlans,
      countryErrorType: countryErrorType,
      regionErrorType: regionErrorType,
      globalErrorType: globalErrorType,
      myOrdersErrorType: myOrdersErrorType,
      destinationsErrorType: destinationsErrorType,
      pagesReqState: pagesReqState,
      pages: pages,
      userLevel: userLevel,
      isLiveActivityEnabled: isLiveActivityEnabled,
    );
  }

  HomeState unselectDuration() {
    return HomeState(
      userName: userName,
      countryCount: countryCount,
      countries: countries,
      selectedCountry: selectedCountry,
      countryReqState: countryReqState,
      countryErrorMessage: countryErrorMessage,
      regionReqState: regionReqState,
      regionErrorMessage: regionErrorMessage,
      regions: regions,
      globalReqState: globalReqState,
      globalErrorMessage: globalErrorMessage,
      globalPlansCount: globalPlansCount,
      globalStartFromPrice: globalStartFromPrice,
      globalCurrency: globalCurrency,
      globalPlans: globalPlans,
      selectedTimeNum: null,
      selectedTimeType: null,
      profileImage: profileImage,
      // selectedCurrency: selectedCurrency,
      homeSlidersReqState: homeSlidersReqState,
      homeSlidersCount: homeSlidersCount,
      homeSliders: homeSliders,
      myOrdersReqState: myOrdersReqState,
      myOrdersErrorMessage: myOrdersErrorMessage,
      myOrders: myOrders,
      mostRequestedCountriesReqState: mostRequestedCountriesReqState,
      mostRequestedCountries: mostRequestedCountries,
      destinationsReqState: destinationsReqState,
      destinationsErrorMessage: destinationsErrorMessage,
      destinationCountries: destinationCountries,
      destinationRegions: destinationRegions,
      selectedDestinationTap: selectedDestinationTap,
      isFilterApplied: isFilterApplied,
      appVersion: appVersion,
      currentActiveEsimReqState: currentActiveEsimReqState,
      currentActiveEsim: currentActiveEsim,
      hasActiveEsim: hasActiveEsim,
      filteredGlobalPlans: filteredGlobalPlans,
      countryErrorType: countryErrorType,
      regionErrorType: regionErrorType,
      globalErrorType: globalErrorType,
      myOrdersErrorType: myOrdersErrorType,
      destinationsErrorType: destinationsErrorType,
      pagesReqState: pagesReqState,
      pages: pages,
      userLevel: userLevel,
      isLiveActivityEnabled: isLiveActivityEnabled,
    );
  }

  @override
  List<Object?> get props => [
    userName,
    countryCount,
    countries,
    selectedCountry,
    countryReqState,
    countryErrorMessage,
    regionReqState,
    regionErrorMessage,
    regions,
    globalReqState,
    globalErrorMessage,
    globalPlansCount,
    globalStartFromPrice,
    globalCurrency,
    globalPlans,
    selectedTimeNum,
    selectedTimeType,
    profileImage,
    // selectedCurrency,
    homeSlidersReqState,
    homeSlidersCount,
    homeSliders,
    myOrdersReqState,
    myOrdersErrorMessage,
    myOrders,
    mostRequestedCountriesReqState,
    mostRequestedCountries,
    destinationsReqState,
    destinationsErrorMessage,
    destinationCountries,
    destinationRegions,
    selectedDestinationTap,
    isFilterApplied,
    appVersion,
    currentActiveEsimReqState,
    currentActiveEsim,
    hasActiveEsim,
    filteredGlobalPlans,
    countryErrorType,
    regionErrorType,
    globalErrorType,
    myOrdersErrorType,
    destinationsErrorType,
    pagesReqState,
    pages,
    userLevel,
    isLiveActivityEnabled,
  ];
}
