import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hi_net/app/dependency_injection.dart';
import 'package:hi_net/app/services/app_preferences.dart';
import 'package:hi_net/app/user_messages.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/usecase/get_marketplace_order_usecase.dart';
import 'package:hi_net/domain/usecase/get_renewal_options_usecase.dart';
import 'package:hi_net/presentation/common/utils/state_render.dart';

import '../../../common/ui_components/error_widget.dart';

part 'my_esim_details_event.dart';
part 'my_esim_details_state.dart';

class MyEsimDetailsBloc extends Bloc<MyEsimDetailsEvent, MyEsimDetailsState> {
  MyEsimDetailsBloc() : super(MyEsimDetailsState()) {
    on<GetMyEsimDetailsEvent>(_onGetMyEsimDetailsEvent);
    on<GetRenewalOptionsEvent>(_onGetRenewalOptionsEvent);
  }

  Future<void> _onGetMyEsimDetailsEvent(
    GetMyEsimDetailsEvent event,
    Emitter<MyEsimDetailsState> emit,
  ) async {
    var userDetails = await instance<AppPreferences>().getUserData();
    emit(state.copyWith(reqState: ReqState.loading));
    final result = await instance<GetMarketplaceOrderUseCase>().execute(
      GetOrderInput(
        event.orderId,
        currency: userDetails!.settings.currency.name,
      ),
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            reqState: ReqState.error,
            errorMessage: failure.userMessage,
            errorType: failure is NoInternetConnection
                ? ErrorType.noInternet
                : ErrorType.none,
          ),
        );
      },
      (myEsimDetails) {
        emit(
          state.copyWith(
            reqState: ReqState.success,
            order: myEsimDetails.order,
          ),
        );
        if (event.canRenew) {
          add(GetRenewalOptionsEvent(id: myEsimDetails.order!.id));
        }
      },
    );
  }

  Future<void> _onGetRenewalOptionsEvent(
    GetRenewalOptionsEvent event,
    Emitter<MyEsimDetailsState> emit,
  ) async {
    emit(state.copyWith(renewalReqState: ReqState.loading));
    final result = await instance<GetRenewalOptionsUseCase>().execute(
      event.id,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            renewalReqState: ReqState.error,
            renewalErrorMessage: failure.userMessage,
            renewalErrorType: failure is NoInternetConnection
                ? ErrorType.noInternet
                : ErrorType.none,
          ),
        );
      },
      (renewalOptions) {
        print(renewalOptions.data!.iccid);
        emit(
          state.copyWith(
            renewalReqState: renewalOptions.data!.availablePackages.isEmpty ? ReqState.empty : ReqState.success,
            renewalOptions: renewalOptions.data!.availablePackages,
          ),
        );
      },
    );
  }
}
