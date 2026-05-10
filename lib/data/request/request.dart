import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../app/enums.dart';

class Settings {
  final String language;
  final String currency;
  final String theme;

  const Settings({
    this.language = 'en',
    this.currency = 'SAR',
    this.theme = 'light',
  });

  Map<String, dynamic> toJson() => {
    "language": language,
    "currency": currency,
    "theme": theme,
  };
}

class RegisterRequest {
  final String fullName;
  final String mobile;
  final String callingCode;
  final String password;
  final String? email;
  final Settings settings;

  RegisterRequest({
    required this.fullName,
    required this.mobile,
    required this.callingCode,
    required this.password,
    this.email,
    this.settings = const Settings(),
  });

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "mobile": mobile,
    "callingCode": callingCode,
    "password": password,
    "email": email,
    "settings": settings.toJson(),
  };
}

class VerifyOtpRequest {
  final String mobile;
  final String callingCode;
  final String otp;
  final Map<String, String> device = {"deviceType": "mobile", "location": ""};

  VerifyOtpRequest({
    required this.mobile,
    required this.callingCode,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
    "mobile": mobile,
    "callingCode": callingCode,
    "otp": otp,
    "device": device,
  };
}

class ResendOtpRequest {
  final String mobile;
  final String callingCode;
  final String channel;

  ResendOtpRequest({
    required this.mobile,
    required this.callingCode,
    required this.channel,
  });

  Map<String, dynamic> toJson() => {
    "mobile": mobile,
    "callingCode": callingCode,
    "channel": channel,
  };
}

class LogoutRequest {
  final String refreshToken;

  LogoutRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => {"refreshToken": refreshToken};
}

class LoginRequest {
  final String mobile;
  final String callingCode;
  final String password;
  final Map<String, String> device = {
    "deviceType": "mobile",
    "location": "NONE",
  };

  LoginRequest({
    required this.mobile,
    required this.callingCode,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    "mobile": mobile,
    "callingCode": callingCode,
    "password": password,
    "device": device,
  };
}

class MarketplaceSearchRequest {
  final String country;
  final String? countryCode;
  final int? minDataGB;
  final int? maxDataGB;
  final int? minDays;
  final int? maxDays;
  final num? maxPrice;
  final SortBy? sortBy;
  final SortOrder? sortOrder;
  final String? provider;

  MarketplaceSearchRequest({
    required this.country,
    this.countryCode,
    this.minDataGB,
    this.maxDataGB,
    this.minDays,
    this.maxDays,
    this.maxPrice,
    this.sortBy,
    this.sortOrder,
    this.provider,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {"country": country};
    if (countryCode != null) data["countryCode"] = countryCode;
    if (minDataGB != null) data["minDataGB"] = minDataGB;
    if (maxDataGB != null) data["maxDataGB"] = maxDataGB;
    if (minDays != null) data["minDays"] = minDays;
    if (maxDays != null) data["maxDays"] = maxDays;
    if (maxPrice != null) data["maxPrice"] = maxPrice;
    if (sortBy != null) data["sortBy"] = sortBy!.name;
    if (sortOrder != null) data["sortOrder"] = sortOrder!.name;
    if (provider != null) data["provider"] = provider;
    return data;
  }
}

class CreateOrderRequest {
  final String packageId;
  final int count;
  final int daypassDays;
  final String email;
  final String startDate;

  CreateOrderRequest({
    required this.packageId,
    required this.count,
    required this.daypassDays,
    required this.email,
    required this.startDate,
  });

  Map<String, dynamic> toJson() => {
    "packageId": packageId,
    "count": count,
    "daypassDays": daypassDays,
    "email": email,
    "startDate": startDate,
  };
}

class RefreshTokenRequest {
  final String refreshToken;
  final Map<String, String> device = {
    "deviceType": "mobile",
    "location": "Cairo, EG", // Using fixed location as per example or generic
  };

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => {
    "refreshToken": refreshToken,
    "device": device,
  };
}

class UpdateUserRequest {
  final String? fullName;
  final String? email;
  final File? image;

