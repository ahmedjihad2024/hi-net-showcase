import 'dart:ui';

import '../../app/enums.dart';

class BasicResponse {
  final bool success;
  final String message;
  final String? errorType;

  BasicResponse({required this.success, required this.message, this.errorType});

  factory BasicResponse.fromJson(Map<String, dynamic> json) {
    bool success =
        (json['success'] as bool?) ??
        (json['status'] as bool?) ??
        (json['response']?['success'] as bool?) ??
        false;
    return BasicResponse(
      success: success,
      message: success
          ? ((json['message'] as String?) ?? "")
          : (json['response']?['details']?['message'] as String? ??
                json['message'] as String? ??
                ''),
      errorType: json["errorType"] as String?,
    );
  }
}

class RegisterResponse extends BasicResponse {
  final String? status;
  final int? expiresInMinutes;
  final String? mobile;
  final String? callingCode;
  final ChannelOptions channel;
  final List<ChannelOptions> channelOptions;

  RegisterResponse({
    required super.success,
    required super.message,
    required super.errorType,
    this.status,
    this.expiresInMinutes,
    this.mobile,
    this.callingCode,
    required this.channel,
    required this.channelOptions,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return RegisterResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      status: json['data']?['status'],
      expiresInMinutes: json['data']?['expiresInMinutes'],
      mobile: json['data']?['mobile'],
      callingCode: json['data']?['callingCode'],
      channel: ChannelOptions.fromString(
        json['data']?['channel'] as String? ?? '',
      ),
      channelOptions:
          (json['data']?['channelOptions'] as List<dynamic>?)
              ?.map((e) => ChannelOptions.fromString(e as String))
              .toList() ??
          [],
    );
  }
}

class UserResponse extends BasicResponse {
  final String? accessToken;
  final String? refreshToken;
  final User? user;

  UserResponse({
    required super.success,
    required super.message,
    required super.errorType,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return UserResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      accessToken: json['data']?['accessToken'],
      refreshToken: json['data']?['refreshToken'],
      user: json['data']?['user'] != null
          ? User.fromJson(json['data']['user'])
          : null,
    );
  }
}

class GetUserResponse extends BasicResponse {
  final User? user;

  GetUserResponse({
    required super.success,
    required super.message,
    required super.errorType,
    this.user,
  });

  factory GetUserResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return GetUserResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      user: json['data'] != null ? User.fromJson(json['data']) : null,
    );
  }
}

class User {
  final String id;
  final String status;
  final String createdAt;
  final String modifiedAt;
  final String fullName;
  final String mobile;
  final String callingCode;
  final String? roleId;
  final String? email;
  final String? image;
  final UserSettingsResponse settings;
  final List<dynamic> firebaseTokens;
  final UserLevel level;

  User({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.modifiedAt,
    required this.fullName,
    required this.mobile,
    required this.callingCode,
    required this.roleId,
    required this.settings,
    required this.firebaseTokens,
    required this.level,
    this.email,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      modifiedAt: json['modifiedAt'] ?? '',
      fullName: json['fullName'],
      mobile: json['mobile'],
      callingCode: json['callingCode'],
      roleId: json['roleId'],
      email: json['email'],
      settings: UserSettingsResponse.fromJson(json['settings']),
      firebaseTokens: json['firebaseTokens'] ?? [],
      level: UserLevel.fromString(json['level'] as String? ?? ''),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'status': status,
      'createdAt': createdAt,
      'modifiedAt': modifiedAt,
      'fullName': fullName,
      'mobile': mobile,
      'callingCode': callingCode,
      'roleId': roleId,
      'settings': settings.toJson(),
      'firebaseTokens': firebaseTokens,
      'email': email,
      'image': image,
      'level': level.name,
    };
  }
}

class UserSettingsResponse {
  final String language;
  final Currency currency;
  final String theme;

  UserSettingsResponse({
    required this.language,
    required this.currency,
    required this.theme,
  });

  factory UserSettingsResponse.fromJson(Map<String, dynamic> json) {
    return UserSettingsResponse(
      language: json['language'],
      currency: Currency.fromString(json['currency'])!,
      theme: json['theme'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'language': language, 'currency': currency.name, 'theme': theme};
  }
}

class MarketplaceCountry {
  final String countryCode;
  final String nameAr;
  final String nameEn;
  final List<String> providers;
  final Map<String, int> providerSkuIds;
  final String imageUrl;
  final String? featuredImageUrl;
  final String? noteEn;
  final String? noteAr;

  MarketplaceCountry({
    required this.countryCode,
    required this.nameAr,
    required this.nameEn,
    required this.providers,
    required this.providerSkuIds,
    required this.imageUrl,
    this.featuredImageUrl,
    this.noteAr,
    this.noteEn,
  });

  factory MarketplaceCountry.fromJson(Map<String, dynamic> json) {
    return MarketplaceCountry(
      countryCode: json['countryCode'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      providers: List<String>.from(json['providers'] ?? []),
      providerSkuIds: Map<String, int>.from(json['providerSkuIds'] ?? {}),
      imageUrl: json['imageUrl'] ?? '',
      featuredImageUrl: json['featuredImageUrl'],
      noteAr: json['noteAr'],
      noteEn: json['noteEn'],
    );
  }

  String displayName(Locale locale) {
    return locale.languageCode == 'en' ? nameEn : nameAr;
  }

  String? displayNote(Locale locale) {
    return locale.languageCode == 'en' ? noteEn : noteAr;
  }
}

class MarketplaceCountriesResponse extends BasicResponse {
  final int? count;
  final List<MarketplaceCountry>? data;

  MarketplaceCountriesResponse({
    required super.success,
    required super.message,
    required super.errorType,
    this.count,
    this.data,
  });

  factory MarketplaceCountriesResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    var innerData = json['data'];
    List<MarketplaceCountry>? countries;
    int? count;

    if (innerData != null && innerData is Map) {
      count = innerData['count'];
      if (innerData['data'] != null) {
        countries = (innerData['data'] as List)
            .map((e) => MarketplaceCountry.fromJson(e))
            .toList();
      }
    }

    return MarketplaceCountriesResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      count: count,
      data: countries,
    );
  }
}

class CoveredCountry {
  final String code;
  final String nameEn;
  final String nameAr;
  final String flag;
  final String? customNameEn;
  final String? customNameAr;

  CoveredCountry({
    required this.code,
    required this.nameEn,
    required this.nameAr,
    required this.flag,
    this.customNameEn,
    this.customNameAr,
  });

  factory CoveredCountry.fromJson(Map<String, dynamic> json) {
    return CoveredCountry(
      code: json['code'] ?? json['countryCode'],
      nameEn: json['name'] ?? json['nameEn'] ?? "",
      nameAr: json['nameAr'] ?? "",
      flag: json['flag'] ?? json['imageUrl'],
      customNameEn: json['customNameEn'],
      customNameAr: json['customNameAr'],
    );
  }

  String name(Locale locale) {
    return locale.languageCode == 'ar' ? nameAr : nameEn;
  }
}

class NetworkDto {
  final String type;
  final String operator;
  final String nameCn;
  final String nameEn;

  NetworkDto({
    required this.type,
    required this.operator,
    required this.nameCn,
    required this.nameEn,
  });

