part of 'my_esim_details_bloc.dart';

class MyEsimDetailsState extends Equatable {
  final ReqState reqState;
  final String? errorMessage;
  final MarketplaceOrder? order;
  final ErrorType errorType;

  final ReqState renewalReqState;
  final String? renewalErrorMessage;
  final ErrorType renewalErrorType;
  final List<RenewalPackage> renewalOptions;

  const MyEsimDetailsState({
    this.reqState = ReqState.loading,
    this.errorMessage,
    this.order,
    this.errorType = ErrorType.none,
    this.renewalReqState = ReqState.loading,
    this.renewalErrorMessage,
    this.renewalErrorType = ErrorType.none,
    this.renewalOptions = const [],
  });

  MyEsimDetailsState copyWith({
    ReqState? reqState,
    String? errorMessage,
    MarketplaceOrder? order,
    ErrorType? errorType,
    ReqState? renewalReqState,
    String? renewalErrorMessage,
    ErrorType? renewalErrorType,
    List<RenewalPackage>? renewalOptions,
  }) {
    return MyEsimDetailsState(
      reqState: reqState ?? this.reqState,
      errorMessage: errorMessage ?? this.errorMessage,
      order: order ?? this.order,
      errorType: errorType ?? this.errorType,
      renewalReqState: renewalReqState ?? this.renewalReqState,
      renewalErrorMessage: renewalErrorMessage ?? this.renewalErrorMessage,
      renewalErrorType: renewalErrorType ?? this.renewalErrorType,
      renewalOptions: renewalOptions ?? this.renewalOptions,
    );
  }

  @override
  List<Object?> get props =>
      [reqState, errorMessage, order, errorType, renewalReqState, renewalErrorMessage, renewalErrorType, renewalOptions];
}
