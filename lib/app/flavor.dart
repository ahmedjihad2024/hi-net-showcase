import 'package:hi_net/app/constants.dart';

enum Flavor {
  dev,
  prod;

  bool get isDev => this == Flavor.dev;
  bool get isProd => this == Flavor.prod;
}

class FlavorConfig {
  final Flavor flavor;
  final String profileId;
  final String serverKey;
  final String clientKey;
  final String baseUrl;

  static FlavorConfig? _instance;

  FlavorConfig._({
    required this.flavor,
    required this.profileId,
    required this.serverKey,
    required this.clientKey,
    required this.baseUrl,
  });

  factory FlavorConfig.fromFlavor(Flavor flavor) {
    _instance = switch (flavor) {
      Flavor.dev => FlavorConfig._(
        flavor: flavor,
        profileId: Constants.profileIdTest,
        serverKey: Constants.serverKeyTest,
        clientKey: Constants.clientKeyTest,
        baseUrl: Constants.baseUrlTest,
      ),
      Flavor.prod => FlavorConfig._(
        flavor: flavor,
        profileId: Constants.profileIdProd,
        serverKey: Constants.serverKeyProd,
        clientKey: Constants.clientKeyProd,
        baseUrl: Constants.baseUrlProd,
      ),
    };
    return _instance!;
  }

  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception('FlavorConfig not initialized');
    }
    return _instance!;
  }

  static bool get isDev => instance.flavor.isDev;
  static bool get isProd => instance.flavor.isProd;
}
