import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';

import 'dio_factory.dart';

abstract class AppServicesClientAbs {
  Future<RegisterResponse> register(RegisterRequest registerRequest);
  Future<UserResponse> verifyOtp(VerifyOtpRequest verifyOtpRequest);
  Future<UserResponse> verifyLoginOtp(VerifyOtpRequest verifyOtpRequest);
  Future<BasicResponse> logout(LogoutRequest logoutRequest);
  Future<RegisterResponse> login(LoginRequest loginRequest);
  Future<GetUserResponse> getUser();
  Future<GetUserResponse> updateUser(String id, UpdateUserRequest request);
  Future<GetUserResponse> updateUserImage(UpdateUserImageRequest request);
  Future<BasicResponse> deleteUser(String id);
  Future<GetUserResponse> updateUserCurrency(UpdateUserCurrencyRequest request);
  Future<GetUserResponse> updateUserSettings(UpdateUserSettingsRequest request);
  Future<MarketplaceCountriesResponse> getMarketplaceCountries();
  Future<MarketplaceCurrenciesResponse> getMarketplaceCurrencies();
  Future<MarketplaceCountryPlansResponse> getMarketplaceCountryPlans(
    String countryCode,
  );
  Future<MarketplaceGlobalPlansResponse> getMarketplaceGlobalPlans();
  Future<MarketplaceRegionPlansResponse> getMarketplaceRegionPlans(
    String regionCode,
  );
  Future<MarketplaceRegionsResponse> getMarketplaceRegions();
  Future<MarketplaceSearchResponse> getMarketplaceSearch(
    MarketplaceSearchRequest request,
  );
  Future<MarketplaceOrderResponse> createOrder(CreateOrderRequest request);
  Future<MarketplaceOrderResponse> getMarketplaceOrder(
    String orderId, {
    String? currency,
  });
  Future<MarketplaceOrderResponse> refreshMarketplaceOrder(String orderId);
  Future<UserResponse> refreshAuth(RefreshTokenRequest request);
  Future<ApplyPromoResponse> applyPromo(ApplyPromoRequest request);
  Future<ReferralResponse> getMyReferral();
  Future<NotificationListResponse> getNotifications(NotificationParams params);
  Future<UnreadNotificationCountResponse> getUnreadNotificationsCount();
  Future<WalletBalanceResponse> getWalletBalance();
  Future<WalletTransactionsResponse> getWalletTransactions(
    WalletTransactionsParams params,
  );
  Future<CreatePaymentResponse> createPayment(
    String channel,
    CreatePaymentRequest request,
  );
  Future<CheckoutResponse> getCheckoutDetails(String packageId);
  Future<HomeSlidersResponse> getHomeSliders();
  Future<OrderHistoryResponse> getOrderHistory(OrderHistoryParams params);
  Future<MyOrdersResponse> getMyOrders(MyOrdersParams params);
  Future<FeaturedCountriesResponse> getFeaturedCountries();
  Future<MinVersionResponse> getMinVersion();
  Future<RegisterResponse> resendOtp(ResendOtpRequest request);
  Future<CountrySearchResponse> getCountrySearch(CountrySearchRequest request);
  Future<LegalPoliciesResponse> getLegalPolicies();
  Future<SettingsResponse> getSettings();
  Future<RenewalOptionsResponse> getRenewalOptions(String orderId);
}

class AppServices implements AppServicesClientAbs {
  final DioFactory _dio;

  AppServices(this._dio);

  @override
  Future<RegisterResponse> register(RegisterRequest registerRequest) async {
    final response = await _dio.request(
      "/auth/register",
      method: RequestMethod.POST,
      body: registerRequest.toJson(),
    );
    return RegisterResponse.fromJson(response.data);
  }

  @override
  Future<GetUserResponse> getUser() async {
    final response = await _dio.request("/users/me", method: RequestMethod.GET);
    return GetUserResponse.fromJson(response.data);
  }

  @override
  Future<GetUserResponse> updateUser(
    String id,
    UpdateUserRequest request,
  ) async {
    final isFormData = request.image != null;
    final body = isFormData ? request.toFormData() : request.toJson();

    final response = await _dio.request(
      "/users/me/profile",
      method: RequestMethod.PATCH,
      headers: isFormData ? {"Content-Type": "multipart/form-data"} : null,
      body: body,
    );
    return GetUserResponse.fromJson(response.data);
  }

  @override
  Future<GetUserResponse> updateUserImage(
    UpdateUserImageRequest request,
  ) async {
    final isFormData = request.image != null;
    final body = isFormData ? request.toFormData() : request.toJson();

    final response = await _dio.request(
      "/users/me/image",
      method: RequestMethod.PATCH,
      headers: isFormData ? {"Content-Type": "multipart/form-data"} : null,
      body: body,
    );
    return GetUserResponse.fromJson(response.data);
  }

  @override
  Future<BasicResponse> deleteUser(String id) async {
    final response = await _dio.request(
      "/users/$id",
      method: RequestMethod.DELETE,
    );
    return BasicResponse.fromJson(response.data);
  }

