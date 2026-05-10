import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:hi_net/app/user_messages.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/usecase/get_marketplace_country_plans_usecase.dart';
import 'package:hi_net/domain/usecase/get_marketplace_region_plans_usecase.dart';
import 'package:hi_net/presentation/common/utils/state_render.dart';

import '../../../../data/network/error_handler/failure.dart';
import '../../../common/ui_components/error_widget.dart';

part 'esim_details_event.dart';
part 'esim_details_state.dart';

class EsimDetailsBloc extends Bloc<EsimDetailsEvent, EsimDetailsState> {
  final GetIt _instance;

  EsimDetailsBloc(this._instance) : super(EsimDetailsState()) {
    on<GetCountryPlansEvent>(_onGetCountryPlansEvent);
    on<GetRegionPlansEvent>(_onGetRegionPlansEvent);
    on<SelectPlanEvent>(_onSelectPlanEvent);
  }

  void _onSelectPlanEvent(
    SelectPlanEvent event,
    Emitter<EsimDetailsState> emit,
  ) async {
    if (event.index == state.selectedPlanIndex) return;
    emit(
      state.copyWith(
        selectedPlanIndex: event.index,
        supportedCountries: state.regionalPlans.isEmpty
            ? []
            : state.regionalPlans[event.index].coveredCountries,
        supportedCountriesCount: state.regionalPlans.isEmpty
            ? 0
            : state.regionalPlans[event.index].coveredCountries.length,
      ),
    );
  }

  void _onGetCountryPlansEvent(
    GetCountryPlansEvent event,
    Emitter<EsimDetailsState> emit,
  ) async {
    emit(state.copyWith(reqState: ReqState.loading));
    final result = await _instance<GetMarketplaceCountryPlansUseCase>().execute(
      event.countryCode,
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
      (res) {
        emit(
          state.copyWith(
            reqState: res.plans!.isNotEmpty ? ReqState.success : ReqState.empty,
            countryPlans: res.plans,
            plansCount: res.plans?.length ?? 0,
          ),
        );
      },
    );
  }

  void _onGetRegionPlansEvent(
    GetRegionPlansEvent event,
    Emitter<EsimDetailsState> emit,
  ) async {
    emit(state.copyWith(reqState: ReqState.loading));
    final result = await _instance<GetMarketplaceRegionPlansUseCase>().execute(
      event.regionCode,
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
      (res) {
        emit(
          state.copyWith(
            reqState: res.plans!.isNotEmpty ? ReqState.success : ReqState.empty,
            regionalPlans: res.plans,
            plansCount: res.plans?.length ?? 0,
            supportedCountries: res.plans!.isEmpty
                ? []
                : res.plans![0].coveredCountries,
            supportedCountriesCount: res.plans!.isEmpty
                ? 0
                : res.plans![0].coveredCountries.length,
          ),
        );
      },
    );
  }
}
