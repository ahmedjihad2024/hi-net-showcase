import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clickpay_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_clickpay_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_clickpay_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_clickpay_bridge/PaymentSdkLocale.dart';
import 'package:flutter_clickpay_bridge/PaymentSdkTransactionClass.dart';
import 'package:flutter_clickpay_bridge/PaymentSdkTransactionType.dart';
import 'package:flutter_clickpay_bridge/flutter_clickpay_bridge.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/app/constants.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/app/getway_errors.dart';
import 'package:hi_net/app/phone_number_validator.dart';
import 'package:hi_net/app/services/app_preferences.dart';
import 'package:hi_net/app/user_messages.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/usecase/apply_promo_usecase.dart';
import 'package:hi_net/domain/usecase/base.dart';
import 'package:hi_net/domain/usecase/create_payment_usecase.dart';
import 'package:hi_net/domain/usecase/get_checkout_details_usecase.dart';
import 'package:hi_net/domain/usecase/get_marketplace_country_plans_usecase.dart';
import 'package:hi_net/domain/usecase/get_marketplace_region_plans_usecase.dart';
import 'package:hi_net/domain/usecase/get_wallet_balance_usecase.dart';
import 'package:hi_net/presentation/common/utils/snackbar_helper.dart';
import 'package:hi_net/presentation/common/utils/state_render.dart';
import 'package:hi_net/presentation/common/utils/ui_feedback.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/flavor.dart';
import '../../../common/ui_components/error_widget.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CreatePaymentUseCase createPaymentUseCase;
  GetCheckoutDetailsUseCase getCheckoutDetailsUseCase;
  GetMarketplaceCountryPlansUseCase getMarketplaceCountryPlansUseCase;
  GetMarketplaceRegionPlansUseCase getMarketplaceRegionPlansUseCase;
  GetWalletBalanceUseCase getWalletBalanceUseCase;
  ApplyPromoUseCase applyPromoUseCase;
  UiFeedback uiFeedback;
  CheckoutBloc(
    this.createPaymentUseCase,
    this.getCheckoutDetailsUseCase,
    this.getMarketplaceCountryPlansUseCase,
    this.getMarketplaceRegionPlansUseCase,
    this.getWalletBalanceUseCase,
    this.applyPromoUseCase,
    this.uiFeedback,
  ) : super(CheckoutState()) {
    on<CreateInvoiceEvent>(_onCreateInvoiceEvent);
    on<GetCheckoutDetailsEvent>(_onGetCheckoutDetailsEvent);
    on<GetCountryPlansEvent>(_onGetCountryPlansEvent);
    on<GetRegionPlansEvent>(_onGetRegionPlansEvent);
    on<ApplyPromoCodeEvent>(_onApplyPromoCodeEvent);
    on<RemovePromoCodeEvent>(_onRemovePromoCodeEvent);
    on<ToggleWalletEvent>(_onToggleWalletEvent);
    on<GetCurrentBalanceEvent>(_onGetCurrentBalance);
  }

  Future<void> _onToggleWalletEvent(
    ToggleWalletEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    bool isUsingWallet = !state.isUsingWallet;
    emit(
      state.copyWith(
        isUsingWallet: isUsingWallet,
        isPromoCodeActive: false,
        promoCode: '',
        promoCodeDiscountAmount: 0.0,
        promoCodefinalPrice: 0.0,
        showPaymentMethods:
            !(isUsingWallet &&
                ((state.total - state.walletDiscountAmount) == 0)),
      ),
    );
  }

  Future<void> _onRemovePromoCodeEvent(
    RemovePromoCodeEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(
      state.copyWith(
        isPromoCodeActive: false,
        promoCode: '',
        promoCodeDiscountAmount: 0.0,
        promoCodefinalPrice: 0.0,
        showPaymentMethods: true,
      ),
    );
  }

  Future<void> _onGetCurrentBalance(
    GetCurrentBalanceEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    await Future.doWhile(() async {
      if (isClosed) return false;
      Either<Failure, WalletBalanceResponse> response =
          await getWalletBalanceUseCase.execute(NoParams());

      if (isClosed) return false;

      bool status = await response.fold(
        (failure) {
          return !isClosed;
        },
        (res) async {
          if (res.balance > 0) {
            late double walletDiscountAmount;
            bool isAllFromWallet = false;
            if (res.balance >= state.total) {
              walletDiscountAmount = state.total;
              isAllFromWallet = true;
            } else if (res.balance < state.total) {
              walletDiscountAmount = res.balance;
              isAllFromWallet = false;
            }
            emit(
              state.copyWith(
                walletDiscountAmount: walletDiscountAmount,
                isAllFromWallet: isAllFromWallet,
                walletBalanceReqState: ReqState.success,
                isWalletAllowed: true,
              ),
            );
          } else {
            emit(
              state.copyWith(
                walletBalanceReqState: ReqState.success,
                isWalletAllowed: false,
              ),
            );
          }

          return false;
        },
      );

      if (status) await Future.delayed(const Duration(seconds: 1));

      return status;
    });
  }

  Future<void> _onApplyPromoCodeEvent(
    ApplyPromoCodeEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    uiFeedback.showLoading();
    final result = await applyPromoUseCase.execute(
      ApplyPromoRequest(
        code: event.promoCode,
        packageId: event.packageId,
        currency: state.currency,
      ),
    );

    uiFeedback.hideLoading();

    result.fold(
      (failure) {
        uiFeedback.showMessage(failure.userMessage, ErrorMessage.snackBar);
      },
      (data) {
        if (data.valid == false) {
          uiFeedback.showMessage(
            data.dataMessage ?? "NONE",
            ErrorMessage.snackBar,
          );
        } else {
          emit(
            state.copyWith(
              isPromoCodeActive: true,
              promoCode: event.promoCode,
              promoCodeDiscountAmount: data.discountAmount,
              promoCodefinalPrice: data.finalPrice,
              showPaymentMethods: !(data.finalPrice == 0),
            ),
          );
        }
      },
    );
  }

  Future<void> _onGetCheckoutDetailsEvent(
    GetCheckoutDetailsEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(reqState: ReqState.loading));
    final result = await getCheckoutDetailsUseCase.execute(event.packageId);

    result.fold(
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
      (data) {
        final checkoutData = data.data;
        emit(
          state.copyWith(
            reqState: ReqState.success,
            id: checkoutData!.package.id,
            name: checkoutData.package.name(event.locale),
            countryName: checkoutData.package.countryName(event.locale),
            dataAmount: checkoutData.package.dataAmount,
            dataUnit: checkoutData.package.dataUnit,
            days: checkoutData.package.days,
            countryCodes: checkoutData.package.countryCodes,
            isRenewable: checkoutData.package.isRenewable,
            isDaypass: checkoutData.package.isDaypass,
            isUnlimited: checkoutData.package.isUnlimited,
            imageUrl: checkoutData.package.imageUrl,
            amount: checkoutData.pricing.amount,
            vat: checkoutData.pricing.vat,
            total: checkoutData.pricing.total,
            vatRate: checkoutData.pricing.vatRate,
            currency: checkoutData.pricing.currency,
            coveredCountries: checkoutData.coveredCountries,
            isPromoCodeActive: false,
            promoCode: '',
            promoCodeDiscountAmount: 0.0,
            promoCodefinalPrice: 0.0,
          ),
        );
        add(GetCurrentBalanceEvent());
      },
    );
  }

  void _onGetCountryPlansEvent(
    GetCountryPlansEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(plansReqState: ReqState.loading));
    final result = await getMarketplaceCountryPlansUseCase.execute(
      event.countryCode,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            plansReqState: ReqState.error,
            errorMessage: failure.userMessage,
          ),
        );
      },
      (res) {
        emit(
          state.copyWith(
            plansReqState: ReqState.success,
            countryPlans: res.plans,
          ),
        );
      },
    );
  }

  void _onGetRegionPlansEvent(
    GetRegionPlansEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(plansReqState: ReqState.loading));
    final result = await getMarketplaceRegionPlansUseCase.execute(
      event.regionCode,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            plansReqState: ReqState.error,
            errorMessage: failure.userMessage,
          ),
        );
      },
      (res) {
        emit(
          state.copyWith(
            plansReqState: ReqState.success,
            regionalPlans: res.plans,
          ),
        );
      },
    );
  }

  Future<void> _onCreateInvoiceEvent(
    CreateInvoiceEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    uiFeedback.showLoading();

    final result = await createPaymentUseCase.execute(
      CreatePaymentRequest(
        channel: PaymentChannel.clickpay,
        packageId: event.packageId,
        useWallet: event.useWallet,
        promoCode: event.promoCode,
        renewOrderId: event.renewalOrderId,
      ),
    );

    uiFeedback.hideLoading();

    result.fold(
      (failure) {
        uiFeedback.showMessage(failure.userMessage, ErrorMessage.snackBar);
        debugPrint("🖐️🖐️🖐️🖐️ THE FAILURE IS $failure");
      },
      (data) {
        if (data.invoice!.invoiceStatus == 'paid') {
          event.onSuccess();
        } else {
          showClickpay(
            isDark: event.isDark,
            locale: event.locale,
            paymentMethod: event.paymentMethod,
            invoiceId: data.invoice!.invoiceId,
            ammount: data.invoice!.amountToPay,
            onSuccess: event.onSuccess,
          );
        }
      },
    );
  }

  Future<void> showClickpay({
    required bool isDark,
    required Locale locale,
    required PaymentMethod paymentMethod,
    required String invoiceId,
    required double ammount,
    required void Function() onSuccess,
  }) async {
    var userData = await instance<AppPreferences>().getUserData();
    String mobile = userData != null
        ? (userData.callingCode + userData.mobile)
        : "NONE";
    var country = userData == null
        ? null
        : CountryUtils.getCountryByDialCode(userData.callingCode);

    var billingDetails = BillingDetails(
      userData?.fullName ?? "NONE",
      userData?.email ?? "NONE@example.com",
      mobile,
      "Not important",
      country?.isoCode ?? "EG",
      "Not important",
      "Not important",
      "Not important",
    );

    var shippingDetails = ShippingDetails(
      userData?.fullName ?? "NONE",
      userData?.email ?? "NONE@example.com",
      mobile,
      "Not important",
      country?.isoCode ?? "EG",
      "Not important",
      "Not important",
      "Not important",
    );

    var configuration = PaymentSdkConfigurationDetails(
      profileId: FlavorConfig.instance.profileId,
      serverKey: FlavorConfig.instance.serverKey,
      clientKey: FlavorConfig.instance.clientKey,
      cartId: invoiceId,
      cartDescription: "Esim Invoice: $invoiceId",
      merchantName: "HiNet",
      transactionClass: PaymentSdkTransactionClass.ECOM,
      transactionType: PaymentSdkTransactionType.SALE,
      screentTitle: Translation.buy_esim_pay_now.tr,
      billingDetails: billingDetails,
      shippingDetails: shippingDetails,
      locale: locale.languageCode == "ar"
          ? PaymentSdkLocale.AR
          : PaymentSdkLocale.EN,
      amount: ammount,
      currencyCode: "SAR",
      merchantCountryCode: "SA",
      merchantApplePayIndentifier: Constants.merchantBundleId,
      iOSThemeConfigurations: IOSThemeConfigurations(
        secondaryColor: "005DFF",
        titleFontColor: "005DFF",
        primaryColor: "FFFFFF",
        secondaryFontColor: "005DFF",
        primaryFontColor: "000000",
        placeholderColor: "616161",
        strokeColor: "616161",
        strokeThinckness: 2,
        inputsCornerRadius: SizeM.commonBorderRadius.r.toInt(),
        buttonColor: "005DFF",
        buttonFontColor: "FFFFFF",
      ),
    );

    // configuration.showBillingInfo = true;
    // configuration.showShippingInfo = true;
    if (paymentMethod.isApplePay) {
      configuration.simplifyApplePayValidation = true;
    }
    if (paymentMethod.isCard) {
      await FlutterPaymentSdkBridge.startCardPayment(
        configuration,
        (event) => eventsCallBack(event, onSuccess),
      );
    } else {
      await FlutterPaymentSdkBridge.startApplePayPayment(
        configuration,
        (event) => eventsCallBack(event, onSuccess),
      );
    }
  }
}
