part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();
}

class InitUserDetails extends HomeEvent {
  const InitUserDetails();
}

class LogoutEvent extends HomeEvent {
  final void Function() onLogout;
  const LogoutEvent(this.onLogout);
}

class GetCountriesEvent extends HomeEvent {
  const GetCountriesEvent();
}

class GetRegionsEvent extends HomeEvent {
  const GetRegionsEvent();
}

class GetGlobalPlansEvent extends HomeEvent {
  const GetGlobalPlansEvent();
}

class SelectDurationEvent extends HomeEvent {
  final int timeNum;
  final SelectDurationType type;
  const SelectDurationEvent(this.timeNum, this.type);
}

class SelectCountryEvent extends HomeEvent {
  final MarketplaceCountry country;
  const SelectCountryEvent(this.country);
}

class UnselectDurationEvent extends HomeEvent {
  const UnselectDurationEvent();
}

class UnselectCountryEvent extends HomeEvent {
  const UnselectCountryEvent();
}

class GetUserDetailsEvent extends HomeEvent {}

class UpdateUserDetailsEvent extends HomeEvent{
  final User user;
  const UpdateUserDetailsEvent(this.user);
}

class UpdateUserCurrencyEvent extends HomeEvent {
  final Currency currency;
  const UpdateUserCurrencyEvent(this.currency);
}

class GetNotificationsCountEvent extends HomeEvent {
  const GetNotificationsCountEvent();
}

class GetCurrentBalanceEvent extends HomeEvent {
  const GetCurrentBalanceEvent();
}

class GetHomeSlidersEvent extends HomeEvent {
  const GetHomeSlidersEvent();
}

class GetOrderEvent extends HomeEvent {
  final bool isRefresh;
  const GetOrderEvent(this.isRefresh);
}

class UpdateSettingsEvent extends HomeEvent {
  final String? language;
  final String? theme;
  final void Function() onSuccess;
  const UpdateSettingsEvent(this.language, this.theme, this.onSuccess);
}

class GetMostRequestedCountriesEvent extends HomeEvent {
  const GetMostRequestedCountriesEvent();
}

class GetDestinationsEvent extends HomeEvent {
  const GetDestinationsEvent();
}

class FilterDestinationsEvent extends HomeEvent {
  final String query;
  final DestinationTap type;
  const FilterDestinationsEvent(this.query, this.type);
}

class SelectDestinationTapEvent extends HomeEvent {
  final DestinationTap type;
  const SelectDestinationTapEvent(this.type);
}

class GetCurrentActiveEsimEvent extends HomeEvent {
  const GetCurrentActiveEsimEvent();
}

class GetPagesEvent extends HomeEvent {
  const GetPagesEvent();
}

class ShowHideNotificationEvent extends HomeEvent {
  const ShowHideNotificationEvent();
}




