import 'package:dartz/dartz.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';

import '../../data/request/request.dart';
import '../../data/responses/responses.dart';

abstract class RepositoryAbs {
  Future<Either<Failure, RegisterResponse>> register(
    RegisterRequest registerRequest,
  );
  Future<Either<Failure, UserResponse>> verifyOtp(
    VerifyOtpRequest verifyOtpRequest,
  );
  Future<Either<Failure, BasicResponse>> logout(LogoutRequest logoutRequest);
  Future<Either<Failure, RegisterResponse>> login(LoginRequest loginRequest);
  Future<Either<Failure, UserResponse>> verifyLoginOtp(
    VerifyOtpRequest verifyOtpRequest,
  );
  Future<Either<Failure, GetUserResponse>> getUser();
  Future<Either<Failure, GetUserResponse>> updateUser(
    String id,
    UpdateUserRequest request,
  );
  Future<Either<Failure, GetUserResponse>> updateUserImage(
    UpdateUserImageRequest request,
  );
  Future<Either<Failure, BasicResponse>> deleteUser(String id);
  Future<Either<Failure, GetUserResponse>> updateUserCurrency(
    UpdateUserCurrencyRequest request,
  );
  Future<Either<Failure, GetUserResponse>> updateUserSettings(
    UpdateUserSettingsRequest request,
  );
  Future<Either<Failure, MarketplaceCountriesResponse>>
  getMarketplaceCountries();
  Future<Either<Failure, MarketplaceCurrenciesResponse>>
  getMarketplaceCurrencies();
  Future<Either<Failure, MarketplaceCountryPlansResponse>>
  getMarketplaceCountryPlans(String countryCode);
  Future<Either<Failure, MarketplaceGlobalPlansResponse>>
  getMarketplaceGlobalPlans();
  Future<Either<Failure, MarketplaceRegionPlansResponse>>
  getMarketplaceRegionPlans(String regionCode);
  Future<Either<Failure, MarketplaceRegionsResponse>> getMarketplaceRegions();
  Future<Either<Failure, MarketplaceSearchResponse>> getMarketplaceSearch(
    MarketplaceSearchRequest request,
  );
  Future<Either<Failure, MarketplaceOrderResponse>> createOrder(
    CreateOrderRequest request,
  );
  Future<Either<Failure, MarketplaceOrderResponse>> getMarketplaceOrder(
    String orderId, {
    String? currency,
  });
  Future<Either<Failure, MarketplaceOrderResponse>> refreshMarketplaceOrder(
    String orderId,
  );
  Future<Either<Failure, UserResponse>> refreshAuth(
    RefreshTokenRequest request,
  );
  Future<Either<Failure, ApplyPromoResponse>> applyPromo(
    ApplyPromoRequest request,
  );
  Future<Either<Failure, ReferralResponse>> getMyReferral();
  Future<Either<Failure, NotificationListResponse>> getNotifications(
    NotificationParams params,
  );
  Future<Either<Failure, UnreadNotificationCountResponse>>
  getUnreadNotificationsCount();
  Future<Either<Failure, WalletBalanceResponse>> getWalletBalance();
  Future<Either<Failure, WalletTransactionsResponse>> getWalletTransactions(
    WalletTransactionsParams params,
  );
  Future<Either<Failure, CreatePaymentResponse>> createPayment(
    String channel,
    CreatePaymentRequest request,
  );
  Future<Either<Failure, CheckoutResponse>> getCheckoutDetails(
    String packageId,
  );
  Future<Either<Failure, HomeSlidersResponse>> getHomeSliders();
  Future<Either<Failure, OrderHistoryResponse>> getOrderHistory(
    OrderHistoryParams params,
  );
  Future<Either<Failure, MyOrdersResponse>> getMyOrders(MyOrdersParams params);
  Future<Either<Failure, FeaturedCountriesResponse>> getFeaturedCountries();
  Future<Either<Failure, MinVersionResponse>> getMinVersion();
  Future<Either<Failure, RegisterResponse>> resendOtp(ResendOtpRequest request);
  Future<Either<Failure, CountrySearchResponse>> getCountrySearch(
    CountrySearchRequest request,
  );
  Future<Either<Failure, LegalPoliciesResponse>> getLegalPolicies();
  Future<Either<Failure, SettingsResponse>> getSettings();
  Future<Either<Failure, RenewalOptionsResponse>> getRenewalOptions(
    String orderId,
  );
}