  factory NetworkDto.fromJson(Map<String, dynamic> json) {
    return NetworkDto(
      type: json['type'],
      operator: json['operator'],
      nameCn: json['namecn'],
      nameEn: json['nameen'],
    );
  }
}

class MarketplaceCountryPlan {
  final String id;
  final String countryCode;
  final String countryNameEn;
  final String countryNameAr;
  final List<String> countries;
  final List<CoveredCountry> coveredCountries;
  final List<NetworkDto> networkDtoList;
  final double dataAmount;
  final DataUnit dataUnit;
  final double totalDataInGB;
  final int validityDays;
  final double price;
  final Currency currency;
  final double pricePerDay;
  final double pricePerGB;
  final bool isRenewable;
  final bool isDaypass;
  final bool isUnlimited;
  final int? minDays;
  final int? maxDays;
  final String? countryImage;
  final String? noteEn;
  final String? noteAr;
  final String? fupPolicyEn;
  final String? fupPolicyAr;
  final String? badgeEn;
  final String? badgeAr;

  MarketplaceCountryPlan({
    required this.id,
    required this.countryCode,
    required this.countryNameEn,
    required this.countryNameAr,
    required this.countries,
    required this.coveredCountries,
    required this.networkDtoList,
    required this.dataAmount,
    required this.dataUnit,
    required this.totalDataInGB,
    required this.validityDays,
    required this.price,
    required this.currency,
    required this.pricePerDay,
    required this.pricePerGB,
    required this.isRenewable,
    required this.isDaypass,
    required this.isUnlimited,
    this.minDays,
    this.maxDays,
    this.countryImage,
    this.noteEn,
    this.noteAr,
    this.fupPolicyEn,
    this.fupPolicyAr,
    this.badgeEn,
    this.badgeAr,
  });

  factory MarketplaceCountryPlan.fromJson(Map<String, dynamic> json) {
    return MarketplaceCountryPlan(
      id: json['id'],
      countryCode: json['countryCode'],
      countryNameEn: json['countryName'],
      countryNameAr: json['countryNameAr'],
      countries: List<String>.from(json['countries'] ?? []),
      coveredCountries: List<CoveredCountry>.from(
        json['coveredCountries']?.map((x) => CoveredCountry.fromJson(x)) ?? [],
      ),
      networkDtoList: List<NetworkDto>.from(
        json['networkDtoList']?.map((x) => NetworkDto.fromJson(x)) ?? [],
      ),
      dataAmount: json['dataAmount']?.toDouble() ?? 0.0,
      dataUnit: DataUnit.values.firstWhere(
        (e) => e.name == json['dataUnit'],
        orElse: () => DataUnit.GB,
      ),
      totalDataInGB: json['totalDataInGB']?.toDouble() ?? 0.0,
      validityDays: json['validityDays'],
      price: json['price']?.toDouble() ?? 0.0,
      currency: Currency.fromString(json['currency'])!,
      pricePerDay: json['pricePerDay']?.toDouble() ?? 0.0,
      pricePerGB: json['pricePerGB']?.toDouble() ?? 0.0,
      isRenewable: json['isRenewable'],
      isDaypass: json['isDaypass'],
      isUnlimited: json['isUnlimited'] ?? false,
      minDays: json['minDays'],
      maxDays: json['maxDays'],
      countryImage: json['countryImage'],
      noteEn: json['noteEn'],
      noteAr: json['noteAr'],
      fupPolicyEn: json['FUPPolicyEn'],
      fupPolicyAr: json['FUPPolicyAr'],
      badgeEn: json['badgeEn'],
      badgeAr: json['badgeAr'],
    );
  }

  String countryName(Locale locale) {
    return locale.languageCode == 'ar' ? countryNameAr : countryNameEn;
  }

  String? displayNote(Locale locale) {
    return locale.languageCode == 'ar' ? noteAr : noteEn;
  }

  String? displayFupPolicy(Locale locale) {
    return locale.languageCode == 'ar' ? fupPolicyAr : fupPolicyEn;
  }

  String? displayBadge(Locale locale) {
    final badge = locale.languageCode == 'ar' ? badgeAr : badgeEn;
    return (badge != null && badge.isNotEmpty) ? badge : null;
  }
}

class MarketplaceCountryPlansResponse extends BasicResponse {
  final List<MarketplaceCountryPlan>? plans;
  final int? totalCount;

  MarketplaceCountryPlansResponse({
    required super.success,
    required super.message,
    required super.errorType,
    this.plans,
    this.totalCount,
  });

  factory MarketplaceCountryPlansResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    var innerData = json['data'];
    List<MarketplaceCountryPlan>? plans;
    int? totalCount;

    if (innerData != null && innerData is Map) {
      totalCount = innerData['totalCount'];
      if (innerData['plans'] != null) {
        plans = (innerData['plans'] as List)
            .map((e) => MarketplaceCountryPlan.fromJson(e))
            .toList();
      }
    }

    return MarketplaceCountryPlansResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      plans: plans,
      totalCount: totalCount,
    );
  }
}

class MarketplaceGlobalPlan {
  final String id;
  final double dataAmount;
  final DataUnit dataUnit;
  final int days;
  final double price;
  final double pricePerGB;
  final double pricePerDay;
  final List<CoveredCountry> coveredCountries;
  final List<NetworkDto> networkDtoList;
  final bool isRenewable;
  final bool isDaypass;
  final bool isUnlimited;
  final String countryImage;
  final String? noteEn;
  final String? noteAr;
  final String? fupPolicyEn;
  final String? fupPolicyAr;

  MarketplaceGlobalPlan({
    required this.id,
    required this.dataAmount,
    required this.dataUnit,
    required this.days,
    required this.price,
    required this.pricePerGB,
    required this.pricePerDay,
    required this.coveredCountries,
    required this.networkDtoList,
    required this.isRenewable,
    required this.isDaypass,
    required this.isUnlimited,
    required this.countryImage,
    this.noteEn,
    this.noteAr,
    this.fupPolicyEn,
    this.fupPolicyAr,
  });

  factory MarketplaceGlobalPlan.fromJson(Map<String, dynamic> json) {
    return MarketplaceGlobalPlan(
      id: json['id'],
      dataAmount: json['dataAmount']?.toDouble() ?? 0,
      dataUnit: DataUnit.values.firstWhere(
        (e) => e.name == json['dataUnit'],
        orElse: () => DataUnit.GB,
      ),
      days: json['days'],
      price: json['price']?.toDouble() ?? 0,
      pricePerGB: json['pricePerGB']?.toDouble() ?? 0,
      pricePerDay: json['pricePerDay']?.toDouble() ?? 0,
      coveredCountries: List<CoveredCountry>.from(
        json['coveredCountries']?.map((x) => CoveredCountry.fromJson(x)) ?? [],
      ),
      networkDtoList: List<NetworkDto>.from(
        json['networkDtoList']?.map((x) => NetworkDto.fromJson(x)) ?? [],
      ),
      isRenewable: json['isRenewable'],
      isDaypass: json['isDaypass'],
      isUnlimited: json['isUnlimited'] ?? false,
      countryImage: json['countryImage'] ?? '',
      noteEn: json['noteEn'],
      noteAr: json['noteAr'],
      fupPolicyEn: json['FUPPolicyEn'],
      fupPolicyAr: json['FUPPolicyAr'],
    );
  }

