part of 'my_esim_details_bloc.dart';

sealed class MyEsimDetailsEvent {
  const MyEsimDetailsEvent();
}

class GetMyEsimDetailsEvent extends MyEsimDetailsEvent {
  final String orderId;
  final bool canRenew;
  const GetMyEsimDetailsEvent({required this.orderId, required this.canRenew});
}

class GetRenewalOptionsEvent extends MyEsimDetailsEvent {
  final String id;
  const GetRenewalOptionsEvent({required this.id});
}