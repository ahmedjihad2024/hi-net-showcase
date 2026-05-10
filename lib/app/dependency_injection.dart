import 'package:get_it/get_it.dart';
import 'package:hi_net/domain/repository/repository.dart';
import 'package:hi_net/domain/usecase/login_usecase.dart';
import 'package:hi_net/domain/usecase/logout_usecase.dart';
import 'package:hi_net/domain/usecase/register_usecase.dart';
import 'package:hi_net/domain/usecase/verify_otp_login_usecase.dart';
import 'package:hi_net/domain/usecase/verify_otp_usecase.dart';
import 'package:hi_net/domain/usecase/get_marketplace_countries_usecase.dart';
import 'package:hi_net/domain/usecase/get_marketplace_country_plans_usecase.dart';
import 'package:hi_net/domain/usecase/get_marketplace_global_plans_usecase.dart';
import 'package:hi_net/domain/usecase/get_marketplace_region_plans_usecase.dart';
import 'package:hi_net/domain/usecase/get_marketplace_regions_usecase.dart';
import 'package:hi_net/domain/usecase/get_marketplace_search_usecase.dart';
import 'package:hi_net/domain/usecase/country_search_usecase.dart';
import 'package:hi_net/domain/usecase/get_legal_policies_usecase.dart';
import 'package:hi_net/domain/usecase/create_order_usecase.dart';
import 'package:hi_net/domain/usecase/get_marketplace_order_usecase.dart';
import 'package:hi_net/domain/usecase/refresh_marketplace_order_usecase.dart';
import 'package:hi_net/domain/usecase/refresh_auth_token_usecase.dart';
import 'package:hi_net/domain/usecase/get_marketplace_currencies_usecase.dart';
import 'package:hi_net/domain/usecase/get_user_usecase.dart';
import 'package:hi_net/domain/usecase/update_user_usecase.dart';
import 'package:hi_net/domain/usecase/update_user_image_usecase.dart';
import 'package:hi_net/domain/usecase/delete_user_usecase.dart';
import 'package:hi_net/domain/usecase/update_user_currency_usecase.dart';
import 'package:hi_net/domain/usecase/update_user_settings_usecase.dart';
import 'package:hi_net/domain/usecase/apply_promo_usecase.dart';
import 'package:hi_net/domain/usecase/get_my_referral_usecase.dart';
import 'package:hi_net/domain/usecase/get_notifications_usecase.dart';
import 'package:hi_net/domain/usecase/get_unread_notifications_count_usecase.dart';
import 'package:hi_net/domain/usecase/get_wallet_balance_usecase.dart';
import 'package:hi_net/domain/usecase/get_wallet_transactions_usecase.dart';
import 'package:hi_net/domain/usecase/create_payment_usecase.dart';
import 'package:hi_net/domain/usecase/get_checkout_details_usecase.dart';
import 'package:hi_net/domain/usecase/get_home_sliders_usecase.dart';
import 'package:hi_net/domain/usecase/get_order_history_usecase.dart';
import 'package:hi_net/domain/usecase/get_my_orders_usecase.dart';
import 'package:hi_net/domain/usecase/get_featured_countries_usecase.dart';
import 'package:hi_net/domain/usecase/get_min_version_usecase.dart';
import 'package:hi_net/domain/usecase/get_settings_usecase.dart';
import 'package:hi_net/domain/usecase/resend_otp_usecase.dart';
import 'package:hi_net/domain/usecase/get_renewal_options_usecase.dart';
import 'package:hi_net/presentation/common/utils/ui_feedback.dart';
import 'package:hi_net/presentation/views/checkout/bloc/checkout_bloc.dart';
import 'package:hi_net/presentation/views/currency/bloc/currency_bloc.dart';
import 'package:hi_net/presentation/views/edit_account/bloc/edit_account_bloc.dart';
import 'package:hi_net/presentation/views/esim_details/bloc/esim_details_bloc.dart';
import 'package:hi_net/presentation/views/home/bloc/home_bloc.dart';
import 'package:hi_net/presentation/views/legal_and_polices/bloc/legal_and_polices_bloc.dart';
import 'package:hi_net/presentation/views/my_esim_details/bloc/my_esim_details_bloc.dart';
import 'package:hi_net/presentation/views/notification/bloc/notification_bloc.dart';
import 'package:hi_net/presentation/views/order_history/bloc/order_history_bloc.dart';
import 'package:hi_net/presentation/views/sign_in/bloc/sign_in_bloc.dart';
import 'package:hi_net/presentation/views/sign_up/bloc/sign_up_bloc.dart';
import 'package:hi_net/presentation/views/search/bloc/search_bloc.dart';
import 'package:hi_net/presentation/views/wallet/bloc/wallet_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hi_net/app/services/app_preferences.dart';
import 'package:hi_net/data/network/api.dart';
import 'package:hi_net/data/network/dio_factory.dart';
import 'package:hi_net/data/repository/repository_impl.dart';

import 'package:hi_net/app/services/live_activity_manager.dart';

import '../presentation/views/share_and_win/bloc/share_and_win_bloc.dart';
import '../presentation/views/verify_number/bloc/verify_number_bloc.dart';

final instance = GetIt.instance;