  String? displayNote(Locale locale) {
    return locale.languageCode == 'ar' ? noteAr : noteEn;
  }

  String? displayFupPolicy(Locale locale) {
    return locale.languageCode == 'ar' ? fupPolicyAr : fupPolicyEn;
  }
}

class MarketplaceGlobalPlansResponse extends BasicResponse {
  final int? plansCount;
  final double? startFromPrice;
  final Currency? currency;
  final List<MarketplaceGlobalPlan>? plans;

  MarketplaceGlobalPlansResponse({
    required super.success,
    required super.message,
    required super.errorType,
    this.plansCount,
    this.startFromPrice,
    this.currency,
    this.plans,
  });

  factory MarketplaceGlobalPlansResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    var innerData = json['data'];
    List<MarketplaceGlobalPlan>? plans;
    int? plansCount;
    double? startFromPrice;
    Currency? currency;

    if (innerData != null && innerData is Map) {
      plansCount = innerData['plansCount'];
      startFromPrice = innerData['startFromPrice']?.toDouble() ?? 0;
      currency = Currency.fromString(innerData['currency'])!;
      if (innerData['data'] != null) {
        plans = (innerData['data'] as List)
            .map((e) => MarketplaceGlobalPlan.fromJson(e))
            .toList();
      }
    }

    return MarketplaceGlobalPlansResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      plansCount: plansCount,
      startFromPrice: startFromPrice,
      currency: currency,
      plans: plans,
    );
  }
}

class MarketplaceRegionPlansResponse extends BasicResponse {
  final String? regionCode;
  final String? regionName;
  final int? plansCount;
  final List<MarketplaceGlobalPlan>? plans;

  MarketplaceRegionPlansResponse({
    required super.success,
    required super.message,
    required super.errorType,
    this.regionCode,
    this.regionName,
    this.plansCount,
    this.plans,
  });

  factory MarketplaceRegionPlansResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    var innerData = json['data'];
    List<MarketplaceGlobalPlan>? plans;
    String? regionCode;
    String? regionName;
    int? plansCount;

    if (innerData != null && innerData is Map) {
      regionCode = innerData['regionCode'];
      regionName = innerData['regionName'];
      plansCount = innerData['plansCount'];
      if (innerData['data'] != null) {
        plans = (innerData['data'] as List)
            .map((e) => MarketplaceGlobalPlan.fromJson(e))
            .toList();
      }
    }

    return MarketplaceRegionPlansResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      regionCode: regionCode,
      regionName: regionName,
      plansCount: plansCount,
      plans: plans,
    );
  }
}

//

class MarketplaceRegion {
  final String regionCode;
  final String regionNameEn;
  final String regionNameAr;
  final int plansCount;
  final int countriesCount;
  final double startFromPrice;
  final Currency currency;
  final String? noteEn;
  final String? noteAr;

  MarketplaceRegion({
    required this.regionCode,
    required this.regionNameEn,
    required this.regionNameAr,
    required this.plansCount,
    required this.countriesCount,
    required this.startFromPrice,
    required this.currency,
    this.noteEn,
    this.noteAr,
  });

  factory MarketplaceRegion.fromJson(Map<String, dynamic> json) {
    return MarketplaceRegion(
      regionCode: json['regionCode'],
      regionNameEn: json['regionName'],
      regionNameAr: json['regionNameAr'],
      plansCount: json['plansCount'],
      countriesCount: json['countriesCount'],
      startFromPrice: json['startFromPrice']?.toDouble() ?? 0,
      currency: Currency.fromString(json['currency'])!,
      noteEn: json['noteEn'],
      noteAr: json['noteAr'],
    );
  }

  String regionName(Locale locale) {
    return locale.languageCode == 'ar' ? regionNameAr : regionNameEn;
  }

  String? displayNote(Locale locale) {
    return locale.languageCode == 'ar' ? noteAr : noteEn;
  }
}

class MarketplaceRegionsResponse extends BasicResponse {
  final List<MarketplaceRegion>? data;

  MarketplaceRegionsResponse({
    required super.success,
    required super.message,
    required super.errorType,
    this.data,
  });

  factory MarketplaceRegionsResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    var innerData = json['data'];
    List<MarketplaceRegion>? regions;

    if (innerData != null && innerData is Map) {
      if (innerData['data'] != null) {
        regions = (innerData['data'] as List)
            .map((e) => MarketplaceRegion.fromJson(e))
            .toList();
      }
    }

    return MarketplaceRegionsResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      data: regions,
    );
  }
}

class MarketplaceSearchResponse extends BasicResponse {
  final List<MarketplaceCountryPlan>? plans;
  final int? totalCount;

  MarketplaceSearchResponse({
    required super.success,
    required super.message,
    required super.errorType,
    this.plans,
    this.totalCount,
  });

  factory MarketplaceSearchResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    var innerData = json['data'];
    List<MarketplaceCountryPlan>? plans;
    int? totalCount;

    if (innerData != null && innerData is Map) {
      totalCount = innerData['totalCount'];
      if (innerData['plans'] != null) {
        plans = (innerData['plans'] as List)
            .map((e) => MarketplaceCountryPlan.fromJson(e))
            .toList();
      }
    }

    return MarketplaceSearchResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      plans: plans,
      totalCount: totalCount,
    );
  }
}

class MarketplaceCountrySearchItem {
  final DestinationTap type;
  final String code;
  final String nameEn;
  final String nameAr;
  final String imageUrl;
  final String? featuredImageUrl;
  final String? noteEn;
  final String? noteAr;
  final String? customNameEn;
  final String? customNameAr;
  final List<CoveredCountry> coveredCountries;

  MarketplaceCountrySearchItem({
    required this.type,
    required this.code,
    required this.nameEn,
    required this.nameAr,
    required this.imageUrl,
    this.featuredImageUrl,
    this.noteEn,
    this.noteAr,
    this.customNameEn,
    this.customNameAr,
    required this.coveredCountries,
  });

  factory MarketplaceCountrySearchItem.fromJson(Map<String, dynamic> json) {
    return MarketplaceCountrySearchItem(
      type: DestinationTap.fromString(json['type'] ?? ''),
      code: json['code'] ?? '',
      nameEn: json['nameEn'] ?? '',
      nameAr: json['nameAr'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      featuredImageUrl: json['featuredImageUrl'],
      noteEn: json['noteEn'],
      noteAr: json['noteAr'],
      customNameEn: json['customNameEn'],
      customNameAr: json['customNameAr'],
      coveredCountries:
          (json['coveredCountries'] as List?)
              ?.map((e) => CoveredCountry.fromJson(e))
              .toList() ??
          [],
    );
  }

  String displayName(Locale locale) =>
      locale.languageCode == 'ar' ? nameAr : nameEn;

  String? displayNote(Locale locale) =>
      locale.languageCode == 'ar' ? noteAr : noteEn;
}

class MarketplaceCountrySearchData {
  final bool success;
  final int count;
  final List<MarketplaceCountrySearchItem> data;

  MarketplaceCountrySearchData({
    required this.success,
    required this.count,
    required this.data,
  });

