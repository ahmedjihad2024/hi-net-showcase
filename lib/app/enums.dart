// extension DeviceType on DEVICE_SIZE_TYPE {
//   bool get isDesktop => this == DEVICE_SIZE_TYPE.DESKTOP;
//   bool get isMobile => this == DEVICE_SIZE_TYPE.MOBILE;
//   bool get isTablet => this == DEVICE_SIZE_TYPE.TABLET;
// }

import 'package:flutter/material.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';

enum EsimsType {
  country,
  regional,
  global,
  renewal;

  bool get isRegional => this == EsimsType.regional;
  bool get isCountries => this == EsimsType.country;
  bool get isGlobal => this == EsimsType.global;
  bool get isRenewal => this == EsimsType.renewal;
}

enum PaymentMethod {
  card,
  applePay;

  bool get isCard => this == PaymentMethod.card;
  bool get isApplePay => this == PaymentMethod.applePay;
}

enum PaymentChannel {
  clickpay;

  bool get isClickpay => this == PaymentChannel.clickpay;
}

enum VerifyType {
  signIn,
  signUp;

  bool get isSignIn => this == VerifyType.signIn;
  bool get isSignUp => this == VerifyType.signUp;
}

enum DataUnit {
  MB,
  GB,
  TB;

  bool get isMB => this == DataUnit.MB;
  bool get isGB => this == DataUnit.GB;
  bool get isTB => this == DataUnit.TB;

  String get tr {
    return switch (this) {
      DataUnit.MB => Translation.mega.tr,
      DataUnit.GB => Translation.giga.tr,
      DataUnit.TB => Translation.tera.tr,
    };
  }

  DataUnit fromString(String value) {
    return DataUnit.values.firstWhere((e) => e.name == value);
  }
}

enum SortBy { price, data, duration, pricePerDay, pricePerGB }

enum SortOrder { desc, asc }

enum TransactionReason {
  purchase,
  cashback,
  gift,
  refund,
  other;

  bool get isPurchase => this == TransactionReason.purchase;
  bool get isCashback => this == TransactionReason.cashback;
  bool get isGift => this == TransactionReason.gift;
  bool get isRefund => this == TransactionReason.refund;
  bool get isOther => this == TransactionReason.other;

  static TransactionReason? fromString(String value) {
    return TransactionReason.values.where((e) => e.name == value).firstOrNull;
  }
}

enum ChannelOptions {
  whatsapp,
  sms;

  bool get isWhatsapp => this == ChannelOptions.whatsapp;
  bool get isSms => this == ChannelOptions.sms;

  String get tr => switch (this) {
    ChannelOptions.whatsapp => Translation.whatsapp.tr,
    ChannelOptions.sms => Translation.sms.tr,
  };

  static ChannelOptions fromString(String value) {
    return ChannelOptions.values.firstWhere((e) => e.name == value);
  }
}

enum DestinationTap {
  global,
  region,
  country;

  bool get isGlobal => this == DestinationTap.global;
  bool get isRegion => this == DestinationTap.region;
  bool get isCountry => this == DestinationTap.country;

  static DestinationTap fromString(String value) {
    return DestinationTap.values.firstWhere((e) => e.name == value);
  }
}

enum Currency {
  USD,
  EUR,
  GBP,
  JPY,
  AUD,
  CAD,
  CHF,
  CNY,
  SEK,
  NZD,
  KRW,
  SGD,
  NOK,
  MXN,
  INR,
  RUB,
  ZAR,
  TRY,
  BRL,
  TWD,
  DKK,
  PLN,
  THB,
  IDR,
  HUF,
  CZK,
  ILS,
  CLP,
  PHP,
  AED,
  COP,
  SAR,
  MYR,
  RON,
  VND,
  ARS,
  IQD,
  // Additional currencies
  AFN,
  ALL,
  AMD,
  ANG,
  AOA,
  AWG,
  AZN,
  BAM,
  BBD,
  BDT,
  BGN,
  BHD,
  BIF,
  BMD,
  BND,
  BOB,
  BSD,
  BTN,
  BWP,
  BYN,
  BZD,
  CDF,
  CRC,
  CUP,
  CVE,
  DJF,
  DOP,
  DZD,
  EGP,
  ERN,
  ETB,
  FJD,
  FKP,
  GEL,
  GHS,
  GIP,
  GMD,
  GNF,
  GTQ,
  GYD,
  HKD,
  HNL,
  HTG,
  ISK,
  JMD,
  JOD,
  KES,
  KGS,
  KHR,
  KMF,
  KWD,
  KYD,
  KZT,
  LAK,
  LBP,
  LKR,
  LRD,
  LSL,
  LYD,
  MAD,
  MDL,
  MGA,
  MKD,
  MMK,
  MNT,
  MOP,
  MRU,
  MUR,
  MVR,
  MWK,
  MZN,
  NAD,
  NGN,
  NIO,
  NPR,
  OMR,
  PAB,
  PEN,
  PGK,
  PKR,
  PYG,
  QAR,
  RSD,
  RWF,
  SBD,
  SCR,
  SDG,
  SHP,
  SLL,
  SOS,
  SRD,
  SSP,
  STN,
  SYP,
  SZL,
  TJS,
  TMT,
  TND,
  TOP,
  TTD,
  TZS,
  UAH,
  UGX,
  UYU,
  UZS,
  VES,
  VUV,
  WST,
  XAF,
  XCD,
  XOF,
  XPF,
  YER,
  ZMW,
  ZWL;