Future initAppModules() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  instance.registerLazySingleton<AppPreferences>(
    () => AppPreferences(sharedPreferences),
  );
  instance.registerLazySingleton<LiveActivityManager>(
    () => LiveActivityManager(),
  );
  instance.registerFactory<DioFactory>(
    () => DioFactory(instance<AppPreferences>()),
  );
  instance.registerLazySingleton<UiFeedback>(() => UiFeedbackImpl());

  // ** Data
  instance.registerFactory<AppServices>(
    () => AppServices(instance<DioFactory>()),
  );
  instance.registerLazySingleton<RepositoryAbs>(
    () => Repository(instance<AppServices>()),
  );
  // **

  // ** Blocs
  instance.registerFactory<NotificationBloc>(
    () => NotificationBloc(instance<GetNotificationsUseCase>()),
  );
  instance.registerFactory<EditAccountBloc>(
    () => EditAccountBloc(instance, instance<UiFeedback>()),
  );
  instance.registerFactory<SignInBloc>(
    () => SignInBloc(instance, instance<UiFeedback>()),
  );
  instance.registerFactory<SignUpBloc>(
    () => SignUpBloc(instance, instance<UiFeedback>()),
  );
  instance.registerFactory<VerifyNumberBloc>(
    () => VerifyNumberBloc(instance, instance<UiFeedback>()),
  );
  instance.registerFactory<HomeBloc>(
    () => HomeBloc(instance, instance<UiFeedback>()),
  );
  instance.registerFactory<SearchBloc>(
    () => SearchBloc(instance, instance<UiFeedback>()),
  );
  instance.registerFactory<EsimDetailsBloc>(() => EsimDetailsBloc(instance));
  instance.registerFactory<CurrencyBloc>(
    () => CurrencyBloc(instance, instance<UiFeedback>()),
  );
  instance.registerFactory<ShareAndWinBloc>(
    () => ShareAndWinBloc(instance<GetMyReferralUseCase>()),
  );
  instance.registerFactory<WalletBloc>(
    () => WalletBloc(
      instance<GetWalletBalanceUseCase>(),
      instance<GetWalletTransactionsUseCase>(),
    ),
  );
  instance.registerFactory<MyEsimDetailsBloc>(() => MyEsimDetailsBloc());
  instance.registerFactory<CheckoutBloc>(
    () => CheckoutBloc(
      instance<CreatePaymentUseCase>(),
      instance<GetCheckoutDetailsUseCase>(),
      instance<GetMarketplaceCountryPlansUseCase>(),
      instance<GetMarketplaceRegionPlansUseCase>(),
      instance<GetWalletBalanceUseCase>(),
      instance<ApplyPromoUseCase>(),
      instance<UiFeedback>(),
    ),
  );
  instance.registerFactory<OrderHistoryBloc>(() => OrderHistoryBloc());
  instance.registerFactory<LegalAndPolicesBloc>(
    () => LegalAndPolicesBloc(instance<GetLegalPoliciesUseCase>()),
  );
  // **

  // ** Usecases
  instance.registerFactory<RegisterUseCase>(
    () => RegisterUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<LogoutUseCase>(
    () => LogoutUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<LoginUseCase>(
    () => LoginUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetMarketplaceCountriesUseCase>(
    () => GetMarketplaceCountriesUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetMarketplaceCurrenciesUseCase>(
    () => GetMarketplaceCurrenciesUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetMarketplaceCountryPlansUseCase>(
    () => GetMarketplaceCountryPlansUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetMarketplaceGlobalPlansUseCase>(
    () => GetMarketplaceGlobalPlansUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetMarketplaceRegionPlansUseCase>(
    () => GetMarketplaceRegionPlansUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetMarketplaceRegionsUseCase>(
    () => GetMarketplaceRegionsUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetMarketplaceSearchUseCase>(
    () => GetMarketplaceSearchUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<CreateOrderUseCase>(
    () => CreateOrderUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetMarketplaceOrderUseCase>(
    () => GetMarketplaceOrderUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<RefreshMarketplaceOrderUseCase>(
    () => RefreshMarketplaceOrderUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<RefreshAuthTokenUseCase>(
    () => RefreshAuthTokenUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<VerifyLoginOtpUseCase>(
    () => VerifyLoginOtpUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetUserUseCase>(
    () => GetUserUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<UpdateUserUseCase>(
    () => UpdateUserUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<UpdateUserImageUseCase>(
    () => UpdateUserImageUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<DeleteUserUseCase>(
    () => DeleteUserUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<UpdateUserCurrencyUseCase>(
    () => UpdateUserCurrencyUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<UpdateUserSettingsUseCase>(
    () => UpdateUserSettingsUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<ApplyPromoUseCase>(
    () => ApplyPromoUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetMyReferralUseCase>(
    () => GetMyReferralUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetNotificationsUseCase>(
    () => GetNotificationsUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetUnreadNotificationsCountUseCase>(
    () => GetUnreadNotificationsCountUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetWalletBalanceUseCase>(
    () => GetWalletBalanceUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetWalletTransactionsUseCase>(
    () => GetWalletTransactionsUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<CreatePaymentUseCase>(
    () => CreatePaymentUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetCheckoutDetailsUseCase>(
    () => GetCheckoutDetailsUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetHomeSlidersUseCase>(
    () => GetHomeSlidersUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetOrderHistoryUseCase>(
    () => GetOrderHistoryUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetMyOrdersUseCase>(
    () => GetMyOrdersUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetFeaturedCountriesUseCase>(
    () => GetFeaturedCountriesUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetMinVersionUseCase>(
    () => GetMinVersionUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetSettingsUseCase>(
    () => GetSettingsUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<ResendOtpUseCase>(
    () => ResendOtpUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<CountrySearchUseCase>(
    () => CountrySearchUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetLegalPoliciesUseCase>(
    () => GetLegalPoliciesUseCase(instance<RepositoryAbs>()),
  );
  instance.registerFactory<GetRenewalOptionsUseCase>(
    () => GetRenewalOptionsUseCase(instance<RepositoryAbs>()),
  );
  // **
}
