part of 'checkout_bloc.dart';

sealed class CheckoutEvent {
  const CheckoutEvent();
}

class GetCheckoutDetailsEvent extends CheckoutEvent {
  final String packageId;
  final Locale locale;
  GetCheckoutDetailsEvent({required this.packageId, required this.locale});
}

class CreateInvoiceEvent extends CheckoutEvent {
  String packageId;
  bool useWallet;
  String? promoCode;

  bool isDark;
  Locale locale;
  PaymentMethod paymentMethod;
  String? renewalOrderId;
  void Function() onSuccess;

  CreateInvoiceEvent({
    required this.packageId,
    required this.useWallet,
    required this.isDark,
    required this.locale,
    required this.paymentMethod,
    required this.onSuccess,
    this.promoCode,
    this.renewalOrderId,
  });
}


class GetCountryPlansEvent extends CheckoutEvent {
  final String countryCode;
  GetCountryPlansEvent({required this.countryCode});
}

class GetRegionPlansEvent extends CheckoutEvent {
  final String regionCode;
  GetRegionPlansEvent({required this.regionCode});
}

class ApplyPromoCodeEvent extends CheckoutEvent {
  final String promoCode;
  final String packageId;
  ApplyPromoCodeEvent({required this.promoCode, required this.packageId});
}

class RemovePromoCodeEvent extends CheckoutEvent {
  RemovePromoCodeEvent();
}

class ToggleWalletEvent extends CheckoutEvent {
  ToggleWalletEvent();
}

class GetCurrentBalanceEvent extends CheckoutEvent {
  GetCurrentBalanceEvent();
}

