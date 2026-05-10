import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hi_net/app/dependency_injection.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/presentation/views/checkout/bloc/checkout_bloc.dart';
import 'package:hi_net/presentation/views/checkout/view/screens/checkout_view.dart';
import 'package:hi_net/presentation/views/currency/bloc/currency_bloc.dart';
import 'package:hi_net/presentation/views/currency/view/screens/currency_view.dart';
import 'package:hi_net/presentation/views/edit_account/bloc/edit_account_bloc.dart';
import 'package:hi_net/presentation/views/edit_account/screens/views/edit_account_view.dart';
import 'package:hi_net/presentation/views/esim_details/bloc/esim_details_bloc.dart';
import 'package:hi_net/presentation/views/esim_details/view/screens/esim_details_view.dart';
import 'package:hi_net/presentation/views/help_and_support/view/screens/help_and_support_view.dart';
import 'package:hi_net/presentation/views/home/bloc/home_bloc.dart';
import 'package:hi_net/presentation/views/home/view/screens/home_view.dart';
import 'package:hi_net/presentation/views/instructions/view/screens/instructions_view.dart';
import 'package:hi_net/presentation/views/legal_and_polices/bloc/legal_and_polices_bloc.dart';
import 'package:hi_net/presentation/views/legal_and_polices/screens/views/screens/legal_and_polices_view.dart';
import 'package:hi_net/presentation/views/my_esim_details/bloc/my_esim_details_bloc.dart';
import 'package:hi_net/presentation/views/my_esim_details/view/screens/my_esim_details_view.dart';
import 'package:hi_net/presentation/views/notification/bloc/notification_bloc.dart';
import 'package:hi_net/presentation/views/notification/screens/view/notification_view.dart';
import 'package:hi_net/presentation/views/on_boarding/screens/on_boarding_view.dart';
import 'package:hi_net/presentation/views/order_history/bloc/order_history_bloc.dart';
import 'package:hi_net/presentation/views/order_history/view/screens/order_history_view.dart';
import 'package:hi_net/presentation/views/search/view/screens/search_view.dart';
import 'package:hi_net/presentation/views/share_and_win/bloc/share_and_win_bloc.dart';
import 'package:hi_net/presentation/views/share_and_win/view/screens/share_and_win_view.dart';
import 'package:hi_net/presentation/views/sign_in/bloc/sign_in_bloc.dart';
import 'package:hi_net/presentation/views/sign_in/view/screens/sign_in_view.dart';
import 'package:hi_net/presentation/views/sign_up/view/screens/sign_up_view.dart';
import 'package:hi_net/presentation/views/verify_number/view/screens/verify_number_view.dart';
import 'package:hi_net/presentation/views/wallet/bloc/wallet_bloc.dart';
import 'package:hi_net/presentation/views/wallet/view/screens/wallet_view.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/presentation/views/home/view/widgets/select_duration_bottom_sheet.dart';
import 'package:hi_net/presentation/views/search/bloc/search_bloc.dart';

import '../views/sign_up/bloc/sign_up_bloc.dart';
import '../views/splash/screens/view/splash_view.dart';
import '../views/verify_number/bloc/verify_number_bloc.dart';

enum RoutesManager {
  splash('splash/'),
  onBoarding('on-boarding/'),
  signUp('sign-up/'),
  signIn('sign-in/'),
  verifyNumber('verify-number/'),
  home('home/'),
  search('search/'),
  esimDetails('esim-details/'),
  checkout('checkout/'),
  notifications('notifications/'),
  myEsimDetails('my-esim-details/'),
  instructions('instructions/'),
  editAccount('edit-account/'),
  orderHistory('order-history/'),
  legalAndPolices('legal-and-polices/'),
  currency('currency/'),
  shareAndWin('share-and-win/'),
  wallet('wallet/'),
  helpAndSupport('help-and-support/');

  final String route;

  const RoutesManager(this.route);
}