  @override
  Future<GetUserResponse> updateUserCurrency(
    UpdateUserCurrencyRequest request,
  ) async {
    final response = await _dio.request(
      "/users/me/currency",
      method: RequestMethod.PATCH,
      body: request.toJson(),
    );
    return GetUserResponse.fromJson(response.data);
  }

  @override
  Future<GetUserResponse> updateUserSettings(
    UpdateUserSettingsRequest request,
  ) async {
    final response = await _dio.request(
      "/users/me/settings",
      method: RequestMethod.PUT,
      body: request.toJson(),
    );
    return GetUserResponse.fromJson(response.data);
  }

  @override
  Future<UserResponse> verifyOtp(VerifyOtpRequest verifyOtpRequest) async {
    final response = await _dio.request(
      "/auth/verify-otp",
      method: RequestMethod.POST,
      body: verifyOtpRequest.toJson(),
    );
    return UserResponse.fromJson(response.data);
  }

  @override
  Future<BasicResponse> logout(LogoutRequest logoutRequest) async {
    final response = await _dio.request(
      "/auth/logout",
      method: RequestMethod.POST,
      body: logoutRequest.toJson(),
    );
    return BasicResponse.fromJson(response.data);
  }

  @override
  Future<RegisterResponse> login(LoginRequest loginRequest) async {
    final response = await _dio.request(
      "/auth/login",
      method: RequestMethod.POST,
      body: loginRequest.toJson(),
    );
    return RegisterResponse.fromJson(response.data);
  }

  @override
  Future<MarketplaceCurrenciesResponse> getMarketplaceCurrencies() async {
    final response = await _dio.request(
      "/marketplace/currencies",
      method: RequestMethod.GET,
    );
    return MarketplaceCurrenciesResponse.fromJson(response.data);
  }

  @override
  Future<MarketplaceCountriesResponse> getMarketplaceCountries() async {
    final response = await _dio.request(
      "/marketplace/countries",
      method: RequestMethod.GET,
    );
    return MarketplaceCountriesResponse.fromJson(response.data);
  }

  @override
  Future<MarketplaceCountryPlansResponse> getMarketplaceCountryPlans(
    String countryCode,
  ) async {
    final response = await _dio.request(
      "/marketplace/plans/country/$countryCode",
      method: RequestMethod.GET,
    );
    return MarketplaceCountryPlansResponse.fromJson(response.data);
  }

  @override
  Future<MarketplaceGlobalPlansResponse> getMarketplaceGlobalPlans() async {
    final response = await _dio.request(
      "/marketplace/plans/global",
      method: RequestMethod.GET,
    );
    return MarketplaceGlobalPlansResponse.fromJson(response.data);
  }

  @override
  Future<MarketplaceRegionPlansResponse> getMarketplaceRegionPlans(
    String regionCode,
  ) async {
    final response = await _dio.request(
      "/marketplace/plans/region/$regionCode",
      method: RequestMethod.GET,
    );
    return MarketplaceRegionPlansResponse.fromJson(response.data);
  }

  @override
  Future<MarketplaceRegionsResponse> getMarketplaceRegions() async {
    final response = await _dio.request(
      "/marketplace/plans/regions",
      method: RequestMethod.GET,
    );
    return MarketplaceRegionsResponse.fromJson(response.data);
  }

  @override
  Future<MarketplaceSearchResponse> getMarketplaceSearch(
    MarketplaceSearchRequest request,
  ) async {
    final response = await _dio.request(
      "/marketplace/plans/search",
      method: RequestMethod.GET,
      queryParameters: request.toJson(),
    );
    return MarketplaceSearchResponse.fromJson(response.data);
  }

  @override
  Future<UserResponse> verifyLoginOtp(VerifyOtpRequest verifyOtpRequest) async {
    final response = await _dio.request(
      "/auth/verify-login",
      method: RequestMethod.POST,
      body: verifyOtpRequest.toJson(),
    );
    return UserResponse.fromJson(response.data);
  }

  @override
  Future<MarketplaceOrderResponse> createOrder(
    CreateOrderRequest request,
  ) async {
    final response = await _dio.request(
      "/marketplace/orders/by-package",
      method: RequestMethod.POST,
      body: request.toJson(),
    );
    return MarketplaceOrderResponse.fromJson(response.data);
  }

  @override
  Future<MarketplaceOrderResponse> getMarketplaceOrder(
    String orderId, {
    String? currency,
  }) async {
    final response = await _dio.request(
      "/marketplace/orders/$orderId",
      method: RequestMethod.GET,
      queryParameters: currency != null ? {"currency": currency} : null,
    );
    return MarketplaceOrderResponse.fromJson(response.data);
  }

  @override
  Future<MarketplaceOrderResponse> refreshMarketplaceOrder(
    String orderId,
  ) async {
    final response = await _dio.request(
      "/marketplace/orders/$orderId/refresh",
      method: RequestMethod.POST,
    );
    return MarketplaceOrderResponse.fromJson(response.data);
  }