  UpdateUserRequest({this.fullName, this.email, this.image});

  Map<String, dynamic> toJson() {
    return {
      if (fullName != null) "fullName": fullName,
      if (email != null) "email": email,
    };
  }

  FormData toFormData() {
    return FormData.fromMap({
      if (fullName != null) "fullName": fullName,
      if (email != null) "email": email,
      if (image != null)
        "image": MultipartFile.fromFileSync(
          image!.path,
          filename: image!.path.split('/').last,
        ),
    });
  }
}

class UpdateUserImageRequest {
  final File? image;

  UpdateUserImageRequest({this.image});

  Map<String, dynamic> toJson() => {"image": null};

  FormData toFormData() {
    return FormData.fromMap({
      if (image != null)
        "image": MultipartFile.fromFileSync(
          image!.path,
          filename: image!.path.split('/').last,
        ),
    });
  }
}

class UpdateUserCurrencyRequest {
  final String currency;

  UpdateUserCurrencyRequest(this.currency);

  Map<String, dynamic> toJson() => {"currency": currency};
}

class UpdateUserSettingsRequest {
  final String language;
  final String currency;
  final String theme;

  UpdateUserSettingsRequest({
    required this.language,
    required this.currency,
    required this.theme,
  });

  Map<String, dynamic> toJson() => {
    "language": language,
    "currency": currency,
    "theme": theme,
  };
}

class ApplyPromoRequest {
  final String code;
  final String packageId;
  final String currency;

  ApplyPromoRequest({
    required this.code,
    required this.packageId,
    required this.currency,
  });

  Map<String, dynamic> toJson() => {
    "code": code,
    "packageId": packageId,
    "currency": currency,
  };
}

class NotificationParams {
  final int? page;
  final int? pageSize;
  final int? offset;
  final String? search;
  final String? sortBy;
  final String? sortDirection;

  NotificationParams({
    this.page,
    this.pageSize = 10,
    this.offset,
    this.search,
    this.sortBy,
    this.sortDirection,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (page != null) data["page"] = page;
    if (pageSize != null) data["pageSize"] = pageSize;
    if (offset != null) data["offset"] = offset;
    if (search != null) data["search"] = search;
    if (sortBy != null) data["sortBy"] = sortBy;
    if (sortDirection != null) data["sortDirection"] = sortDirection;
    return data;
  }
}

class WalletTransactionsParams {
  final int? page;
  final int? pageSize;
  final String? type;
  final String? fromDate;
  final String? toDate;

  WalletTransactionsParams({
    this.page,
    this.pageSize = 25,
    this.type,
    this.fromDate,
    this.toDate,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (page != null) data["page"] = page;
    if (pageSize != null) data["pageSize"] = pageSize;
    if (type != null) data["type"] = type;
    if (fromDate != null) data["fromDate"] = fromDate;
    if (toDate != null) data["toDate"] = toDate;
    return data;
  }
}

class CreatePaymentRequest {
  final PaymentChannel channel;
  final String packageId;
  final bool useWallet;
  final String? promoCode;
  final String? renewOrderId;
  final String? currency;

  CreatePaymentRequest({
    required this.channel,
    required this.packageId,
    required this.useWallet,
    this.promoCode,
    this.renewOrderId,
    this.currency,
  });

  Map<String, dynamic> toJson() {
    return {
      "packageId": packageId,
      "useWallet": useWallet,
      if (promoCode != null) "promoCode": promoCode,
      if (renewOrderId != null) "renewOrderId": renewOrderId,
      if (currency != null) "currency": currency,
    };
  }
}

class OrderHistoryParams {
  final int page;

  OrderHistoryParams({required this.page});

  Map<String, dynamic> toJson() => {"page": page};
}

class MyOrdersParams {
  final int page;
  final int limit;

  MyOrdersParams({required this.page, required this.limit});

  Map<String, dynamic> toJson() => {"page": page, "limit": limit};
}

class CountrySearchRequest {
  final String? q;

  CountrySearchRequest({this.q});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (q != null) data["q"] = q;
    return data;
  }
}
