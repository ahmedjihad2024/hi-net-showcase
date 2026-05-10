import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hi_net/app/app.dart';
import 'package:hi_net/app/dependency_injection.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/app/services/app_preferences.dart';
import 'package:hi_net/app/services/flutter_background_services.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/domain/usecase/base.dart';
import 'package:hi_net/domain/usecase/country_search_usecase.dart';
import 'package:hi_net/domain/usecase/get_featured_countries_usecase.dart';
import 'package:hi_net/domain/usecase/get_home_sliders_usecase.dart';
import 'package:hi_net/domain/usecase/get_marketplace_countries_usecase.dart';
import 'package:hi_net/domain/usecase/get_marketplace_global_plans_usecase.dart';
import 'package:hi_net/domain/usecase/get_marketplace_regions_usecase.dart';
import 'package:hi_net/domain/usecase/get_my_orders_usecase.dart';
import 'package:hi_net/domain/usecase/get_unread_notifications_count_usecase.dart';
import 'package:hi_net/domain/usecase/get_user_usecase.dart';
import 'package:hi_net/domain/usecase/get_wallet_balance_usecase.dart';
import 'package:hi_net/domain/usecase/logout_usecase.dart';
import 'package:hi_net/domain/usecase/update_user_settings_usecase.dart';
import 'package:hi_net/domain/usecase/get_legal_policies_usecase.dart';
import 'package:hi_net/app/services/live_activity_manager.dart';
import 'package:hi_net/presentation/common/_template/pagination_mixin_class.dart';
import 'package:hi_net/presentation/common/ui_components/error_widget.dart';
import 'package:hi_net/presentation/common/utils/fast_function.dart';
import 'package:hi_net/presentation/common/utils/state_render.dart';
import 'package:hi_net/presentation/common/utils/ui_feedback.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/home/view/widgets/select_duration_bottom_sheet.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../app/flavor.dart';
import '../../../../app/services/firebase_messeging_services.dart';
import '../../../../app/user_messages.dart';
import '../../../../data/responses/responses.dart';
import '../../../common/utils/snackbar_helper.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> with PaginationMixin {
  HomeBloc(this._instance, this._uiFeedback) : super(HomeState()) {
    on<InitUserDetails>(_onInitUserDetails);
    on<LogoutEvent>(_onLogoutEvent);
    on<GetCountriesEvent>(_onGetCountriesEvent);
    on<SelectCountryEvent>(_onSelectCountryEvent);
    on<GetRegionsEvent>(_onGetRegionsEvent);
    on<GetGlobalPlansEvent>(_onGetGlobalEvent);
    on<SelectDurationEvent>(_onSelectDurationEvent);
    on<UnselectDurationEvent>(_onUnselectDurationEvent);
    on<UnselectCountryEvent>(_onUnselectCountryEvent);
    on<GetUserDetailsEvent>(_onGetUserDetails);
    on<UpdateUserDetailsEvent>(_onUpdateUserDetails);
    on<UpdateUserCurrencyEvent>(_onUpdateUserCurrency);
    on<GetNotificationsCountEvent>(_onGetNotificationsCount);
    on<GetCurrentBalanceEvent>(_onGetCurrentBalance);
    on<GetHomeSlidersEvent>(_onGetHomeSlidersEvent);
    on<GetOrderEvent>(_onGetOrderEvent);
    on<UpdateSettingsEvent>(_onUpdateSettingsEvent);
    on<GetMostRequestedCountriesEvent>(_onGetMostRequestedCountriesEvent);
    on<GetDestinationsEvent>(_onGetDestinationsEvent);
    on<FilterDestinationsEvent>(_onFilterDestinationsEvent);
    on<SelectDestinationTapEvent>(_onSelectDestinationTapEvent);
    on<GetCurrentActiveEsimEvent>(_onGetCurrentActiveEsimEvent);
    on<GetPagesEvent>(_onGetPagesEvent);
    on<ShowHideNotificationEvent>(_onShowHideNotificationEvent);

    add(InitUserDetails());
    add(GetHomeSlidersEvent());
    add(GetMostRequestedCountriesEvent());
    if (instance<AppPreferences>().isUserRegistered) {
      add(GetNotificationsCountEvent());
      add(GetCurrentBalanceEvent());
      add(GetCurrentActiveEsimEvent());
      add(GetPagesEvent());
    }
  }

  final GetIt _instance;
  final UiFeedback _uiFeedback;

  final RefreshController profileRefreshController = RefreshController();
  final RefreshController orderRefreshController = RefreshController();
  ValueNotifier<int> unreadNotificationsCount = ValueNotifier<int>(0);
  ValueNotifier<double> currentBalance = ValueNotifier<double>(0);

  List<MarketplaceCountrySearchItem> destinationCountries = [];
  List<MarketplaceCountrySearchItem> destinationRegions = [];

  // listener for background service
  StreamSubscription<Map<String, dynamic>?>? isStoppedSubscription;

  Future<void> _onShowHideNotificationEvent(
    ShowHideNotificationEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state.isLiveActivityEnabled) {
      MyBackgroundService.instance.stop();
      isStoppedSubscription?.cancel();
      isStoppedSubscription = null;
      await _instance<AppPreferences>().setLiveActivityEnabled(false);
      emit(state.copyWith(isLiveActivityEnabled: false));
    } else {
      await MyBackgroundService.instance.initialize();
      isStoppedSubscription?.cancel();
      isStoppedSubscription = MyBackgroundService.instance.isStopped().listen((
        event,
      ) {
        add(ShowHideNotificationEvent());
        isStoppedSubscription?.cancel();
      });
      await _instance<AppPreferences>().setLiveActivityEnabled(true);
      emit(state.copyWith(isLiveActivityEnabled: true));
    }
  }

  Future<void> _onSelectDestinationTapEvent(
    SelectDestinationTapEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (event.type == state.selectedDestinationTap) return;
    emit(state.copyWith(selectedDestinationTap: event.type));
  }

  Future<void> _onFilterDestinationsEvent(
    FilterDestinationsEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(
        state.copyWith(
          destinationCountries: destinationCountries,
          destinationRegions: destinationRegions,
          filteredGlobalPlans: state.globalPlans,
          isFilterApplied: false,
        ),
      );
      return;
    }

    RegExp regExp = RegExp(
      r'[\u0622\u0623\u0625\u0671\u0673\u0674\u0675]',
      unicode: true,
    );
    String normalizedQuery = event.query.toLowerCase().replaceAllMapped(
      regExp,
      (match) => 'ا',
    );

    final filteredCountries = await compute(filterCountriesFun, {
      'countries': destinationCountries,
      'query': normalizedQuery,
      'regexp': regExp.pattern,
    });
    final filteredRegions = await compute(filterCountriesFun, {
      'countries': destinationRegions,
      'query': normalizedQuery,
      'regexp': regExp.pattern,
    });
    final filteredGlobalPlans = await compute(filterGlobalPlansFun, {
      'globalPlans': (state.globalPlans ?? []),
      'query': normalizedQuery,
      'regexp': regExp.pattern,
    });
    emit(
      state.copyWith(
        destinationRegions: filteredRegions,
        destinationCountries: filteredCountries,
        filteredGlobalPlans: filteredGlobalPlans,
        isFilterApplied: true,
      ),
    );
  }

  Future<void> _onGetDestinationsEvent(
    GetDestinationsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(destinationsReqState: ReqState.loading));
    Either<Failure, CountrySearchResponse> response =
        await _instance<CountrySearchUseCase>().execute(CountrySearchRequest());

    await response.fold(
      (failure) {
        emit(
          state.copyWith(
            destinationsReqState: ReqState.error,
            destinationsErrorMessage: failure.userMessage,
            destinationsErrorType: failure is NoInternetConnection
                ? ErrorType.noInternet
                : ErrorType.none,
          ),
        );
      },
      (res) async {
        destinationCountries = res.data!.data
            .where((e) => e.type.isCountry)
            .toList();
        destinationRegions = res.data!.data
            .where((e) => e.type.isRegion)
            .toList();
        emit(
          state.copyWith(
            destinationsReqState: ReqState.success,
            destinationCountries: destinationCountries,
            destinationRegions: destinationRegions,
          ),
        );
      },
    );
  }

  Future<void> _onGetMostRequestedCountriesEvent(
    GetMostRequestedCountriesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(mostRequestedCountriesReqState: ReqState.loading));
    await Future.doWhile(() async {
      if (isClosed) return false;
      Either<Failure, FeaturedCountriesResponse> response =
          await _instance<GetFeaturedCountriesUseCase>().execute(NoParams());

      if (isClosed) return false;

      bool status = await response.fold(
        (failure) {
          return !isClosed;
        },
        (res) async {
          emit(
            state.copyWith(
              mostRequestedCountriesReqState: ReqState.success,
              mostRequestedCountries: res.data!.data,
            ),
          );
          return false;
        },
      );

      if (status) await Future.delayed(const Duration(seconds: 3));

      return status;
    });
  }

  Future<void> _onGetHomeSlidersEvent(
    GetHomeSlidersEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(homeSlidersReqState: ReqState.loading));
    await Future.doWhile(() async {
      if (isClosed) return false;
      Either<Failure, HomeSlidersResponse> response =
          await _instance<GetHomeSlidersUseCase>().execute(NoParams());

      if (isClosed) return false;

      bool status = await response.fold(
        (failure) {
          return !isClosed;
        },
        (res) async {
          emit(
            state.copyWith(
              homeSlidersReqState: ReqState.success,
              homeSlidersCount: res.data!.length,
              homeSliders: res.data,
            ),
          );
          return false;
        },
      );

      if (status) await Future.delayed(const Duration(seconds: 3));

      return status;
    });
  }

  Future<void> _onGetCurrentActiveEsimEvent(
    GetCurrentActiveEsimEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(currentActiveEsimReqState: ReqState.loading));
    await Future.doWhile(() async {
      if (isClosed) return false;
      Either<Failure, MyOrdersResponse> response =
          await _instance<GetMyOrdersUseCase>().execute(
            MyOrdersParams(page: 1, limit: 1),
          );

      if (isClosed) return false;

      bool status = await response.fold(
        (failure) {
          return !isClosed;
        },
        (res) async {
          MyOrderItem? myOrderItem =
              res.data!.isNotEmpty && res.data!.first.status.isActive
              ? res.data?.firstOrNull
              : null;
          emit(
            state.copyWith(
              currentActiveEsimReqState: ReqState.success,
              currentActiveEsim: myOrderItem,
              hasActiveEsim:
                  res.data!.isNotEmpty && res.data!.first.status.isActive,
            ),
          );
          return false;
        },
      );

      if (status) await Future.delayed(const Duration(seconds: 3));

      return status;
    });
  }

  Future<void> _onUnselectCountryEvent(
    UnselectCountryEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.unselectCountry());
  }

  Future<void> _onUnselectDurationEvent(
    UnselectDurationEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.unselectDuration());
  }

  Future<void> _onSelectCountryEvent(
    SelectCountryEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(selectedCountry: event.country));
  }

  Future<void> _onSelectDurationEvent(
    SelectDurationEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedTimeNum: event.timeNum,
        selectedTimeType: event.type,
      ),
    );
  }

  Future<void> _onInitUserDetails(
    InitUserDetails event,
    Emitter<HomeState> emit,
  ) async {
    var userData = await _instance<AppPreferences>().getUserData();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (userData != null) {
      bool liveActivityEnabled = _instance<AppPreferences>().isLiveActivityEnabled;

      if (liveActivityEnabled && !(await MyBackgroundService.instance.isRunning())) {
        await MyBackgroundService.instance.initialize();
        await MyBackgroundService.instance.start();
      }

      emit(
        state.copyWith(
          userName: userData.fullName,
          globalCurrency: userData.settings.currency,
          profileImage: userData.image,
          userLevel: userData.level,
          appVersion: "v${packageInfo.version}",
          isLiveActivityEnabled: liveActivityEnabled,
        ),
      );
    } else {
      emit(state.copyWith(appVersion: "v${packageInfo.version}"));
    }
  }

  Future<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<HomeState> emit,
  ) async {
    _uiFeedback.showLoading();
    Either<Failure, BasicResponse> response = await _instance<LogoutUseCase>()
        .execute(
          LogoutRequest(
            refreshToken: _instance<AppPreferences>().refreshToken!,
          ),
        );

    await response.fold(
      (failure) {
        _uiFeedback.hideLoading();
        _uiFeedback.showMessage(failure.userMessage, ErrorMessage.snackBar);
      },
      (res) async {
        if (state.isLiveActivityEnabled) {
          add(ShowHideNotificationEvent());
        }
        String? userId = (await _instance<AppPreferences>().getUserData())?.id;
        await _instance<AppPreferences>().deleteUserData();
        await _instance<AppPreferences>().clearAllTokens();
        _uiFeedback.hideLoading();
        if (userId != null) {
          FirebaseMessegingServices.instance
              .unsubscribeFromTopicsTryUntilSuccess(
                topics: [
                  FlavorConfig.instance.flavor.isProd
                      ? userId
                      : "${userId}_dev",
                ],
              );
        }
        MyBackgroundService.instance.stop();
        event.onLogout();
      },
    );
  }

  Future<void> _onGetCountriesEvent(
    GetCountriesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(countryReqState: ReqState.loading));
    Either<Failure, MarketplaceCountriesResponse> response =
        await _instance<GetMarketplaceCountriesUseCase>().execute(NoParams());

    await response.fold(
      (failure) {
        emit(
          state.copyWith(
            countryReqState: ReqState.error,
            countryErrorMessage: failure.userMessage,
            countryErrorType: failure is NoInternetConnection
                ? ErrorType.noInternet
                : ErrorType.none,
          ),
        );
      },
      (res) async {
        emit(
          state.copyWith(
            countryReqState: res.data!.isEmpty
                ? ReqState.empty
                : ReqState.success,
            countries: res.data,
            countryCount: res.count,
          ),
        );
      },
    );
  }

  Future<void> _onGetRegionsEvent(
    GetRegionsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(regionReqState: ReqState.loading));
    Either<Failure, MarketplaceRegionsResponse> response =
        await _instance<GetMarketplaceRegionsUseCase>().execute(NoParams());

    await response.fold(
      (failure) {
        emit(
          state.copyWith(
            regionReqState: ReqState.error,
            regionErrorMessage: failure.userMessage,
            regionErrorType: failure is NoInternetConnection
                ? ErrorType.noInternet
                : ErrorType.none,
          ),
        );
      },
      (res) async {
        emit(
          state.copyWith(
            regionReqState: res.data!.isEmpty
                ? ReqState.empty
                : ReqState.success,
            regions: res.data,
          ),
        );
      },
    );
  }

  Future<void> _onGetGlobalEvent(
    GetGlobalPlansEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(globalReqState: ReqState.loading));
    Either<Failure, MarketplaceGlobalPlansResponse> response =
        await _instance<GetMarketplaceGlobalPlansUseCase>().execute(NoParams());

    await response.fold(
      (failure) {
        emit(
          state.copyWith(
            globalReqState: ReqState.error,
            globalErrorMessage: failure.userMessage,
            globalErrorType: failure is NoInternetConnection
                ? ErrorType.noInternet
                : ErrorType.none,
          ),
        );
      },
      (res) async {
        emit(
          state.copyWith(
            globalReqState: res.plans!.isEmpty
                ? ReqState.empty
                : ReqState.success,
            globalPlansCount: res.plansCount,
            globalStartFromPrice: res.startFromPrice,
            globalCurrency: res.currency,
            globalPlans: res.plans,
            filteredGlobalPlans: res.plans,
          ),
        );
      },
    );
  }

  Future<void> _onGetUserDetails(
    GetUserDetailsEvent event,
    Emitter<HomeState> emit,
  ) async {
    await Future.doWhile(() async {
      Either<Failure, GetUserResponse> response =
          await _instance<GetUserUseCase>().execute(NoParams());

      if (isClosed) return false;

      if (response.isRight()) {
        GetUserResponse data = response.foldRight<GetUserResponse?>(
          null,
          (data, _) => data,
        )!;

        await instance<AppPreferences>().setUserData(data.user!);
      }

      bool status = await response.fold(
        (failure) {
          return !isClosed;
        },
        (res) async {
          profileRefreshController.refreshCompleted();
          emit(
            state.copyWith(
              userName: res.user!.fullName,
              profileImage: res.user!.image,
              globalCurrency: res.user!.settings.currency,
              userLevel: res.user!.level,
            ),
          );
          return false;
        },
      );

      if (status) await Future.delayed(const Duration(seconds: 3));

      return status;
    });
  }

  Future<void> _onGetNotificationsCount(
    GetNotificationsCountEvent event,
    Emitter<HomeState> emit,
  ) async {
    await Future.doWhile(() async {
      if (isClosed) return false;
      Either<Failure, UnreadNotificationCountResponse> response =
          await _instance<GetUnreadNotificationsCountUseCase>().execute(
            NoParams(),
          );

      if (isClosed) return false;

      bool status = await response.fold(
        (failure) {
          return !isClosed;
        },
        (res) async {
          unreadNotificationsCount.value = res.count;
          return false;
        },
      );

      if (status) await Future.delayed(const Duration(seconds: 5));

      return status;
    });
  }

  Future<void> _onGetCurrentBalance(
    GetCurrentBalanceEvent event,
    Emitter<HomeState> emit,
  ) async {
    await Future.doWhile(() async {
      if (isClosed) return false;
      Either<Failure, WalletBalanceResponse> response =
          await _instance<GetWalletBalanceUseCase>().execute(NoParams());

      if (isClosed) return false;

      bool status = await response.fold(
        (failure) {
          return !isClosed;
        },
        (res) async {
          currentBalance.value = res.balance;
          return true;
        },
      );

      if (status) await Future.delayed(const Duration(minutes: 2));

      return status;
    });
  }

  Future<void> _onUpdateUserDetails(
    UpdateUserDetailsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        userName: event.user.fullName,
        profileImage: event.user.image,
        globalCurrency: event.user.settings.currency,
        // selectedCurrency: event.user.settings.currency,
      ),
    );
  }

  Future<void> _onUpdateUserCurrency(
    UpdateUserCurrencyEvent event,
    Emitter<HomeState> emit,
  ) async {
    // add(GetGlobalPlansEvent());
    emit(state.copyWith(globalCurrency: event.currency));
  }

  Future<void> _onGetOrderEvent(
    GetOrderEvent event,
    Emitter<HomeState> emit,
  ) async {
    await handlePagination<MyOrderItem>(
      key: 'get-orders',
      controller: orderRefreshController,
      isRefresh: event.isRefresh,
      emit: emit,
      loadingState: () => state.copyWith(myOrdersReqState: ReqState.loading),
      errorState: (errorMessage, reqState, failure) {
        return state.copyWith(
          myOrdersReqState: reqState,
          myOrdersErrorMessage: errorMessage,
          myOrdersErrorType: failure is NoInternetConnection
              ? ErrorType.noInternet
              : ErrorType.none,
        );
      },
      successState: (items, isRefresh) {
        return state.copyWith(
          myOrders: items,
          myOrdersReqState: items.isEmpty ? ReqState.empty : ReqState.success,
        );
      },
      currentItems: state.myOrders,
      fetchData: (page) async {
        final response = await instance<GetMyOrdersUseCase>().execute(
          MyOrdersParams(page: page, limit: 10),
        );
        return response.fold(
          (failure) => Left(failure),
          (data) => Right(
            PaginatedResponse<MyOrderItem>(
              items: data.data ?? [],
              meta: PaginationMeta(
                currentPage: data.page,
                lastPage: data.totalPages,
                total: data.total,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onUpdateSettingsEvent(
    UpdateSettingsEvent event,
    Emitter<HomeState> emit,
  ) async {
    var userDetails = await instance<AppPreferences>().getUserData();

    if (userDetails == null) {
      event.onSuccess();
      return;
    }

    _uiFeedback.showLoading();

    var response = await _instance<UpdateUserSettingsUseCase>().execute(
      UpdateUserSettingsRequest(
        language: event.language ?? userDetails.settings.language,
        theme: event.theme ?? userDetails.settings.theme,
        currency: userDetails.settings.currency.name,
      ),
    );

    response.fold(
      (failure) async {
        await _uiFeedback.hideLoading();
        _uiFeedback.showMessage(failure.userMessage, ErrorMessage.snackBar);
      },
      (res) async {
        await _uiFeedback.hideLoading();
        await instance<AppPreferences>().setUserData(res.user!);
        event.onSuccess();
      },
    );
  }

  Future<void> _onGetPagesEvent(
    GetPagesEvent event,
    Emitter<HomeState> emit,
  ) async {
    await Future.doWhile(() async {
      if (isClosed) return false;
      var response = await _instance<GetLegalPoliciesUseCase>().execute(
        NoParams(),
      );

      if (isClosed) return false;

      bool status = await response.fold(
        (failure) {
          return !isClosed;
        },
        (res) async {
          emit(state.copyWith(pages: res.data ?? []));
          return false;
        },
      );

      if (status) await Future.delayed(const Duration(minutes: 2));

      return status;
    });
  }

  @override
  Future<void> close() async {
    profileRefreshController.dispose();
    unreadNotificationsCount.dispose();
    orderRefreshController.dispose();
    currentBalance.dispose();
    isStoppedSubscription?.cancel();
    return super.close();
  }
}

bool _matchesSearch(
  String normalizedQuery,
  RegExp regExp, {
  required String nameEn,
  required String nameAr,
  String? customNameEn,
  String? customNameAr,
}) {
  final normalizedAr = nameAr.toLowerCase().replaceAllMapped(
    regExp,
    (_) => 'ا',
  );
  final normalizedCustomAr = (customNameAr ?? '').isNotEmpty
      ? customNameAr!.toLowerCase().replaceAllMapped(regExp, (_) => 'ا')
      : null;
  return nameEn.toLowerCase().contains(normalizedQuery) ||
      normalizedAr.contains(normalizedQuery) ||
      (customNameEn != null &&
          customNameEn.isNotEmpty &&
          customNameEn.toLowerCase().contains(normalizedQuery)) ||
      (normalizedCustomAr != null &&
          normalizedCustomAr.contains(normalizedQuery));
}

List<MarketplaceCountrySearchItem> filterCountriesFun(
  Map<String, dynamic> params,
) {
  final countries = params['countries'] as List<MarketplaceCountrySearchItem>;
  final normalizedQuery = params['query'] as String;
  final regExpPattern = params['regexp'] as String;
  final regExp = RegExp(regExpPattern);
  return countries.where((e) {
    // Match on item-level names (for countries/regions)
    if (_matchesSearch(
      normalizedQuery,
      regExp,
      nameEn: e.nameEn,
      nameAr: e.nameAr,
      customNameEn: e.customNameEn,
      customNameAr: e.customNameAr,
    ))
      return true;
    // Match on covered countries
    final index = e.coveredCountries.indexWhere(
      (element) => _matchesSearch(
        normalizedQuery,
        regExp,
        nameEn: element.nameEn,
        nameAr: element.nameAr,
        customNameEn: element.customNameEn,
        customNameAr: element.customNameAr,
      ),
    );
    return index != -1;
  }).toList();
}

List<MarketplaceGlobalPlan> filterGlobalPlansFun(Map<String, dynamic> params) {
  final globalPlans = params['globalPlans'] as List<MarketplaceGlobalPlan>;
  final normalizedQuery = params['query'] as String;
  final regExpPattern = params['regexp'] as String;
  final regExp = RegExp(regExpPattern);
  return globalPlans.where((e) {
    final index = e.coveredCountries.indexWhere(
      (element) => _matchesSearch(
        normalizedQuery,
        regExp,
        nameEn: element.nameEn,
        nameAr: element.nameAr,
        customNameEn: element.customNameEn,
        customNameAr: element.customNameAr,
      ),
    );
    return index != -1;
  }).toList();
}
