part of 'esim_details_bloc.dart';

class EsimDetailsState extends Equatable {
  final ReqState reqState;
  final String errorMessage;
  final List<MarketplaceCountryPlan> countryPlans;
  final List<MarketplaceGlobalPlan> regionalPlans;
  final int plansCount;
  final int selectedPlanIndex;
  final int supportedCountriesCount;
  final List<CoveredCountry> supportedCountries;
  final ErrorType errorType;

  const EsimDetailsState({
    this.reqState = ReqState.loading,
    this.errorMessage = '',
    this.countryPlans = const [],
    this.regionalPlans = const [],
    this.plansCount = 0,
    this.selectedPlanIndex = -1,
    this.supportedCountriesCount = 0,
    this.supportedCountries = const [],
    this.errorType = ErrorType.none,
  });

  EsimDetailsState copyWith({
    ReqState? reqState,
    String? errorMessage,
    List<MarketplaceCountryPlan>? countryPlans,
    List<MarketplaceGlobalPlan>? regionalPlans,
    int? plansCount,
    int? selectedPlanIndex,
    int? supportedCountriesCount,
    List<CoveredCountry>? supportedCountries,
    ErrorType? errorType,
  }) {
    return EsimDetailsState(
      reqState: reqState ?? this.reqState,
      errorMessage: errorMessage ?? this.errorMessage,
      countryPlans: countryPlans ?? this.countryPlans,
      regionalPlans: regionalPlans ?? this.regionalPlans,
      plansCount: plansCount ?? this.plansCount,
      selectedPlanIndex: selectedPlanIndex ?? this.selectedPlanIndex,
      supportedCountriesCount:
          supportedCountriesCount ?? this.supportedCountriesCount,
      supportedCountries: supportedCountries ?? this.supportedCountries,
      errorType: errorType ?? this.errorType,
    );
  }

  @override
  List<Object?> get props => [
    reqState,
    errorMessage,
    countryPlans,
    regionalPlans,
    plansCount,
    selectedPlanIndex,
    supportedCountriesCount,
    supportedCountries,
    errorType,
  ];
}
