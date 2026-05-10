import 'package:hi_net/app/enums.dart';
import 'package:hi_net/data/responses/responses.dart';

class PlanDetails {
  final String packageId;
  final EsimsType esimType;
  final String? countryCode;
  final String? regionCode;
  final List<CoveredCountry> coveredCountries;
  final double? dataAmount;
  final DataUnit? dataUnit;
  final int days;
  final double price;
  final Currency currency;
  final bool isRenewable;
  final bool isDayPass;
  final String buttonLabel;
  final List<NetworkDto> networkDtoList;
  final String? note;
  final String? fupPolicy;
  final bool isUnlimited;

  PlanDetails({
    required this.packageId,
    required this.esimType,
    required this.coveredCountries,
    required this.days,
    required this.price,
    required this.currency,
    required this.isRenewable,
    required this.isDayPass,
    required this.buttonLabel,
    required this.networkDtoList,
    this.note,
    this.fupPolicy,
    this.dataAmount,
    this.dataUnit,
    this.countryCode,
    this.regionCode,
    this.isUnlimited = false,
  });
}
