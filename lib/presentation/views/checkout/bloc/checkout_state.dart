part of 'checkout_bloc.dart';

class CheckoutState extends Equatable {
  final ReqState reqState;
  final String errorMessage;
  final ErrorType errorType;

  // Individual parameters as requested
  final String id;
  final String name;
  final String countryName;
  final double dataAmount;
  final DataUnit? dataUnit;
  final int days;
  final List<String> countryCodes;
  final bool isRenewable;
  final bool isDaypass;
  final bool isUnlimited;
  final String imageUrl;
  final double amount;
  final double vat;
  final double total;
  final double vatRate;
  final String currency;
  final List<CoveredCountry> coveredCountries;

  final ReqState plansReqState;
  final String plansErrorMessage;
  final List<MarketplaceCountryPlan> countryPlans;
  final List<MarketplaceGlobalPlan> regionalPlans;

  final bool isPromoCodeActive;
  final String promoCode;
  final double promoCodeDiscountAmount;
  final double promoCodeDiscountPercentage;
  final double promoCodefinalPrice;

  final bool isWalletAllowed;
  final bool isUsingWallet;
  final double walletDiscountAmount;
  final bool isAllFromWallet;
  final ReqState walletBalanceReqState;

  final bool showPaymentMethods;

  double get finalPrice {
    if (isPromoCodeActive) {
      return promoCodefinalPrice;
    } else if (isUsingWallet) {
      return total - walletDiscountAmount;
    }
    return total;
  }

  const CheckoutState({
    this.reqState = ReqState.loading,
    this.errorMessage = '',
    this.id = '',
    this.name = '',
    this.countryName = '',
    this.dataAmount = 0,
    this.dataUnit,
    this.days = 0,
    this.countryCodes = const [],
    this.isRenewable = false,
    this.isDaypass = false,
    this.isUnlimited = false,
    this.imageUrl = '',
    this.amount = 0.0,
    this.vat = 0.0,
    this.total = 0.0,
    this.vatRate = 0.0,
    this.currency = '',
    this.coveredCountries = const [],
    this.plansReqState = ReqState.loading,
    this.plansErrorMessage = '',
    this.countryPlans = const [],
    this.regionalPlans = const [],
    this.isPromoCodeActive = false,
    this.promoCode = '',
    this.promoCodeDiscountAmount = 0.0,
    this.promoCodeDiscountPercentage = 0.0,
    this.promoCodefinalPrice = 0.0,
    this.isUsingWallet = false,
    this.walletDiscountAmount = 0.0,
    this.isAllFromWallet = false,
    this.walletBalanceReqState = ReqState.loading,
    this.isWalletAllowed = false,
    this.showPaymentMethods = true,
    this.errorType = ErrorType.none,
  });

  CheckoutState copyWith({
    ReqState? reqState,
    String? errorMessage,
    String? id,
    String? name,
    String? countryName,
    double? dataAmount,
    DataUnit? dataUnit,
    int? days,
    List<String>? countryCodes,
    bool? isRenewable,
    bool? isDaypass,
    bool? isUnlimited,
    String? imageUrl,
    double? amount,
    double? vat,
    double? total,
    double? vatRate,
    String? currency,
    List<CoveredCountry>? coveredCountries,
    ReqState? plansReqState,
    String? plansErrorMessage,
    List<MarketplaceCountryPlan>? countryPlans,
    List<MarketplaceGlobalPlan>? regionalPlans,
    bool? isPromoCodeActive,
    String? promoCode,
    double? promoCodeDiscountAmount,
    double? promoCodeDiscountPercentage,
    double? promoCodefinalPrice,
    bool? isUsingWallet,
    double? walletDiscountAmount,
    bool? isAllFromWallet,
    ReqState? walletBalanceReqState,
    bool? isWalletAllowed,
    bool? showPaymentMethods,
    ErrorType? errorType,
  }) {
    return CheckoutState(
      reqState: reqState ?? this.reqState,
      errorMessage: errorMessage ?? this.errorMessage,
      id: id ?? this.id,
      name: name ?? this.name,
      countryName: countryName ?? this.countryName,
      dataAmount: dataAmount ?? this.dataAmount,
      dataUnit: dataUnit ?? this.dataUnit,
      days: days ?? this.days,
      countryCodes: countryCodes ?? this.countryCodes,
      isRenewable: isRenewable ?? this.isRenewable,
      isDaypass: isDaypass ?? this.isDaypass,
      isUnlimited: isUnlimited ?? this.isUnlimited,
      imageUrl: imageUrl ?? this.imageUrl,
      amount: amount ?? this.amount,
      vat: vat ?? this.vat,
      total: total ?? this.total,
      vatRate: vatRate ?? this.vatRate,
      currency: currency ?? this.currency,
      coveredCountries: coveredCountries ?? this.coveredCountries,
      plansReqState: plansReqState ?? this.plansReqState,
      plansErrorMessage: plansErrorMessage ?? this.plansErrorMessage,
      countryPlans: countryPlans ?? this.countryPlans,
      regionalPlans: regionalPlans ?? this.regionalPlans,
      isPromoCodeActive: isPromoCodeActive ?? this.isPromoCodeActive,
      promoCode: promoCode ?? this.promoCode,
      promoCodeDiscountAmount: promoCodeDiscountAmount ?? this.promoCodeDiscountAmount,
      promoCodeDiscountPercentage: promoCodeDiscountPercentage ?? this.promoCodeDiscountPercentage,
      promoCodefinalPrice: promoCodefinalPrice ?? this.promoCodefinalPrice,
      isUsingWallet: isUsingWallet ?? this.isUsingWallet,
      walletDiscountAmount: walletDiscountAmount ?? this.walletDiscountAmount,
      isAllFromWallet: isAllFromWallet ?? this.isAllFromWallet,
      walletBalanceReqState: walletBalanceReqState ?? this.walletBalanceReqState,
      isWalletAllowed: isWalletAllowed ?? this.isWalletAllowed,
      showPaymentMethods: showPaymentMethods ?? this.showPaymentMethods,
      errorType: errorType ?? this.errorType,
    );
  }

  @override
  List<Object?> get props => [
    reqState,
    errorMessage,
    id,
    name,
    countryName,
    dataAmount,
    dataUnit,
    days,
    countryCodes,
    isRenewable,
    isDaypass,
    isUnlimited,
    imageUrl,
    amount,
    vat,
    total,
    vatRate,
    currency,
    coveredCountries,
    plansReqState,
    plansErrorMessage,
    countryPlans,
    regionalPlans,
    isPromoCodeActive,
    promoCode,
    promoCodeDiscountAmount,
    promoCodefinalPrice,  
    isUsingWallet,
    walletDiscountAmount,
    isAllFromWallet,
    walletBalanceReqState,
    isWalletAllowed,
    promoCodeDiscountPercentage,
    showPaymentMethods,
    errorType,
  ];
}
