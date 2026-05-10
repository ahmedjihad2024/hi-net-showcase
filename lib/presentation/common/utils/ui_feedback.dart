import 'package:hi_net/presentation/common/utils/overlay_loading.dart';
import 'package:hi_net/presentation/common/utils/snackbar_helper.dart';

abstract class UiFeedback {
  void showLoading();
  Future<void> hideLoading();
  void showMessage(String message, ErrorMessage type);
}

class UiFeedbackImpl implements UiFeedback {
  @override
  Future<void> showLoading() async {
    OverlayLoading.instance.show();
  }

  @override
  Future<void> hideLoading() async {
    await OverlayLoading.instance.hide();
  }

  @override
  void showMessage(String message, ErrorMessage type) {
    SnackbarHelper.showMessage(message, type);
  }
}