  factory MarketplaceCountrySearchData.fromJson(Map<String, dynamic> json) {
    return MarketplaceCountrySearchData(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data:
          (json['data'] as List?)
              ?.map((e) => MarketplaceCountrySearchItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CountrySearchResponse extends BasicResponse {
  final MarketplaceCountrySearchData? data;

  CountrySearchResponse({
    required super.success,
    required super.message,
    super.errorType,
    this.data,
  });

  factory CountrySearchResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return CountrySearchResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      data: json['data'] != null
          ? MarketplaceCountrySearchData.fromJson(json['data'])
          : null,
    );
  }
}

class MarketplaceOrder {
  final String id;
  final String orderId;
  final String providerOrderId;
  final String countryNameEn;
  final String countryNameAr;
  final String provider;
  final EsimStatus status;
  final String country;
  final double dataAmount;
  final DataUnit dataUnit;
  final int days;
  final double price;
  final Currency currency;
  final List<EsimCard> esimCards;
  final String countryImage;
  final bool canRenew;
  final bool canRefund;
  final bool isUnlimited;
  final List<NetworkDto> networkDtoList;

  MarketplaceOrder({
    required this.id,
    required this.orderId,
    required this.providerOrderId,
    required this.countryNameEn,
    required this.countryNameAr,
    required this.provider,
    required this.status,
    required this.country,
    required this.dataAmount,
    required this.dataUnit,
    required this.days,
    required this.price,
    required this.currency,
    required this.esimCards,
    required this.countryImage,
    required this.canRenew,
    required this.canRefund,
    required this.isUnlimited,
    required this.networkDtoList,
  });

  factory MarketplaceOrder.fromJson(Map<String, dynamic> json) {
    return MarketplaceOrder(
      id: json['_id'] ?? "",
      orderId: json['orderId'] ?? "",
      providerOrderId: json['providerOrderId'] ?? "",
      provider: json['provider'] ?? "",
      countryNameEn: json['countryNameEn'] ?? "",
      countryNameAr: json['countryNameAr'] ?? "",
      status: EsimStatus.fromString(json['status'] ?? ""),
      country: json['country'] ?? "",
      dataAmount: json['dataAmount']?.toDouble() ?? 0,
      dataUnit: DataUnit.values.firstWhere(
        (e) => e.name == json['dataUnit'],
        orElse: () => DataUnit.GB,
      ),
      days: json['days'] ?? 0,
      price: json['price']?.toDouble() ?? 0,
      currency: Currency.fromString(json['currency'])!,
      canRenew: json['canRenew'] ?? false,
      canRefund: json['canRefund'] ?? false,
      isUnlimited: json['isUnlimited'] ?? false,
      esimCards:
          (json['esimCards'] as List?)
              ?.map((e) => EsimCard.fromJson(e))
              .toList() ??
          [],
      countryImage: json['countryImage'] ?? "",
      networkDtoList:
          (json['networkDtoList'] as List?)
              ?.map((e) => NetworkDto.fromJson(e))
              .toList() ??
          [],
    );
  }

  String getCountryName(Locale locale) =>
      locale.languageCode == 'ar' ? countryNameAr : countryNameEn;
}

class MarketplaceOrderResponse extends BasicResponse {
  final MarketplaceOrder? order;

  MarketplaceOrderResponse({
    required super.success,
    required super.message,
    required super.errorType,
    this.order,
  });

  factory MarketplaceOrderResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    var innerData = json['data'];
    MarketplaceOrder? order;

    if (innerData != null && innerData is Map) {
      // The nested structure has another 'data' field containing the order details
      var orderData = innerData['data'];
      if (orderData != null) {
        order = MarketplaceOrder.fromJson(orderData);
      }
    }

    return MarketplaceOrderResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      order: order,
    );
  }
}

class MarketplaceCurrency {
  final Currency currency;
  final String name;
  final bool isSelected;

  MarketplaceCurrency({
    required this.currency,
    required this.name,
    required this.isSelected,
  });

  factory MarketplaceCurrency.fromJson(Map<String, dynamic> json) {
    return MarketplaceCurrency(
      currency: Currency.fromString(json['code'])!,
      name: json['name'] ?? '',
      isSelected: json['isSelected'] ?? false,
    );
  }
}

class MinVersionResponse extends BasicResponse {
  final String? minIosVersion;
  final String? minAndroidVersion;

  MinVersionResponse({
    required super.success,
    required super.message,
    required super.errorType,
    this.minIosVersion,
    this.minAndroidVersion,
  });

  factory MinVersionResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return MinVersionResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      minIosVersion: json['data']?['minIosVersion'],
      minAndroidVersion: json['data']?['minAndroidVersion'],
    );
  }
}

class MarketplaceCurrenciesResponse extends BasicResponse {
  final int? count;
  final List<MarketplaceCurrency>? data;

  MarketplaceCurrenciesResponse({
    required super.success,
    required super.message,
    required super.errorType,
    this.count,
    this.data,
  });

  factory MarketplaceCurrenciesResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    var innerData = json['data'];
    List<MarketplaceCurrency>? currencies;
    int? count;

    if (innerData != null && innerData is Map) {
      count = innerData['count'];
      if (innerData['data'] != null) {
        currencies = (innerData['data'] as List)
            .map((e) => MarketplaceCurrency.fromJson(e))
            .toList();
      }
    }

    return MarketplaceCurrenciesResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      count: count,
      data: currencies,
    );
  }
}

class ApplyPromoResponse extends BasicResponse {
  final bool? valid;
  final String? code;
  final String? discountType;
  final double? discountValue;
  final double? discountAmount;
  final double? finalPrice;
  final String? currency;
  final String? dataMessage;

  ApplyPromoResponse({
    required super.success,
    required super.message,
    required super.errorType,
    this.valid,
    this.code,
    this.discountType,
    this.discountValue,
    this.discountAmount,
    this.finalPrice,
    this.currency,
    this.dataMessage,
  });

  factory ApplyPromoResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return ApplyPromoResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      valid: json['valid'] ?? json['data']?['valid'],
      code: json['code'] ?? json['data']?['code'],
      discountType: json['discountType'] ?? json['data']?['discountType'],
      discountValue: (json['discountValue'] ?? json['data']?['discountValue'])
          ?.toDouble(),
      discountAmount:
          (json['discountAmount'] ?? json['data']?['discountAmount'])
              ?.toDouble(),
      finalPrice: (json['finalPrice'] ?? json['data']?['finalPrice'])
          ?.toDouble(),
      currency: json['currency'] ?? json['data']?['currency'],
      dataMessage: json['data']?['message'],
    );
  }
}

class HomeSlider {
  final String id;
  final String titleEn;
  final String titleAr;
  final String image;
  final String link;
  final int order;
  final bool isActive;
  final String type;
  final String createdAt;
  final String updatedAt;

