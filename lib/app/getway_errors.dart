import 'package:flutter/widgets.dart';
import 'package:hi_net/presentation/common/utils/snackbar_helper.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';

GatewayError mapGatewayError(String? code) {
  switch (code) {
    case "G84018":
      return GatewayError.declined;
    case "310":
      return GatewayError.threeDsRejected;
    case "309":
      return GatewayError.threeDsNotSupported;
    case "313":
      return GatewayError.issuerBlocked;
    case "4":
      return GatewayError.duplicate;
    case "200":
      return GatewayError.invalidCard;
    case "206":
      return GatewayError.invalidCurrency;
    case "352":
      return GatewayError.liveNotEnabled;
    default:
      return GatewayError.unknown;
  }
}

enum GatewayError {
  declined,
  threeDsRejected,
  threeDsNotSupported,
  issuerBlocked,
  duplicate,
  invalidCard,
  invalidCurrency,
  liveNotEnabled,
  unknown,
}

enum PaymentFlowStatus { sdkError, gatewaySuccess, gatewayFailure, event }

void eventsCallBack(event, void Function() onSuccess) {
  final keys = {
    GatewayError.declined: Translation.declined,
    GatewayError.threeDsRejected: Translation.t3ds_rejected,
    GatewayError.threeDsNotSupported: Translation.t3ds_not_supported,
    GatewayError.issuerBlocked: Translation.issuer_blocked,
    GatewayError.duplicate: Translation.duplicate,
    GatewayError.invalidCard: Translation.invalid_card,
    GatewayError.invalidCurrency: Translation.invalid_currency,
    GatewayError.liveNotEnabled: Translation.live_disabled,
    GatewayError.unknown: Translation.unknown,
  }; // 69806a396f9d5888d61182ad
     // 69806a6f4e327fdac2b5da82

  String? errorMessage = Translation.unknown.tr;
  final status = event["status"];
  debugPrint("☺️☺️☺️☺️ : ${event.toString()}");

  /// 1️⃣ SDK Errors
  if (status == "error") {
    final code = event['code'].toString();

    final error = mapGatewayError(code);
    errorMessage = keys[error]!.tr;
    debugPrint("SDK Error: ${event["data"]}");
  }

  /// 2️⃣ Lifecycle Events
  if (status == "event") {
    debugPrint("Payment Event: ${event["data"]}");
    if(event["message"] == "Cancelled"){
      errorMessage = Translation.payment_canceled.tr;
    }
  }

  /// 3️⃣ Gateway Result
  if (status == "success") {
    final data = event["data"];
    final isSuccess = data["isSuccess"] == true;

    if (isSuccess) {
      errorMessage = null;
      debugPrint("Transaction Ref: ${data["transactionReference"]}");
      onSuccess();
    } else {
      final code = data["paymentResult"]?["responseCode"];
      final error = mapGatewayError(code);
      errorMessage = keys[error]!.tr;
      debugPrint("Gateway Error Code: $code");
    }
  }
  if (errorMessage != null) {
    SnackbarHelper.showMessage(errorMessage, ErrorMessage.snackBar);
  }
}