class RoutesGeneratorManager {
  static Widget _getScreen(String? name, RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;
    return switch (RoutesManager.values.firstWhere((t) => t.route == name)) {
      RoutesManager.splash => SplashView(),
      RoutesManager.onBoarding => OnBoardingView(),
      RoutesManager.signUp => _getSignUpView(args),
      RoutesManager.signIn => _getSignInView(args),
      RoutesManager.verifyNumber => _getVerifyNumberView(args),
      RoutesManager.home => _getHomeView(args),
      RoutesManager.search => _getSearchView(args),
      RoutesManager.esimDetails => _getEsimDetailsView(args),
      RoutesManager.checkout => _getCheckoutView(args),
      RoutesManager.notifications => _getNotificationsView(args),
      RoutesManager.myEsimDetails => _getMyEsimDetailsView(args),
      RoutesManager.instructions => _getInstructionsView(args),
      RoutesManager.editAccount => _getEditAccountView(args),
      RoutesManager.orderHistory => _getOrderHistoryView(args),
      RoutesManager.legalAndPolices => _getLegalAndPolicesView(args),
      RoutesManager.currency => _getCurrencyView(args),
      RoutesManager.shareAndWin => _getShareAndWinView(args),
      RoutesManager.wallet => _getWalletView(args),
      RoutesManager.helpAndSupport => HelpAndSupportView(),
    };
  }

