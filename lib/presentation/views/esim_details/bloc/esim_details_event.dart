part of 'esim_details_bloc.dart';

sealed class EsimDetailsEvent {
  const EsimDetailsEvent();
}

class GetCountryPlansEvent extends EsimDetailsEvent {
  final String countryCode;

  const GetCountryPlansEvent({
    required this.countryCode,
  });
}

class GetRegionPlansEvent extends EsimDetailsEvent {
  final String regionCode;

  const GetRegionPlansEvent({
    required this.regionCode,
  });
}

class SelectPlanEvent extends EsimDetailsEvent {
  final int index;

  const SelectPlanEvent({
    required this.index,
  });
}
