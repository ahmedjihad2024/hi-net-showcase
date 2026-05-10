import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/error_handler.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/repository/repository.dart';

import '../network/api.dart';
import '../request/request.dart';

class Repository implements RepositoryAbs {
  final AppServices _appServices;

  Repository(this._appServices);

  @override
  Future<Either<Failure, RegisterResponse>> register(
    RegisterRequest registerRequest,
  ) async {
    return await fastHandler(
      request: () => _appServices.register(registerRequest),
    );
  }

  @override
  Future<Either<Failure, UserResponse>> verifyOtp(
    VerifyOtpRequest verifyOtpRequest,
  ) async {
    return await fastHandler(
      request: () => _appServices.verifyOtp(verifyOtpRequest),
    );
  }

  @override
  Future<Either<Failure, UserResponse>> verifyLoginOtp(
    VerifyOtpRequest verifyOtpRequest,
  ) async {
    return await fastHandler(
      request: () => _appServices.verifyLoginOtp(verifyOtpRequest),
    );
  }

  @override
  Future<Either<Failure, BasicResponse>> logout(
    LogoutRequest logoutRequest,
  ) async {
    return await fastHandler(request: () => _appServices.logout(logoutRequest));
  }

  @override
  Future<Either<Failure, RegisterResponse>> login(
    LoginRequest loginRequest,
  ) async {
    return await fastHandler(request: () => _appServices.login(loginRequest));
  }

  @override
  Future<Either<Failure, GetUserResponse>> getUser() async {
    return await fastHandler(request: () => _appServices.getUser());
  }

  @override
  Future<Either<Failure, GetUserResponse>> updateUser(
    String id,
    UpdateUserRequest request,
  ) async {
    return await fastHandler(
      request: () => _appServices.updateUser(id, request),
    );
  }

  @override
  Future<Either<Failure, GetUserResponse>> updateUserImage(
    UpdateUserImageRequest request,
  ) async {
    return await fastHandler(
      request: () => _appServices.updateUserImage(request),
    );
  }

  @override
  Future<Either<Failure, BasicResponse>> deleteUser(String id) async {
    return await fastHandler(request: () => _appServices.deleteUser(id));
  }

  @override
  Future<Either<Failure, GetUserResponse>> updateUserCurrency(
    UpdateUserCurrencyRequest request,
  ) async {
    return await fastHandler(
      request: () => _appServices.updateUserCurrency(request),
    );
  }

  @override
  Future<Either<Failure, GetUserResponse>> updateUserSettings(
    UpdateUserSettingsRequest request,
  ) async {
    return await fastHandler(
      request: () => _appServices.updateUserSettings(request),
    );
  }

  @override
  Future<Either<Failure, MarketplaceCurrenciesResponse>>
  getMarketplaceCurrencies() async {
    return await fastHandler(
      request: () => _appServices.getMarketplaceCurrencies(),
    );
  }

  @override
  Future<Either<Failure, MarketplaceCountriesResponse>>
  getMarketplaceCountries() async {
    return await fastHandler(
      request: () => _appServices.getMarketplaceCountries(),
    );
  }

  @override
  Future<Either<Failure, MarketplaceCountryPlansResponse>>
  getMarketplaceCountryPlans(String countryCode) async {
    return await fastHandler(
      request: () => _appServices.getMarketplaceCountryPlans(countryCode),
    );
  }

  @override
  Future<Either<Failure, MarketplaceGlobalPlansResponse>>
  getMarketplaceGlobalPlans() async {
    return await fastHandler(
      request: () => _appServices.getMarketplaceGlobalPlans(),
    );
  }

  @override
  Future<Either<Failure, MarketplaceRegionPlansResponse>>
  getMarketplaceRegionPlans(String regionCode) async {
    return await fastHandler(
      request: () => _appServices.getMarketplaceRegionPlans(regionCode),
    );
  }

  @override
  Future<Either<Failure, MarketplaceRegionsResponse>>
  getMarketplaceRegions() async {
    return await fastHandler(
      request: () => _appServices.getMarketplaceRegions(),
    );
  }

  @override
  Future<Either<Failure, MarketplaceSearchResponse>> getMarketplaceSearch(
    MarketplaceSearchRequest request,
  ) async {
    return await fastHandler(
      request: () => _appServices.getMarketplaceSearch(request),
    );
  }

  @override
  Future<Either<Failure, MarketplaceOrderResponse>> createOrder(
    CreateOrderRequest request,
  ) async {
    return await fastHandler(request: () => _appServices.createOrder(request));
  }