  @override
  Future<UserResponse> refreshAuth(RefreshTokenRequest request) async {
    final response = await _dio.request(
      "/auth/refresh",
      method: RequestMethod.POST,
      body: request.toJson(),
    );
    return UserResponse.fromJson(response.data);
  }

  @override
  Future<ApplyPromoResponse> applyPromo(ApplyPromoRequest request) async {
    final response = await _dio.request(
      "/promos/apply",
      method: RequestMethod.POST,
      body: request.toJson(),
    );
    return ApplyPromoResponse.fromJson(response.data);
  }

  @override
  Future<ReferralResponse> getMyReferral() async {
    final response = await _dio.request(
      "/promos/my-referral",
      method: RequestMethod.GET,
    );
    return ReferralResponse.fromJson(response.data);
  }

  @override
  Future<NotificationListResponse> getNotifications(
    NotificationParams params,
  ) async {
    final response = await _dio.request(
      "/notifications",
      method: RequestMethod.GET,
      queryParameters: params.toJson(),
    );
    return NotificationListResponse.fromJson(response.data);
  }

  @override
  Future<UnreadNotificationCountResponse> getUnreadNotificationsCount() async {
    final response = await _dio.request(
      "/notifications/unread-count",
      method: RequestMethod.GET,
    );
    return UnreadNotificationCountResponse.fromJson(response.data);
  }

  @override
  Future<WalletBalanceResponse> getWalletBalance() async {
    final response = await _dio.request(
      "/wallet/balance",
      method: RequestMethod.GET,
    );
    return WalletBalanceResponse.fromJson(response.data);
  }

  @override
  Future<WalletTransactionsResponse> getWalletTransactions(
    WalletTransactionsParams params,
  ) async {
    final response = await _dio.request(
      "/wallet/transactions",
      method: RequestMethod.GET,
      queryParameters: params.toJson(),
    );
    return WalletTransactionsResponse.fromJson(response.data);
  }

  @override
  Future<CreatePaymentResponse> createPayment(
    String channel,
    CreatePaymentRequest request,
  ) async {
    final response = await _dio.request(
      "/payment/$channel",
      method: RequestMethod.POST,
      body: request.toJson(),
    );
    return CreatePaymentResponse.fromJson(response.data);
  }

  @override
  Future<CheckoutResponse> getCheckoutDetails(String packageId) async {
    final response = await _dio.request(
      "/marketplace/checkout/$packageId",
      method: RequestMethod.GET,
    );
    return CheckoutResponse.fromJson(response.data);
  }

  @override
  Future<HomeSlidersResponse> getHomeSliders() async {
    final response = await _dio.request("/sliders", method: RequestMethod.GET);
    return HomeSlidersResponse.fromJson(response.data);
  }

  @override
  Future<OrderHistoryResponse> getOrderHistory(
    OrderHistoryParams params,
  ) async {
    final response = await _dio.request(
      "/marketplace/orders/history",
      method: RequestMethod.GET,
      queryParameters: params.toJson(),
    );
    return OrderHistoryResponse.fromJson(response.data);
  }

  @override
  Future<MyOrdersResponse> getMyOrders(MyOrdersParams params) async {
    final response = await _dio.request(
      "/marketplace/orders/my-orders",
      method: RequestMethod.GET,
      queryParameters: params.toJson(),
    );
    return MyOrdersResponse.fromJson(response.data);
  }

  @override
  Future<FeaturedCountriesResponse> getFeaturedCountries() async {
    final response = await _dio.request(
      "/marketplace/countries/featured",
      method: RequestMethod.GET,
    );
    return FeaturedCountriesResponse.fromJson(response.data);
  }

  @override
  Future<MinVersionResponse> getMinVersion() async {
    final response = await _dio.request(
      "/settings/min-version",
      method: RequestMethod.GET,
    );
    return MinVersionResponse.fromJson(response.data);
  }

  @override
  Future<RegisterResponse> resendOtp(ResendOtpRequest request) async {
    final response = await _dio.request(
      "/auth/resend-otp",
      method: RequestMethod.POST,
      body: request.toJson(),
    );
    return RegisterResponse.fromJson(response.data);
  }

  @override
  Future<CountrySearchResponse> getCountrySearch(
    CountrySearchRequest request,
  ) async {
    final response = await _dio.request(
      "/marketplace/countries/search",
      method: RequestMethod.GET,
      queryParameters: request.toJson(),
    );
    return CountrySearchResponse.fromJson(response.data);
  }

  @override
  Future<LegalPoliciesResponse> getLegalPolicies() async {
    final response = await _dio.request(
      "/pages",
      method: RequestMethod.GET,
    );
    return LegalPoliciesResponse.fromJson(response.data);
  }

  @override
  Future<SettingsResponse> getSettings() async {
    final response = await _dio.request("/settings", method: RequestMethod.GET);
    return SettingsResponse.fromJson(response.data);
  }

  @override
  Future<RenewalOptionsResponse> getRenewalOptions(String orderId) async {
    final response = await _dio.request(
      "/marketplace/orders/$orderId/renewal-options",
      method: RequestMethod.GET,
    );
    return RenewalOptionsResponse.fromJson(response.data);
  }
}
