import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/app/dependency_injection.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/app/services/app_preferences.dart';
import 'package:hi_net/presentation/common/ui_components/animations/animations_enum.dart';
import 'package:hi_net/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:hi_net/presentation/common/ui_components/customized_smart_refresh.dart';
import 'package:hi_net/presentation/common/ui_components/error_widget.dart';
import 'package:hi_net/presentation/common/utils/after_layout.dart';
import 'package:hi_net/presentation/common/utils/snackbar_helper.dart';
import 'package:hi_net/presentation/common/utils/state_render.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/routes_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/home/bloc/home_bloc.dart';
import 'package:hi_net/presentation/views/home/view/screens/home_view.dart';
import 'package:hi_net/presentation/views/home/view/widgets/customized_button.dart';
import 'package:hi_net/presentation/views/home/view/widgets/esims_item.dart';
import 'package:hi_net/presentation/views/home/view/widgets/sign_in_button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TapMyEsimView extends StatefulWidget {
  const TapMyEsimView({super.key});

  @override
  State<TapMyEsimView> createState() => _TapMyEsimViewState();
}

class _TapMyEsimViewState extends State<TapMyEsimView> with AfterLayout {
  final RefreshController refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (20 +
                (View.of(context).viewPadding.top /
                    View.of(context).devicePixelRatio))
            .verticalSpace,
        topAppBar().animatedOnAppear(0, SlideDirection.down),
        30.verticalSpace,
        eSimsList(),
      ],
    );
  }

  HomeState get homeState => context.read<HomeBloc>().state;

  Widget topAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Translation.my_esims.tr,
            style: context.titleMedium.copyWith(
              fontWeight: FontWeightM.semiBold,
            ),
          ),
          // notification button
          ValueListenableBuilder(
            valueListenable: context.read<HomeBloc>().unreadNotificationsCount,
            builder: (context, unreadCount, child) {
              return CustomizedButton(
                onPressed: () {
                  if (!instance<AppPreferences>().isUserRegistered) {
                    SnackbarHelper.showMessage(
                      Translation.please_sign_in.tr,
                      ErrorMessage.snackBar,
                      actions: [LoginButton(), 10.horizontalSpace],
                    );
                  } else {
                    context.read<HomeBloc>().unreadNotificationsCount.value = 0;
                    Navigator.of(
                      context,
                    ).pushNamed(RoutesManager.notifications.route);
                  }
                },
                svgImage: SvgM.notification,
                count: unreadCount,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget eSimsList() {
    if (!instance<AppPreferences>().isUserRegistered) {
      return Expanded(child: Center(child: PleaseSignInButton()));
    }
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Expanded(
          child: Container(
            color: context.colorScheme.onSurface,
            child: ScreenState.setState(
              reqState: state.myOrdersReqState,
              loading: () {
                return MyCircularProgressIndicator();
              },
              error: () {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeM.pagePadding.dg,
                  ),
                  child: MyErrorWidget(
                    errorType: state.myOrdersErrorType,
                    onRetry: () {
                      context.read<HomeBloc>().add(GetOrderEvent(true));
                    },
                    titleMessage: state.myOrdersErrorMessage,
                  ),
                );
              },
              empty: () {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeM.pagePadding.dg,
                  ),
                  child: MyErrorWidget(
                    errorType: ErrorType.noEsim,
                    retryText: Translation.explore_esims.tr,
                    onRetry: () {
                      BOTTOM_NAV_BAR_SELECTED_TAB.value = 0;
                      BOTTOM_NAV_BAR_SLIDER_CONTROLLER.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                      // context.read<HomeBloc>().add(GetOrderEvent(true));
                    },
                    titleMessage: state.myOrdersErrorMessage,
                  ),
                );
              },
              online: () {
                return CustomizedSmartRefresh(
                  controller: context.read<HomeBloc>().orderRefreshController,
                  onRefresh: () async {
                    context.read<HomeBloc>().add(GetOrderEvent(true));
                  },
                  enableLoading: true,
                  onLoading: () async {
                    context.read<HomeBloc>().add(GetOrderEvent(false));
                  },
                  child: ListView.separated(
                    itemCount: state.myOrders.length,
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg) +
                        EdgeInsets.only(
                          top: 16.w,
                          bottom: SizeM.pagePadding.dg,
                        ),
                    separatorBuilder: (context, index) {
                      return 18.verticalSpace;
                    },
                    itemBuilder: (context, index) {
                      return EsimsItem(
                        // key: ValueKey('esim-item-${state.myOrders[index].orderId}'),
                        esimStatus: state.myOrders[index].status,
                        dataAmount: state.myOrders[index].dataAmount,
                        dataUnit: state.myOrders[index].dataUnit,
                        days: state.myOrders[index].days,
                        iccid:
                            state
                                .myOrders[index]
                                .esimCards
                                .firstOrNull
                                ?.iccid ??
                            "NONE",
                        countryName: state.myOrders[index].countryNameLocale(
                          context.locale,
                        ),
                        countryFlag: state.myOrders[index].countryImage,
                        price: state.myOrders[index].price,
                        currency: state.myOrders[index].currency,
                        usagePercentage: state
                            .myOrders[index]
                            .esimCards
                            .firstOrNull
                            ?.usagePercentage,
                        dataRemainingMB: state
                            .myOrders[index]
                            .esimCards
                            .firstOrNull
                            ?.dataRemainingMB,
                        canRenew: state.myOrders[index].canRenew,
                        isUnlimited: state.myOrders[index].isUnlimited,
                        onSeeDetails: () {
                          Navigator.of(context).pushNamed(
                            RoutesManager.myEsimDetails.route,
                            arguments: {
                              'order-id': state.myOrders[index].orderId,
                              'can-renew': state.myOrders[index].canRenew,
                            },
                          );
                        },
                        onRenew: () {
                          Navigator.of(context).pushNamed(
                            RoutesManager.myEsimDetails.route,
                            arguments: {
                              'order-id': state.myOrders[index].orderId,
                              'can-renew': state.myOrders[index].canRenew,
                            },
                          );
                        },
                        onActivationWay: () {
                          Navigator.of(context).pushNamed(
                            RoutesManager.instructions.route,
                            arguments: {
                              "smdp-address": state
                                  .myOrders[index]
                                  .esimCards
                                  .first
                                  .smdpAddress,
                              "activation-code": state
                                  .myOrders[index]
                                  .esimCards
                                  .first
                                  .activationCode,
                              "qr-code":
                                  state.myOrders[index].esimCards.first.qrCode,
                              "ios-install-link": state
                                  .myOrders[index]
                                  .esimCards
                                  .first
                                  .iosInstallLink,
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ).animatedOnAppear(0, SlideDirection.up),
        );
      },
    );
  }

  @override
  Future<void> afterLayout(BuildContext context) async {
    if (instance<AppPreferences>().isUserRegistered) {
      context.read<HomeBloc>().add(GetOrderEvent(true));
    }
  }
}