  HomeSlider({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.image,
    required this.link,
    required this.order,
    required this.isActive,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HomeSlider.fromJson(Map<String, dynamic> json) {
    return HomeSlider(
      id: json['_id'],
      titleEn: json['titleEn'] ?? '',
      titleAr: json['titleAr'] ?? '',
      image: json['image'] ?? '',
      link: json['link'] ?? '',
      order: json['order'] ?? 0,
      isActive: json['isActive'] ?? false,
      type: json['type'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class HomeSlidersResponse extends BasicResponse {
  final List<HomeSlider>? data;

  HomeSlidersResponse({
    required super.success,
    required super.message,
    required super.errorType,
    this.data,
  });

  factory HomeSlidersResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    List<HomeSlider>? data;

    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List).map((e) => HomeSlider.fromJson(e)).toList();
    }

    return HomeSlidersResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      data: data,
    );
  }
}

class ReferralResponse extends BasicResponse {
  final ReferralData? data;

  ReferralResponse({
    required super.success,
    required super.message,
    super.errorType,
    this.data,
  });

  factory ReferralResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return ReferralResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      data: json['data'] != null ? ReferralData.fromJson(json['data']) : null,
    );
  }
}

class ReferralData {
  final String code;
  final int usageCount;
  final double totalGainedAmount;
  final Currency currency;
  final ReferralInfo info;

  ReferralData({
    required this.code,
    required this.usageCount,
    required this.totalGainedAmount,
    required this.currency,
    required this.info,
  });

  factory ReferralData.fromJson(Map<String, dynamic> json) {
    return ReferralData(
      code: json['code'],
      usageCount: json['usageCount'],
      totalGainedAmount: (json['totalGainedAmount'] as num).toDouble(),
      currency: Currency.fromString(json['currency'])!,
      info: ReferralInfo.fromJson(json['info']),
    );
  }
}

class ReferralInfo {
  final String discountType;
  final double discountValue;
  final String commissionType;
  final double commissionValue;
  final double maxCommissionAmount;

  ReferralInfo({
    required this.discountType,
    required this.discountValue,
    required this.commissionType,
    required this.commissionValue,
    required this.maxCommissionAmount,
  });

  factory ReferralInfo.fromJson(Map<String, dynamic> json) {
    return ReferralInfo(
      discountType: json['discountType'],
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0,
      commissionType: json['commissionType'],
      commissionValue: (json['commissionValue'] as num?)?.toDouble() ?? 0,
      maxCommissionAmount:
          (json['maxCommissionAmount'] as num?)?.toDouble() ?? 0,
    );
  }
}

class NotificationModel {
  final String id;
  final String type;
  final String titleEn;
  final String? titleAr;
  final String bodyEn;
  final String? bodyAr;
  final String status;
  final DateTime sentAt;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
    required this.status,
    required this.sentAt,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      titleEn: json['title'],
      titleAr: json['titleAr'],
      bodyEn: json['body'],
      bodyAr: json['bodyAr'],
      status: json['status'],
      sentAt: DateTime.parse(json['sentAt']),
      isRead: json['isRead'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  String body(Locale locale) {
    return locale.languageCode == 'ar' ? (bodyAr ?? bodyEn) : bodyEn;
  }

  String title(Locale locale) {
    return locale.languageCode == 'ar' ? (titleAr ?? titleEn) : titleEn;
  }
}

class NotificationListResponse extends BasicResponse {
  final List<NotificationModel>? data;
  final Pagination? pagination;

  NotificationListResponse({
    required super.success,
    required super.message,
    super.errorType,
    this.data,
    this.pagination,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return NotificationListResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      data: json['data'] != null
          ? (json['data'] as List)
                .map((e) => NotificationModel.fromJson(e))
                .toList()
          : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class Pagination {
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  Pagination({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      page: json['page'],
      pageSize: json['pageSize'],
      totalPages: json['totalPages'],
    );
  }
}

class UnreadNotificationCountResponse extends BasicResponse {
  final int count;

  UnreadNotificationCountResponse({
    required super.success,
    required super.message,
    super.errorType,
    required this.count,
  });

  factory UnreadNotificationCountResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return UnreadNotificationCountResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      count: json['data']?['count'] ?? 0,
    );
  }
}

class WalletBalanceResponse extends BasicResponse {
  final double balance;
  final Currency currency;

  WalletBalanceResponse({
    required super.success,
    required super.message,
    super.errorType,
    required this.balance,
    required this.currency,
  });

  factory WalletBalanceResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return WalletBalanceResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      balance: (json['data']['balance'] as num?)?.toDouble() ?? 0.0,
      currency: Currency.fromString(json['data']['currency'])!,
    );
  }
}

class WalletTransactionModel {
  final String id;
  final double amount;
  final Currency currency;
  final String type;
  final TransactionReason reason;
  final String? description;
  final double? remaining;
  final DateTime? expireAt;
  final DateTime createdAt;

  WalletTransactionModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.type,
    required this.reason,
    this.description,
    this.remaining,
    this.expireAt,
    required this.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      currency: Currency.fromString(json['currency'])!,
      type: json['type'],
      reason:
          TransactionReason.fromString(json['reason']) ??
          TransactionReason.other,
      description: json['description'],
      remaining: (json['remaining'] as num?)?.toDouble(),
      expireAt: json['expireAt'] != null
          ? DateTime.parse(json['expireAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class WalletTransactionsResponse extends BasicResponse {
  final List<WalletTransactionModel>? data;
  final Pagination? pagination;

  WalletTransactionsResponse({
    required super.success,
    required super.message,
    super.errorType,
    this.data,
    this.pagination,
  });

  factory WalletTransactionsResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return WalletTransactionsResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      data: json['data'] != null
          ? (json['data'] as List)
                .map((e) => WalletTransactionModel.fromJson(e))
                .toList()
          : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class CreatePaymentResponse extends BasicResponse {
  final PaymentInvoice? invoice;

  CreatePaymentResponse({
    required super.success,
    required super.message,
    super.errorType,
    this.invoice,
  });

  factory CreatePaymentResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return CreatePaymentResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      invoice: json['data'] != null
          ? PaymentInvoice.fromJson(json['data'])
          : null,
    );
  }
}

class PaymentInvoice {
  final String invoiceId;
  final String invoiceStatus;
  final String redirectUrl;
  final double amountToPay;
  final double walletAmountUsed;
  final String? promoCode;
  final double discountAmount;

  PaymentInvoice({
    required this.invoiceId,
    required this.invoiceStatus,
    required this.redirectUrl,
    required this.amountToPay,
    required this.walletAmountUsed,
    required this.discountAmount,
    this.promoCode,
  });

