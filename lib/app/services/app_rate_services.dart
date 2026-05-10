import 'package:flutter/material.dart';
import 'package:hi_net/app/constants.dart';
import 'package:hi_net/presentation/views/checkout/view/widgets/rate_dialog.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRateServices {
  AppRateServices._internal();
  static final AppRateServices instance = AppRateServices._internal();
  factory AppRateServices() => instance;

  final InAppReview _inAppReview = InAppReview.instance;
  late SharedPreferences _prefs;
  static const String _reviewRequestedKey = "review_requested";

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isReviewRequested => _prefs.getBool(_reviewRequestedKey) ?? false;

  Future<void> setReviewRequested(bool value) async =>
      await _prefs.setBool(_reviewRequestedKey, value);

  Future<void> requestReviewIfNeeded({
    Future<void> Function()? manualDialog,
  }) async {
    if (await _inAppReview.isAvailable()) {
      try {
        await _inAppReview.requestReview();
      } catch (_) {
        manualDialog?.call();
        // await openStoreListing();
      }
    } else {
      manualDialog?.call();
      // await openStoreListing();
    }
  }

  Future<void> openStoreListing() async {
    debugPrint("Opening store listing");
    await _inAppReview.openStoreListing(appStoreId: Constants.appleId);
  }

  Future<void> reset() async => await _prefs.remove(_reviewRequestedKey);

  Future<void> showRateDialog({required BuildContext context}) async {
    await requestReviewIfNeeded(
      manualDialog: () async {
        bool? isRate = await RateDialog.show(context);
        if (isRate == true) {
          await openStoreListing();
        }
      },
    );
  }
}