  @override
  Future<Either<Failure, MarketplaceOrderResponse>> getMarketplaceOrder(
    String orderId, {
    String? currency,
  }) async {
    return await fastHandler(
      request: () =>
          _appServices.getMarketplaceOrder(orderId, currency: currency),
    );
  }

  @override
  Future<Either<Failure, MarketplaceOrderResponse>> refreshMarketplaceOrder(
    String orderId,
  ) async {
    return await fastHandler(
      request: () => _appServices.refreshMarketplaceOrder(orderId),
    );
  }

  @override
  Future<Either<Failure, UserResponse>> refreshAuth(
    RefreshTokenRequest request,
  ) async {
    return await fastHandler(request: () => _appServices.refreshAuth(request));
  }

  @override
  Future<Either<Failure, ApplyPromoResponse>> applyPromo(
    ApplyPromoRequest request,
  ) async {
    return await fastHandler(request: () => _appServices.applyPromo(request));
  }

  @override
  Future<Either<Failure, ReferralResponse>> getMyReferral() async {
    return await fastHandler(request: () => _appServices.getMyReferral());
  }

  @override
  Future<Either<Failure, NotificationListResponse>> getNotifications(
    NotificationParams params,
  ) async {
    return await fastHandler(
      request: () => _appServices.getNotifications(params),
    );
  }

  @override
  Future<Either<Failure, UnreadNotificationCountResponse>>
  getUnreadNotificationsCount() async {
    return await fastHandler(
      request: () => _appServices.getUnreadNotificationsCount(),
    );
  }

  @override
  Future<Either<Failure, WalletBalanceResponse>> getWalletBalance() async {
    return await fastHandler(request: () => _appServices.getWalletBalance());
  }

  @override
  Future<Either<Failure, WalletTransactionsResponse>> getWalletTransactions(
    WalletTransactionsParams params,
  ) async {
    return await fastHandler(
      request: () => _appServices.getWalletTransactions(params),
    );
  }

  @override
  Future<Either<Failure, CreatePaymentResponse>> createPayment(
    String channel,
    CreatePaymentRequest request,
  ) async {
    return await fastHandler(
      request: () => _appServices.createPayment(channel, request),
    );
  }

  @override
  Future<Either<Failure, CheckoutResponse>> getCheckoutDetails(
    String packageId,
  ) async {
    return await fastHandler(
      request: () => _appServices.getCheckoutDetails(packageId),
    );
  }

  @override
  Future<Either<Failure, HomeSlidersResponse>> getHomeSliders() async {
    return await fastHandler(request: () => _appServices.getHomeSliders());
  }

  @override
  Future<Either<Failure, OrderHistoryResponse>> getOrderHistory(
    OrderHistoryParams params,
  ) async {
    return await fastHandler(
      request: () => _appServices.getOrderHistory(params),
    );
  }

  @override
  Future<Either<Failure, MyOrdersResponse>> getMyOrders(
    MyOrdersParams params,
  ) async {
    return await fastHandler(request: () => _appServices.getMyOrders(params));
  }

  @override
  Future<Either<Failure, FeaturedCountriesResponse>>
  getFeaturedCountries() async {
    return await fastHandler(
      request: () => _appServices.getFeaturedCountries(),
    );
  }

  @override
  Future<Either<Failure, MinVersionResponse>> getMinVersion() async {
    return await fastHandler(request: () => _appServices.getMinVersion());
  }

  @override
  Future<Either<Failure, RegisterResponse>> resendOtp(
    ResendOtpRequest request,
  ) async {
    return await fastHandler(request: () => _appServices.resendOtp(request));
  }

  @override
  Future<Either<Failure, CountrySearchResponse>> getCountrySearch(
    CountrySearchRequest request,
  ) async {
    return await fastHandler(
      request: () => _appServices.getCountrySearch(request),
    );
  }

  @override
  Future<Either<Failure, LegalPoliciesResponse>> getLegalPolicies() async {
    return await fastHandler(request: () => _appServices.getLegalPolicies());
  }

  @override
  Future<Either<Failure, SettingsResponse>> getSettings() async {
    return await fastHandler(request: () => _appServices.getSettings());
  }

  @override
  Future<Either<Failure, RenewalOptionsResponse>> getRenewalOptions(
    String orderId,
  ) async {
    return await fastHandler(
      request: () => _appServices.getRenewalOptions(orderId),
    );
  }
}