  factory PaymentInvoice.fromJson(Map<String, dynamic> json) {
    return PaymentInvoice(
      invoiceId: json['invoiceId'] ?? '',
      invoiceStatus: json['invoiceStatus'] ?? '',
      redirectUrl: json['redirectUrl'] ?? '',
      amountToPay: (json['amountToPay'] as num?)?.toDouble() ?? 0.0,
      walletAmountUsed: (json['walletAmountUsed'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      promoCode: json['promoCode'],
    );
  }
}

class CheckoutPackage {
  final String id;
  final String nameEn;
  final String nameAr;
  final String countryNameEn;
  final String countryNameAr;
  final double dataAmount;
  final DataUnit dataUnit;
  final int days;
  final List<String> countryCodes;
  final bool isRenewable;
  final bool isDaypass;
  final bool isUnlimited;
  final String imageUrl;

  CheckoutPackage({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.countryNameEn,
    required this.countryNameAr,
    required this.dataAmount,
    required this.dataUnit,
    required this.days,
    required this.countryCodes,
    required this.isRenewable,
    required this.isDaypass,
    required this.isUnlimited,
    required this.imageUrl,
  });

  factory CheckoutPackage.fromJson(Map<String, dynamic> json) {
    return CheckoutPackage(
      id: json['id'] ?? '',
      nameEn: json['nameEn'] ?? '',
      nameAr: json['nameAr'] ?? '',
      countryNameEn: json['countryNameEn'] ?? '',
      countryNameAr: json['countryNameAr'] ?? '',
      dataAmount: (json['dataAmount'] ?? 0).toDouble(),
      dataUnit: DataUnit.values.firstWhere((e) => e.name == json['dataUnit']),
      days: json['days'] ?? 0,
      countryCodes: List<String>.from(json['countryCodes'] ?? []),
      isRenewable: json['isRenewable'] ?? false,
      isDaypass: json['isDaypass'] ?? false,
      isUnlimited: json['isUnlimited'] ?? false,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  String name(Locale locale) => locale.languageCode == 'ar' ? nameAr : nameEn;
  String countryName(Locale locale) =>
      locale.languageCode == 'ar' ? countryNameAr : countryNameEn;
}

class CheckoutPricing {
  final double amount;
  final double vat;
  final double total;
  final double vatRate;
  final String currency;

  CheckoutPricing({
    required this.amount,
    required this.vat,
    required this.total,
    required this.vatRate,
    required this.currency,
  });

  factory CheckoutPricing.fromJson(Map<String, dynamic> json) {
    return CheckoutPricing(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      vat: (json['vat'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      vatRate: (json['vatRate'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? '',
    );
  }
}

class CheckoutData {
  final CheckoutPackage package;
  final CheckoutPricing pricing;
  final List<CoveredCountry> coveredCountries;

  CheckoutData({
    required this.package,
    required this.pricing,
    required this.coveredCountries,
  });

  factory CheckoutData.fromJson(Map<String, dynamic> json) {
    return CheckoutData(
      package: CheckoutPackage.fromJson(json['package'] ?? {}),
      pricing: CheckoutPricing.fromJson(json['pricing'] ?? {}),
      coveredCountries:
          (json['coveredCountries'] as List?)
              ?.map((e) => CoveredCountry.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class RenewalPackage {
  final String packageId;
  final double dataAmount;
  final DataUnit dataUnit;
  final int days;
  final double price;
  final Currency currency;
  final bool isDaypass;
  final bool isFUP;
  final bool isUnlimited;
  final String? fupPolicyEn;
  final String? fupPolicyAr;
  final String nameEn;
  final String nameAr;
  final bool canRenew;

  RenewalPackage({
    required this.packageId,
    required this.dataAmount,
    required this.dataUnit,
    required this.days,
    required this.price,
    required this.currency,
    required this.isDaypass,
    required this.isFUP,
    required this.isUnlimited,
    this.fupPolicyEn,
    this.fupPolicyAr,
    required this.nameEn,
    required this.nameAr,
    required this.canRenew,
  });

  factory RenewalPackage.fromJson(Map<String, dynamic> json) {
    return RenewalPackage(
      packageId: json['packageId'] ?? '',
      dataAmount: (json['dataAmount'] as num?)?.toDouble() ?? 0.0,
      dataUnit: DataUnit.values.firstWhere((e) => e.name == json['dataUnit']),
      days: json['days'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: Currency.values.firstWhere((e) => e.name == json['currency']),
      isDaypass: json['isDaypass'] ?? false,
      isFUP: json['isFUP'] ?? false,
      isUnlimited: json['isUnlimited'] ?? false,
      fupPolicyEn: json['FUPPolicyEn'],
      fupPolicyAr: json['FUPPolicyAr'],
      nameEn: json['nameEn'] ?? '',
      nameAr: json['nameAr'] ?? '',
      canRenew: json['canRenew'] ?? false,
    );
  }

  String name(Locale locale) {
    return locale.languageCode == 'ar' ? nameAr : nameEn;
  }

  String? displayFupPolicy(Locale locale) {
    return locale.languageCode == 'ar' ? fupPolicyAr : fupPolicyEn;
  }
}

class RenewalOptionsData {
  final bool canRenew;
  final String iccid;
  final List<RenewalPackage> availablePackages;

  RenewalOptionsData({
    required this.canRenew,
    required this.iccid,
    required this.availablePackages,
  });

  factory RenewalOptionsData.fromJson(Map<String, dynamic> json) {
    return RenewalOptionsData(
      canRenew: json['canRenew'] ?? false,
      iccid: json['iccid'] ?? '',
      availablePackages:
          (json['availablePackages'] as List?)
              ?.map((e) => RenewalPackage.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class RenewalOptionsResponse extends BasicResponse {
  final RenewalOptionsData? data;

  RenewalOptionsResponse({
    required super.success,
    required super.message,
    required super.errorType,
    this.data,
  });

  factory RenewalOptionsResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return RenewalOptionsResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      data: json['data']?["data"] != null
          ? RenewalOptionsData.fromJson(json['data']?["data"])
          : null,
    );
  }
}

class CheckoutResponse extends BasicResponse {
  final CheckoutData? data;

  CheckoutResponse({
    required super.success,
    required super.message,
    required super.errorType,
    this.data,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    var innerData = json['data'];
    CheckoutData? data;

    if (innerData != null && innerData is Map) {
      if (innerData['data'] != null) {
        data = CheckoutData.fromJson(innerData['data']);
      }
    }

    return CheckoutResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      data: data,
    );
  }
}

class OrderPaymentMethod {
  final String type;
  final String? brand;
  final String? last4;

  OrderPaymentMethod({required this.type, this.brand, this.last4});

  factory OrderPaymentMethod.fromJson(Map<String, dynamic> json) {
    return OrderPaymentMethod(
      type: json['type'] ?? '',
      brand: json['brand'],
      last4: json['last4'],
    );
  }
}

class OrderHistoryItem {
  final String id;
  final String countryNameEn;
  final String countryNameAr;
  final String countryCode;
  final String countryImage;
  final DateTime date;
  final double dataAmount;
  final DataUnit dataUnit;
  final int validityDays;
  final OrderPaymentMethod? paymentMethod;
  final double price;
  final Currency currency;
  final EsimStatus status;
  final bool isUnlimited;

  OrderHistoryItem({
    required this.id,
    required this.countryNameEn,
    required this.countryNameAr,
    required this.countryCode,
    required this.countryImage,
    required this.date,
    required this.dataAmount,
    required this.dataUnit,
    required this.validityDays,
    required this.paymentMethod,
    required this.price,
    required this.currency,
    required this.status,
    required this.isUnlimited,
  });

  factory OrderHistoryItem.fromJson(Map<String, dynamic> json) {
    return OrderHistoryItem(
      id: json['id'] ?? '',
      countryNameEn: json['countryNameEn'] ?? '',
      countryNameAr: json['countryNameAr'] ?? '',
      countryCode: json['countryCode'] ?? '',
      countryImage: json['countryImage'] ?? '',
      date: DateTime.parse(json['date'] ?? ''),
      dataAmount: (json['dataAmount'] as num?)?.toDouble() ?? 0.0,
      dataUnit: DataUnit.values.firstWhere((e) => e.name == json['dataUnit']),
      validityDays: json['validityDays'] ?? 0,
      paymentMethod: json['paymentMethod'] != null
          ? OrderPaymentMethod.fromJson(json['paymentMethod'])
          : null,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: Currency.fromString(json['currency'] ?? '')!,
      status: EsimStatus.fromString(json['status'] ?? ''),
      isUnlimited: json['isUnlimited'] ?? false,
    );
  }

  String countryName(Locale locale) =>
      locale.languageCode == 'ar' ? countryNameAr : countryNameEn;
}

class OrderHistoryResponse extends BasicResponse {
  final List<OrderHistoryItem>? data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  OrderHistoryResponse({
    required super.success,
    required super.message,
    super.errorType,
    this.data,
    this.total = 0,
    this.page = 0,
    this.limit = 0,
    this.totalPages = 0,
  });

  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return OrderHistoryResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      data: (json['data']?["data"] as List?)
          ?.map((e) => OrderHistoryItem.fromJson(e))
          .toList(),
      total: json['data']?["pagination"]?["total"]?.toInt() ?? 0,
      page: json['data']?["pagination"]?["page"]?.toInt() ?? 0,
      limit: json['data']?["pagination"]?["limit"]?.toInt() ?? 0,
      totalPages: json['data']?["pagination"]?["totalPages"]?.toInt() ?? 0,
    );
  }
}

class EsimCard {
  final String iccid;
  final String qrCode;
  final String? iosInstallLink;
  final EsimStatus status;
  final double? dataUsedMB;
  final double? dataTotalMB;
  final double? dataRemainingMB;
  final double? usagePercentage;
  final String? validUntil;
  final int? daysRemaining;
  final String smdpAddress;
  final String activationCode;

  EsimCard({
    required this.iccid,
    required this.qrCode,
    this.iosInstallLink,
    required this.status,
    this.dataUsedMB,
    this.dataTotalMB,
    this.dataRemainingMB,
    this.usagePercentage,
    this.validUntil,
    this.daysRemaining,
    required this.smdpAddress,
    required this.activationCode,
  });

  factory EsimCard.fromJson(Map<String, dynamic> json) {
    return EsimCard(
      iccid: json['iccid'] ?? '',
      qrCode: json['qrCode'] ?? '',
      iosInstallLink: json['iosInstallLink'],
      status: EsimStatus.fromString(json['status'] ?? ''),
      dataUsedMB: (json['dataUsedMB'] as num?)?.toDouble(),
      dataTotalMB: (json['dataTotalMB'] as num?)?.toDouble(),
      dataRemainingMB: (json['dataRemainingMB'] as num?)?.toDouble(),
      usagePercentage: (json['usagePercentage'] as num?)?.toDouble(),
      validUntil: json['validUntil'],
      daysRemaining: json['daysRemaining'],
      smdpAddress: json['smdpAddress'] ?? '',
      activationCode: json['activationCode'] ?? '',
    );
  }
}

class MyOrderItem {
  final String id;
  final String orderId;
  final String? providerOrderNum;
  final String provider;
  final String countryCode;
  final String display;
  final String countryName;
  final String countryNameEn;
  final String countryNameAr;
  final String purchaseDate;
  final double? price;
  final Currency? currency;
  final EsimStatus status;
  final double dataAmount;
  final DataUnit dataUnit;
  final int days;
  final List<EsimCard> esimCards;
  final String countryImage;
  final bool canRenew;
  final bool canRefund;
  final bool isUnlimited;

  MyOrderItem({
    required this.id,
    required this.orderId,
    required this.provider,
    required this.countryCode,
    required this.display,
    required this.countryName,
    required this.countryNameEn,
    required this.countryNameAr,
    required this.purchaseDate,
    this.price,
    this.currency,
    required this.status,
    required this.dataAmount,
    required this.dataUnit,
    required this.days,
    required this.esimCards,
    this.providerOrderNum,
    required this.countryImage,
    required this.canRenew,
    required this.canRefund,
    required this.isUnlimited,
  });

  factory MyOrderItem.fromJson(Map<String, dynamic> json) {
    return MyOrderItem(
      id: json['_id'] ?? "",
      orderId: json['orderId'] ?? '',
      providerOrderNum: json['providerOrderNum'],
      provider: json['provider'] ?? '',
      countryCode: json['countryCode'] ?? '',
      display: json['display'] ?? '',
      countryName: json['countryName'] ?? '',
      countryNameEn: json['countryNameEn'] ?? '',
      countryNameAr: json['countryNameAr'] ?? '',
      purchaseDate: json['purchaseDate'] ?? '',
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      currency: json['currency'] != null
          ? Currency.fromString(json['currency'])
          : null,
      status: EsimStatus.fromString(json['status'] ?? ''),
      dataAmount: (json['dataAmount'] as num?)?.toDouble() ?? 0.0,
      countryImage: json['countryImage'] ?? '',
      dataUnit: DataUnit.values.firstWhere(
        (e) => e.name == (json['dataUnit'] ?? ''),
      ),
      days: json['days'] ?? 0,
      esimCards:
          (json['esimCards'] as List?)
              ?.map((e) => EsimCard.fromJson(e))
              .toList() ??
          [],
      canRenew: json['canRenew'] ?? false,
      canRefund: json['canRefund'] ?? false,
      isUnlimited: json['isUnlimited'] ?? false,
    );
  }

  String countryNameLocale(Locale locale) =>
      locale.languageCode == 'en' ? countryNameEn : countryNameAr;
}

class MyOrdersResponse extends BasicResponse {
  final List<MyOrderItem>? data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  MyOrdersResponse({
    required super.success,
    required super.message,
    super.errorType,
    this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory MyOrdersResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return MyOrdersResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      data: (json['data']?["data"] as List?)
          ?.map((e) => MyOrderItem.fromJson(e))
          .toList(),
      total: json['data']?["pagination"]?["total"]?.toInt() ?? 0,
      page: json['data']?["pagination"]?["page"]?.toInt() ?? 0,
      limit: json['data']?["pagination"]?["limit"]?.toInt() ?? 0,
      totalPages: json['data']?["pagination"]?["totalPages"]?.toInt() ?? 0,
    );
  }
}

class FeaturedCountry {
  final String countryCode;
  final String nameEn;
  final String nameAr;
  final String imageUrl;
  final String? featuredImageUrl;
  final int displayOrder;
  final double? startAt;
  final String? currency;
  final String? noteEn;
  final String? noteAr;

  FeaturedCountry({
    required this.countryCode,
    required this.nameEn,
    required this.nameAr,
    required this.imageUrl,
    required this.featuredImageUrl,
    required this.displayOrder,
    this.startAt,
    this.currency,
    this.noteEn,
    this.noteAr,
  });

  factory FeaturedCountry.fromJson(Map<String, dynamic> json) {
    return FeaturedCountry(
      countryCode: json['countryCode'] ?? '',
      nameEn: json['nameEn'] ?? '',
      nameAr: json['nameAr'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      featuredImageUrl: json['featuredImageUrl'],
      displayOrder: json['displayOrder'] ?? 0,
      startAt: json['startAt']?.toDouble(),
      currency: json['currency'],
      noteEn: json['noteEn'],
      noteAr: json['noteAr'],
    );
  }

  String displayName(Locale locale) =>
      locale.languageCode == 'en' ? nameEn : nameAr;

  String? displayNote(Locale locale) =>
      locale.languageCode == 'en' ? noteEn : noteAr;
}

class FeaturedCountriesData {
  final bool success;
  final int count;
  final List<FeaturedCountry> data;

  FeaturedCountriesData({
    required this.success,
    required this.count,
    required this.data,
  });

  factory FeaturedCountriesData.fromJson(Map<String, dynamic> json) {
    return FeaturedCountriesData(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data:
          (json['data'] as List?)
              ?.map((e) => FeaturedCountry.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class FeaturedCountriesResponse extends BasicResponse {
  final FeaturedCountriesData? data;

  FeaturedCountriesResponse({
    required super.success,
    required super.message,
    super.errorType,
    this.data,
  });

  factory FeaturedCountriesResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return FeaturedCountriesResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      data: json['data'] != null
          ? FeaturedCountriesData.fromJson(json['data'])
          : null,
    );
  }
}

class LegalPolicyItemResponse {
  final String id;
  final String? slug;
  final String titleEnHtml;
  final String titleArHtml;
  final String contentEnHtml;
  final String contentArHtml;
  final int order;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  LegalPolicyItemResponse({
    required this.id,
    this.slug,
    required this.titleEnHtml,
    required this.titleArHtml,
    required this.contentEnHtml,
    required this.contentArHtml,
    required this.order,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LegalPolicyItemResponse.fromJson(Map<String, dynamic> json) {
    return LegalPolicyItemResponse(
      id: json['_id'] ?? '',
      slug: json['slug'],
      titleEnHtml: json['titleEn'] ?? json['title_en_html'] ?? '',
      titleArHtml: json['titleAr'] ?? json['title_ar_html'] ?? '',
      contentEnHtml: json['contentEn'] ?? json['content_en_html'] ?? '',
      contentArHtml: json['contentAr'] ?? json['content_ar_html'] ?? '',
      order: json['order'] ?? 0,
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  String title(Locale locale) =>
      locale.languageCode == 'en' ? titleEnHtml : titleArHtml;

  String content(Locale locale) =>
      locale.languageCode == 'en' ? contentEnHtml : contentArHtml;
}

class LegalPoliciesResponse extends BasicResponse {
  final List<LegalPolicyItemResponse>? data;

  LegalPoliciesResponse({
    required super.success,
    required super.message,
    super.errorType,
    this.data,
  });

  factory LegalPoliciesResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return LegalPoliciesResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      data: (json['data'] as List?)
          ?.map((e) => LegalPolicyItemResponse.fromJson(e))
          .toList(),
    );
  }
}

class GetLegalPolicyResponse extends BasicResponse {
  final LegalPolicyItemResponse? data;

  GetLegalPolicyResponse({
    required super.success,
    required super.message,
    super.errorType,
    this.data,
  });

  factory GetLegalPolicyResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return GetLegalPolicyResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      data: json['data'] != null
          ? LegalPolicyItemResponse.fromJson(json['data'])
          : null,
    );
  }
}

class InstallationInstructionsVideoResponse {
  final String? iosDirectInstallVideoUrlEn;
  final String? iosDirectInstallVideoUrlAr;
  final String? iosQrInstallVideoUrlEn;
  final String? iosQrInstallVideoUrlAr;
  final String? iosManualInstallVideoUrlEn;
  final String? iosManualInstallVideoUrlAr;
  final String? androidQrInstallVideoUrlEn;
  final String? androidQrInstallVideoUrlAr;
  final String? androidManualInstallVideoUrlEn;
  final String? androidManualInstallVideoUrlAr;

  InstallationInstructionsVideoResponse({
    this.iosDirectInstallVideoUrlEn,
    this.iosDirectInstallVideoUrlAr,
    this.iosQrInstallVideoUrlEn,
    this.iosQrInstallVideoUrlAr,
    this.iosManualInstallVideoUrlEn,
    this.iosManualInstallVideoUrlAr,
    this.androidQrInstallVideoUrlEn,
    this.androidQrInstallVideoUrlAr,
    this.androidManualInstallVideoUrlEn,
    this.androidManualInstallVideoUrlAr,
  });

  factory InstallationInstructionsVideoResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return InstallationInstructionsVideoResponse(
      iosDirectInstallVideoUrlEn: json['iosDirectInstallVideoUrlEn'],
      iosDirectInstallVideoUrlAr: json['iosDirectInstallVideoUrlAr'],
      iosQrInstallVideoUrlEn: json['iosQrInstallVideoUrlEn'],
      iosQrInstallVideoUrlAr: json['iosQrInstallVideoUrlAr'],
      iosManualInstallVideoUrlEn: json['iosManualInstallVideoUrlEn'],
      iosManualInstallVideoUrlAr: json['iosManualInstallVideoUrlAr'],
      androidQrInstallVideoUrlEn: json['androidQrInstallVideoUrlEn'],
      androidQrInstallVideoUrlAr: json['androidQrInstallVideoUrlAr'],
      androidManualInstallVideoUrlEn: json['androidManualInstallVideoUrlEn'],
      androidManualInstallVideoUrlAr: json['androidManualInstallVideoUrlAr'],
    );
  }
}

class EsimSettingsResponse {
  final InstallationInstructionsVideoResponse? installInstructions;

  EsimSettingsResponse({this.installInstructions});

  factory EsimSettingsResponse.fromJson(Map<String, dynamic> json) {
    return EsimSettingsResponse(
      installInstructions: json['installInstructions'] != null
          ? InstallationInstructionsVideoResponse.fromJson(
              json['installInstructions'],
            )
          : null,
    );
  }
}

class SettingsResponse extends BasicResponse {
  final SettingMinVersionResponse? minVersion;
  final ContactResponse? contact;
  final EsimSettingsResponse? esim;

  SettingsResponse({
    required super.success,
    required super.message,
    super.errorType,
    this.minVersion,
    this.contact,
    this.esim,
  });

  factory SettingsResponse.fromJson(Map<String, dynamic> json) {
    var r = BasicResponse.fromJson(json);
    return SettingsResponse(
      success: r.success,
      message: r.message,
      errorType: r.errorType,
      minVersion: json['data']?['minVersion'] != null
          ? SettingMinVersionResponse.fromJson(json['data']['minVersion'])
          : null,
      contact: json['data']?['contact'] != null
          ? ContactResponse.fromJson(json['data']['contact'])
          : null,
      esim: json['data']?['esim'] != null
          ? EsimSettingsResponse.fromJson(json['data']['esim'])
          : null,
    );
  }
}

class SettingMinVersionResponse {
  final String ios;
  final String android;

  SettingMinVersionResponse({required this.ios, required this.android});

  factory SettingMinVersionResponse.fromJson(Map<String, dynamic> json) {
    return SettingMinVersionResponse(
      ios: json['ios'] ?? '',
      android: json['android'] ?? '',
    );
  }
}

class ContactResponse {
  final String whatsapp;
  final String email;

  ContactResponse({required this.whatsapp, required this.email});

  factory ContactResponse.fromJson(Map<String, dynamic> json) {
    return ContactResponse(
      whatsapp: json['whatsapp'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