  static Currency? fromString(String code) {
    try {
      return Currency.values.firstWhere(
        (e) => e.name.toUpperCase() == code.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }
}

enum EsimStatus {
  pending,
  ready,
  active,
  data_exhausted,
  expired,
  cancelled;

  bool get isActive => this == EsimStatus.active;
  bool get isPending => this == EsimStatus.pending;
  bool get isReady => this == EsimStatus.ready;
  bool get isDataExhausted => this == EsimStatus.data_exhausted;
  bool get isExpired => this == EsimStatus.expired;
  bool get isCancelled => this == EsimStatus.cancelled;

  String get tr {
    return switch (this) {
      EsimStatus.pending => Translation.status_pending.tr,
      EsimStatus.ready => Translation.status_ready.tr,
      EsimStatus.active => Translation.status_active.tr,
      EsimStatus.data_exhausted => Translation.status_data_exhausted.tr,
      EsimStatus.expired => Translation.status_expired.tr,
      EsimStatus.cancelled => Translation.status_cancelled.tr,
    };
  }

  Color color(BuildContext context) {
    return switch (this) {
      EsimStatus.pending =>
        context.isDark ? const Color(0xFFFFB74D) : const Color(0xFFF57C00),
      EsimStatus.ready =>
        context.isDark ? const Color(0xFF64B5F6) : const Color(0xFF1976D2),
      EsimStatus.active =>
        context.isDark ? const Color(0xFF81C784) : const Color(0xFF388E3C),
      EsimStatus.data_exhausted =>
        context.isDark ? const Color(0xFFFF8A65) : const Color(0xFFD84315),
      EsimStatus.expired =>
        context.isDark ? const Color(0xFFE57373) : const Color(0xFFC62828),
      EsimStatus.cancelled =>
        context.isDark ? const Color(0xFFBDBDBD) : const Color(0xFF616161),
    };
  }

  int get hexColor {
    return switch (this) {
      EsimStatus.pending => 0xFFF57C00,
      EsimStatus.ready => 0xFF1976D2,
      EsimStatus.active => 0xFF388E3C,
      EsimStatus.data_exhausted => 0xFFD84315,
      EsimStatus.expired => 0xFFC62828,
      EsimStatus.cancelled => 0xFF616161,
    };
  }

  static EsimStatus fromString(String value) {
    return switch (value.toLowerCase()) {
      'pending' => EsimStatus.pending,
      'ready' => EsimStatus.ready,
      'active' => EsimStatus.active,
      'data_exhausted' => EsimStatus.data_exhausted,
      'expired' => EsimStatus.expired,
      'cancelled' => EsimStatus.cancelled,
      _ => EsimStatus.pending,
    };
  }
}

enum UserLevel {
  bronze,
  silver,
  gold;

  bool get isBronze => this == UserLevel.bronze;
  bool get isSilver => this == UserLevel.silver;
  bool get isGold => this == UserLevel.gold;

  String get tr {
    return switch (this) {
      UserLevel.bronze => Translation.bronze.tr,
      UserLevel.silver => Translation.silver.tr,
      UserLevel.gold => Translation.gold.tr,
    };
  }

  String get image {
    return switch (this) {
      UserLevel.bronze => ImagesM.bronze,
      UserLevel.silver => ImagesM.silver,
      UserLevel.gold => ImagesM.gold,
    };
  }

  static UserLevel fromString(String value) {
    return switch (value.toLowerCase()) {
      'bronze' => UserLevel.bronze,
      'silver' => UserLevel.silver,
      'gold' => UserLevel.gold,
      _ => UserLevel.bronze,
    };
  }
}