  static Route<dynamic> getRoute(RouteSettings settings) => PageRouteBuilder(
    settings: settings,
    transitionDuration: Duration(milliseconds: 400),
    reverseTransitionDuration: Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) =>
        _getScreen(settings.name, settings),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.fastLinearToSlowEaseIn,
      );

      return Opacity(opacity: curvedAnimation.value, child: child);
    },
  );

  static Widget _getLegalAndPolicesView(Map<String, dynamic>? args) =>
      BlocProvider(
        create: (context) => instance<LegalAndPolicesBloc>(),
        child: LegalAndPolicesView(
          slug: args?['slug'] as String?,
          pageId: args?['pageId'] as String?,
        ),
      );

  static Widget _getSignUpView(Map<String, dynamic>? args) => BlocProvider(
    create: (context) => instance<SignUpBloc>(),
    child: SignUpView(
      phoneNumber: args?['phone-number'] as String,
      countryCode: args?['country-code'] as String,
      dialCode: args?['dial-code'] as String,
    ),
  );

  static Widget _getSignInView(Map<String, dynamic>? args) => BlocProvider(
    create: (context) => instance<SignInBloc>(),
    child: SignInView(),
  );

  static Widget _getHomeView(Map<String, dynamic>? args) => BlocProvider(
    create: (context) => instance<HomeBloc>(),
    child: HomeView(),
  );

  static Widget _getNotificationsView(Map<String, dynamic>? args) =>
      BlocProvider(
        create: (context) => instance<NotificationBloc>(),
        child: NotificationView(),
      );

  static Widget _getEditAccountView(Map<String, dynamic>? args) => BlocProvider(
    create: (context) => instance<EditAccountBloc>(),
    child: EditAccountView(),
  );

  static Widget _getVerifyNumberView(Map<String, dynamic>? args) =>
      BlocProvider(
        create: (context) => instance<VerifyNumberBloc>(),
        child: VerifyNumberView(
          phoneNumber: args?['phone-number'] as String,
          countryCode: args?['country-code'] as String,
          dialCode: args?['dial-code'] as String,
          verifyType: args?['verify-type'] as VerifyType,
          channelOptions: args?['channel'] as ChannelOptions,
          availableChannelOptions:
              args?['available-channel-options'] as List<ChannelOptions>,
        ),
      );

  static Widget _getInstructionsView(Map<String, dynamic>? args) =>
      InstructionsView(
        smdpAddress: args?['smdp-address'] as String,
        activationCode: args?['activation-code'] as String,
        qrCode: args?['qr-code'] as String,
        iosInstallLink: args?['ios-install-link'] as String,
      );

  static Widget _getOrderHistoryView(Map<String, dynamic>? args) =>
      BlocProvider(
        create: (context) => instance<OrderHistoryBloc>(),
        child: OrderHistoryView(),
      );

  static Widget _getSearchView(Map<String, dynamic>? args) => BlocProvider(
    create: (context) => instance<SearchBloc>()
      ..add(
        SearchInitEvent(
          args?['initial-country'] as MarketplaceCountry?,
          args?['selected-time-num'],
          args?['selected-time-type'] as SelectDurationType? ??
              SelectDurationType.days,
        ),
      ),
    child: SearchView(
      showHistory: args?['show-history'] as bool? ?? false,
      initialCountry: args?['initial-country'] as MarketplaceCountry?,
      selectedTimeNum: args?['selected-time-num'],
      selectedTimeType:
          args?['selected-time-type'] as SelectDurationType? ??
          SelectDurationType.days,
    ),
  );

  static Widget _getEsimDetailsView(Map<String, dynamic>? args) => BlocProvider(
    create: (context) => instance<EsimDetailsBloc>(),
    child: EsimDetailsView(
      type: args?['type'] as EsimsType,
      displayName: args?['display-name'] as String,
      countryCode: args?['country-code'] as String?,
      regionCode: args?['region-code'] as String?,
      regionCurrency: args?['region-currency'] as Currency?,
      imageUrl: args?['image-url'] as String?,
      featuredImageUrl: args?['featured-image-url'] as String?,
      note: args?['note'] as String?,
    ),
  );

  static Widget _getCurrencyView(Map<String, dynamic>? args) {
    final onSelectedCurrency =
        args?['on-selected-currency'] as void Function(Currency);
    return BlocProvider(
      create: (context) => instance<CurrencyBloc>(),
      child: CurrencyView(onSuccess: onSelectedCurrency),
    );
  }

  static Widget _getShareAndWinView(Map<String, dynamic>? args) => BlocProvider(
    create: (context) => instance<ShareAndWinBloc>(),
    child: ShareAndWinView(),
  );

  static Widget _getWalletView(Map<String, dynamic>? args) => BlocProvider(
    create: (context) => instance<WalletBloc>(),
    child: WalletView(),
  );

  static Widget _getCheckoutView(Map<String, dynamic>? args) => BlocProvider(
    create: (context) => instance<CheckoutBloc>(),
    child: CheckoutView(
      packageId: args?['package-id'] as String,
      type: args?['esim-type'] as EsimsType,
      countryCode: args?['country-code'] as String?,
      regionCode: args?['region-code'] as String?,
      renewalOrderId: args?['renewal-order-id'] as String?,
    ),
  );

  static Widget _getMyEsimDetailsView(Map<String, dynamic>? args) =>
      BlocProvider(
        create: (context) => instance<MyEsimDetailsBloc>(),
        child: MyEsimDetailsView(
          orderId: args?['order-id'] as String,
          canRenew: args?['can-renew'] as bool,
        ),
      );

  // custom navigation animation
  // static Route<dynamic> getRoute(RouteSettings settings) => PageRouteBuilder(
  //       settings: settings,
  //       transitionDuration: Duration(milliseconds: 400),
  //       reverseTransitionDuration: Duration(milliseconds: 300),
  //       pageBuilder: (context, animation, secondaryAnimation) =>
  //           _getScreen(settings.name, settings),
  //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //         const begin = Offset(1, 0.0);
  //         const end = Offset.zero;
  //         final tween = Tween(begin: begin, end: end);
  //         final curvedAnimation = CurvedAnimation(
  //           parent: animation,
  //           curve: Curves.fastLinearToSlowEaseIn,
  //         );

  //         return Opacity(
  //           opacity: curvedAnimation.value,
  //           child: SlideTransition(
  //             position: tween.animate(curvedAnimation),
  //             child: child,
  //           ),
  //         );
  //       },
  //     );

  // static Route<dynamic> getRoute(RouteSettings settings) => MaterialPageRoute(
  //     builder: (_) => _getScreen(settings.name, settings), settings: settings);
}
