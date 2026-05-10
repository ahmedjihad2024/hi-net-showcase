
// NOTE: this validator does not contains all
// the world country code

/// Represents a country with its associated information.
class Country {
  /// The name of the country.
  final String name;

  /// The ISO 3166-1 alpha-2 code of the country.
  final String isoCode;

  /// The international dialing code of the country.
  final String dialCode;

  /// The minimum length of a phone number in the country.
  final int phoneMinLength;

  /// The maximum length of a phone number in the country.
  final int phoneMaxLength;

  /// The starting digits of the phone number in the country.
  final List<String> startingDigits;

  Country(
    this.name,
    this.isoCode,
    this.dialCode,
    this.phoneMinLength,
    this.phoneMaxLength, {
    this.startingDigits = const [],
  });

  /// Gets the normalized dial code (digits only, no formatting).
  String get normalizedDialCode => dialCode.replaceAll(RegExp(r'[^\d+]'), '');

  /// Checks if a phone number length is valid for this country.
  bool isValidLength(int length) {
    return length >= phoneMinLength && length <= phoneMaxLength;
  }

  @override
  String toString() => '$name ($isoCode) $dialCode';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          isoCode == other.isoCode;

  @override
  int get hashCode => isoCode.hashCode;
}

List<Country> countries = [
  Country("Afghanistan", "AF", "+93", 9, 9),
  Country("Albania", "AL", "+355", 9, 9),
  Country("Algeria", "DZ", "+213", 9, 9),
  Country("Andorra", "AD", "+376", 6, 6),
  Country("Angola", "AO", "+244", 9, 9),
  Country("Argentina", "AR", "+54", 10, 10),
  Country("Armenia", "AM", "+374", 8, 8),
  Country("Australia", "AU", "+61", 9, 9),
  Country("Austria", "AT", "+43", 10, 10),
  Country("Azerbaijan", "AZ", "+994", 9, 9),
  Country("Bahamas", "BS", "+1-242", 10, 10),
  Country("Bahrain", "BH", "+973", 8, 8),
  Country("Bangladesh", "BD", "+880", 10, 10),
  Country("Barbados", "BB", "+1-246", 10, 10),
  Country("Belarus", "BY", "+375", 9, 9),
  Country("Belgium", "BE", "+32", 9, 9),
  Country("Belize", "BZ", "+501", 7, 7),
  Country("Benin", "BJ", "+229", 8, 8),
  Country("Bhutan", "BT", "+975", 8, 8),
  Country("Bolivia", "BO", "+591", 8, 8),
  Country("Bosnia and Herzegovina", "BA", "+387", 8, 8),
  Country("Botswana", "BW", "+267", 7, 7),
  Country("Brazil", "BR", "+55", 10, 11),
  Country("Brunei", "BN", "+673", 7, 7),
  Country("Bulgaria", "BG", "+359", 9, 9),
  Country("Burkina Faso", "BF", "+226", 8, 8),
  Country("Burundi", "BI", "+257", 8, 8),
  Country("Cambodia", "KH", "+855", 8, 8),
  Country("Cameroon", "CM", "+237", 9, 9),
  Country("Canada", "CA", "+1", 10, 10),
  Country("Cape Verde", "CV", "+238", 7, 7),
  Country("Central African Republic", "CF", "+236", 8, 8),
  Country("Chad", "TD", "+235", 8, 8),
  Country("Chile", "CL", "+56", 9, 9),
  Country("China", "CN", "+86", 11, 11),
  Country("Colombia", "CO", "+57", 10, 10),
  Country("Comoros", "KM", "+269", 7, 7),
  Country("Congo (DRC)", "CD", "+243", 9, 9),
  Country("Congo (Republic)", "CG", "+242", 9, 9),
  Country("Costa Rica", "CR", "+506", 8, 8),
  Country("Croatia", "HR", "+385", 9, 9),
  Country("Cuba", "CU", "+53", 8, 8),
  Country("Cyprus", "CY", "+357", 8, 8),
  Country("Czech Republic", "CZ", "+420", 9, 9),
  Country("Denmark", "DK", "+45", 8, 8),
  Country("Djibouti", "DJ", "+253", 8, 8),
  Country("Dominica", "DM", "+1-767", 10, 10),
  Country("Dominican Republic", "DO", "+1-809", 10, 10),
  Country("Ecuador", "EC", "+593", 9, 9),
  Country("Egypt", "EG", "+20", 10, 10, startingDigits: ["1"]),
  Country("El Salvador", "SV", "+503", 8, 8),
  Country("Equatorial Guinea", "GQ", "+240", 9, 9),
  Country("Eritrea", "ER", "+291", 7, 7),
  Country("Estonia", "EE", "+372", 8, 8),
  Country("Eswatini", "SZ", "+268", 8, 8),
  Country("Ethiopia", "ET", "+251", 9, 9),
  Country("Fiji", "FJ", "+679", 7, 7),
  Country("Finland", "FI", "+358", 9, 9),
  Country("France", "FR", "+33", 9, 9),
  Country("Gabon", "GA", "+241", 8, 8),
  Country("Gambia", "GM", "+220", 7, 7),
  Country("Georgia", "GE", "+995", 9, 9),
  Country("Germany", "DE", "+49", 10, 10),
  Country("Ghana", "GH", "+233", 9, 9),
  Country("Greece", "GR", "+30", 10, 10),
  Country("Grenada", "GD", "+1-473", 10, 10),
  Country("Guatemala", "GT", "+502", 8, 8),
  Country("Guinea", "GN", "+224", 9, 9),
  Country("Guinea-Bissau", "GW", "+245", 7, 7),
  Country("Guyana", "GY", "+592", 7, 7),
  Country("Haiti", "HT", "+509", 8, 8),
  Country("Honduras", "HN", "+504", 8, 8),
  Country("Hungary", "HU", "+36", 9, 9),
  Country("Iceland", "IS", "+354", 7, 7),
  Country("India", "IN", "+91", 10, 10),
  Country("Indonesia", "ID", "+62", 10, 10),
  Country("Iran", "IR", "+98", 10, 10),
  Country("Iraq", "IQ", "+964", 10, 10),
  Country("Ireland", "IE", "+353", 9, 9),
  Country("Italy", "IT", "+39", 9, 9),
  Country("Jamaica", "JM", "+1-876", 10, 10),
  Country("Japan", "JP", "+81", 10, 10),
  Country("Jordan", "JO", "+962", 9, 9),
  Country("Kazakhstan", "KZ", "+7", 10, 10),
  Country("Kenya", "KE", "+254", 10, 10),
  Country("Kiribati", "KI", "+686", 8, 8),
  Country("Kuwait", "KW", "+965", 8, 8),
  Country("Kyrgyzstan", "KG", "+996", 9, 9),
  Country("Laos", "LA", "+856", 10, 10),
  Country("Latvia", "LV", "+371", 8, 8),
  Country("Lebanon", "LB", "+961", 8, 8),
  Country("Lesotho", "LS", "+266", 8, 8),
  Country("Liberia", "LR", "+231", 7, 7),
  Country("Libya", "LY", "+218", 10, 10),
  Country("Liechtenstein", "LI", "+423", 7, 7),
  Country("Lithuania", "LT", "+370", 8, 8),
  Country("Luxembourg", "LU", "+352", 9, 9),
  Country("Madagascar", "MG", "+261", 9, 9),
  Country("Malawi", "MW", "+265", 9, 9),
  Country("Malaysia", "MY", "+60", 9, 9),
  Country("Maldives", "MV", "+960", 7, 7),
  Country("Mali", "ML", "+223", 8, 8),
  Country("Malta", "MT", "+356", 8, 8),
  Country("Marshall Islands", "MH", "+692", 7, 7),
  Country("Mauritania", "MR", "+222", 8, 8),
  Country("Mauritius", "MU", "+230", 8, 8),
  Country("Mexico", "MX", "+52", 10, 10),
  Country("Micronesia", "FM", "+691", 7, 7),
  Country("Moldova", "MD", "+373", 8, 8),
  Country("Monaco", "MC", "+377", 8, 8),
  Country("Mongolia", "MN", "+976", 8, 8),
  Country("Montenegro", "ME", "+382", 8, 8),
  Country("Morocco", "MA", "+212", 9, 9),
  Country("Mozambique", "MZ", "+258", 9, 9),
  Country("Myanmar", "MM", "+95", 9, 9),
  Country("Namibia", "NA", "+264", 9, 9),
  Country("Nauru", "NR", "+674", 7, 7),
  Country("Nepal", "NP", "+977", 10, 10),
  Country("Netherlands", "NL", "+31", 9, 9),
  Country("New Zealand", "NZ", "+64", 8, 8),
  Country("Nicaragua", "NI", "+505", 8, 8),
  Country("Niger", "NE", "+227", 8, 8),
  Country("Nigeria", "NG", "+234", 10, 10),
  Country("North Macedonia", "MK", "+389", 8, 8),
  Country("Norway", "NO", "+47", 8, 8),
  Country("Oman", "OM", "+968", 8, 8),
  Country("Pakistan", "PK", "+92", 10, 10),
  Country("Palau", "PW", "+680", 7, 7),
  Country("Palestine", "PS", "+970", 9, 9),
  Country("Panama", "PA", "+507", 8, 8),
  Country("Papua New Guinea", "PG", "+675", 8, 8),
  Country("Paraguay", "PY", "+595", 9, 9),
  Country("Peru", "PE", "+51", 9, 9),
  Country("Philippines", "PH", "+63", 10, 10),
  Country("Poland", "PL", "+48", 9, 9),
  Country("Portugal", "PT", "+351", 9, 9),
  Country("Qatar", "QA", "+974", 8, 8),
  Country("Romania", "RO", "+40", 10, 10),
  Country("Russia", "RU", "+7", 10, 10),
  Country("Rwanda", "RW", "+250", 9, 9),
  Country("Saint Kitts and Nevis", "KN", "+1-869", 10, 10),
  Country("Saint Lucia", "LC", "+1-758", 10, 10),
  Country("Saint Vincent and the Grenadines", "VC", "+1-784", 10, 10),
  Country("Samoa", "WS", "+685", 7, 7),
  Country("San Marino", "SM", "+378", 8, 8),
  Country("Sao Tome and Principe", "ST", "+239", 7, 7),
  Country("Saudi Arabia", "SA", "+966", 9, 9),
  Country("Senegal", "SN", "+221", 9, 9),
  Country("Serbia", "RS", "+381", 8, 8),
  Country("Seychelles", "SC", "+248", 7, 7),
  Country("Sierra Leone", "SL", "+232", 8, 8),
  Country("Singapore", "SG", "+65", 8, 8),
  Country("Slovakia", "SK", "+421", 9, 9),
  Country("Slovenia", "SI", "+386", 8, 8),
  Country("Solomon Islands", "SB", "+677", 7, 7),
  Country("Somalia", "SO", "+252", 9, 9),
  Country("South Africa", "ZA", "+27", 9, 9),
  Country("South Korea", "KR", "+82", 10, 10),
  Country("South Sudan", "SS", "+211", 9, 9),
  Country("Spain", "ES", "+34", 9, 9),
  Country("Sri Lanka", "LK", "+94", 9, 9),
  Country("Sudan", "SD", "+249", 9, 9),
  Country("Suriname", "SR", "+597", 6, 7),
  Country("Sweden", "SE", "+46", 9, 9),
  Country("Switzerland", "CH", "+41", 9, 9),
  Country("Syria", "SY", "+963", 9, 9),
  Country("Taiwan", "TW", "+886", 9, 9),
  Country("Tajikistan", "TJ", "+992", 9, 9),
  Country("Tanzania", "TZ", "+255", 9, 9),
  Country("Thailand", "TH", "+66", 9, 9),
  Country("Timor-Leste", "TL", "+670", 7, 7),
  Country("Togo", "TG", "+228", 8, 8),
  Country("Tonga", "TO", "+676", 5, 5),
  Country("Trinidad and Tobago", "TT", "+1-868", 10, 10),
  Country("Tunisia", "TN", "+216", 8, 8),
  Country("Turkey", "TR", "+90", 10, 10),
  Country("Turkmenistan", "TM", "+993", 8, 8),
  Country("Tuvalu", "TV", "+688", 5, 5),
  Country("Uganda", "UG", "+256", 9, 9),
  Country("Ukraine", "UA", "+380", 9, 9),
  Country("United Arab Emirates", "AE", "+971", 9, 9),
  Country("United Kingdom", "GB", "+44", 10, 10),
  Country("United States", "US", "+1", 10, 10),
  Country("Uruguay", "UY", "+598", 8, 8),
  Country("Uzbekistan", "UZ", "+998", 9, 9),
  Country("Vanuatu", "VU", "+678", 7, 7),
  Country("Vatican City", "VA", "+379", 10, 10),
  Country("Venezuela", "VE", "+58", 10, 10),
  Country("Vietnam", "VN", "+84", 9, 9),
  Country("Yemen", "YE", "+967", 9, 9),
  Country("Zambia", "ZM", "+260", 9, 9),
  Country("Zimbabwe", "ZW", "+263", 9, 9),
  Country("American Samoa", "AS", "+684", 7, 7),
  Country("Anguilla", "AI", "+1-264", 7, 7),
  Country("Antarctica", "AQ", "+672", 5, 5),
  Country("Antigua and Barbuda", "AG", "+1-268", 7, 7),
  Country("Aruba", "AW", "+297", 7, 7),
  Country("Bouvet Island", "BV", "", 0, 0),
  Country("British Indian Ocean Territory", "IO", "+246", 7, 7),
  Country("Cayman Islands", "KY", "+1-345", 7, 7),
  Country("Christmas Island", "CX", "+61", 6, 6),
  Country("Cocos (Keeling) Islands", "CC", "+61", 6, 6),
  Country("Cook Islands", "CK", "+682", 5, 5),
  Country("Côte d'Ivoire", "CI", "+225", 8, 8),
  Country("Falkland Islands (Malvinas)", "FK", "+500", 5, 5),
  Country("Faroe Islands", "FO", "+298", 6, 6),
  Country("French Guiana", "GF", "+594", 9, 9),
  Country("French Polynesia", "PF", "+689", 6, 6),
  Country("French Southern Territories", "TF", "", 0, 0),
  Country("Gibraltar", "GI", "+350", 8, 8),
  Country("Greenland", "GL", "+299", 6, 6),
  Country("Guadeloupe", "GP", "+590", 9, 9),
  Country("Guam", "GU", "+1-671", 7, 7),
  Country("Heard Island and McDonald Islands", "HM", "", 0, 0),
  Country("Hong Kong", "HK", "+852", 8, 8),
  Country("Isle of Man", "IM", "+44", 10, 10),
  Country("Jersey", "JE", "+44", 10, 10),
  Country("Kosovo", "XK", "+383", 9, 9),
  Country("Montserrat", "MS", "+1-664", 7, 7),
  Country("New Caledonia", "NC", "+687", 6, 6),
  Country("Niue", "NU", "+683", 4, 4),
  Country("Norfolk Island", "NF", "+672", 6, 6),
  Country("Northern Mariana Islands", "MP", "+1-670", 7, 7),
  Country("Pitcairn", "PN", "+64", 5, 5),
  Country("Puerto Rico", "PR", "+1-787", 10, 10),
  Country("Reunion", "RE", "+262", 9, 9),
  Country("Saint Barthélemy", "BL", "+590", 9, 9),
  Country("Saint Helena", "SH", "+290", 4, 4),
  Country("Saint Martin (French part)", "MF", "+590", 9, 9),
  Country("Sint Maarten (Dutch part)", "SX", "+1-721", 7, 7),
  Country("Svalbard and Jan Mayen", "SJ", "+47", 7, 7),
  Country("Tokelau", "TK", "+690", 4, 4),
  Country("Turks and Caicos Islands", "TC", "+1-649", 7, 7),
  Country("United States Minor Outlying Islands", "UM", "+1", 10, 10),
  Country("Virgin Islands, British", "VG", "+1-284", 7, 7),
  Country("Virgin Islands, U.S.", "VI", "+1-340", 7, 7),
  Country("Wallis and Futuna", "WF", "+681", 5, 5),
  Country("Western Sahara", "EH", "+212", 9, 9),
  Country("Åland Islands", "AX", "+358", 6, 6),
];


/// Represents a parsed phone number with country information.
class PhoneNumber {
  /// The country dial code (e.g., "+1", "+44").
  final String countryCode;

  /// The local phone number without country code.
  final String localNumber;

  /// The country information.
  final Country country;

  PhoneNumber({
    required this.countryCode,
    required this.localNumber,
    required this.country,
  });

  /// Gets the full phone number in E.164 format (e.g., +1234567890).
  String get e164 => CountryUtils.formatE164(countryCode, localNumber);

  /// Gets the full phone number with country code and local number.
  String get fullNumber => '$countryCode$localNumber';

  /// Gets a formatted, readable version of the phone number.
  String get formatted => CountryUtils.formatReadable(fullNumber);

  @override
  String toString() => '$countryCode $localNumber (${country.name})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneNumber &&
          runtimeType == other.runtimeType &&
          countryCode == other.countryCode &&
          localNumber == other.localNumber;

  @override
  int get hashCode => Object.hash(countryCode, localNumber);
}

class CountryUtils {
  /// Normalizes a phone number by removing spaces, dashes, parentheses, and other formatting.
  /// Also removes leading zeros and plus signs.
  static String normalizePhoneNumber(String phoneNumber) {
    // Remove all non-digit characters except +
    String normalized = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    return normalized;
  }

  /// Formats a phone number in E.164 format (e.g., +1234567890)
  static String formatE164(String countryCode, String localNumber) {
    String code = countryCode.replaceAll(RegExp(r'[^\d+]'), '');
    if (!code.startsWith('+')) {
      code = '+$code';
    }
    String number = localNumber.replaceAll(RegExp(r'[^\d]'), '');
    return '$code$number';
  }

  /// Formats a phone number with spaces for better readability
  static String formatReadable(String phoneNumber) {
    String normalized = normalizePhoneNumber(phoneNumber);
    if (normalized.startsWith('+')) {
      String code = normalized.substring(0, 3);
      String number = normalized.substring(3);
      // Format as +XXX XXX XXX XXXX (adjust based on length)
      if (number.length <= 10) {
        return '$code ${number.substring(0, number.length > 3 ? 3 : number.length)} ${number.length > 3 ? number.substring(3) : ''}'.trim();
      }
    }
    return normalized;
  }

  /// Retrieve a country by its dial code.
  /// Returns the first match found.
  static Country? getCountryByDialCode(String dialCode) {
    final normalizedCode = dialCode.replaceAll(RegExp(r'[^\d+]'), '');
    final index = countries.indexWhere((country) {
      final countryCode = country.dialCode.replaceAll(RegExp(r'[^\d+]'), '');
      return countryCode == normalizedCode;
    });
    if (index < 0) return null;
    return countries[index];
  }

  /// Retrieve all countries that share the same dial code.
  /// Useful for dial codes like +1 which are shared by multiple countries.
  static List<Country> getCountriesByDialCode(String dialCode) {
    final normalizedCode = dialCode.replaceAll(RegExp(r'[^\d+]'), '');
    return countries.where((country) {
      final countryCode = country.dialCode.replaceAll(RegExp(r'[^\d+]'), '');
      return countryCode == normalizedCode;
    }).toList();
  }

  /// Retrieve a country by its ISO code.
  static Country? getCountryByIsoCode(String isoCode) {
    final index = countries.indexWhere((country) => 
        country.isoCode.toUpperCase() == isoCode.toUpperCase());
    if (index < 0) return null;
    return countries[index];
  }

  /// Validate a phone number based on the country's dial code.
  /// The phoneNumber should be the local number (without country code).
  static bool validatePhoneNumber(String phoneNumber, String dialCode) {
    Country? country = getCountryByDialCode(dialCode);
    if (country == null) return false;
    return validatePhoneNumberByCountry(phoneNumber, country);
  }

  /// Validate a phone number based on the country.
  /// The phoneNumber should be the local number (without country code).
  static bool validatePhoneNumberByCountry(String phoneNumber, Country country) {
    // Normalize the phone number
    String normalized = normalizePhoneNumber(phoneNumber);
    
    // // Check if it's a valid number (only digits)
    // if (!RegExp(r'^\d+$').hasMatch(normalized)) {
    //   return false;
    // }
    
    int length = normalized.length;

    print("length: $length");
    
    // Check length
    bool lengthValid =
        length >= country.phoneMinLength && length <= country.phoneMaxLength;
    if (!lengthValid) return false;
    
    // Check starting digits if specified
    if (country.startingDigits.isNotEmpty) {
      bool startingDigitsValid = country.startingDigits.any(
          (digits) => normalized.startsWith(digits));
      if (!startingDigitsValid) return false;
    }
    
    return true;
  }
  

  /// Validates a full phone number (with country code) in E.164 format.
  static ValidationResult validateFullPhoneNumber(String countryCode, String localNumber) {
    String normalizedLocalNumber = normalizePhoneNumber(localNumber);
    String normalized = countryCode + normalizedLocalNumber;
    
    if (normalized.isEmpty) {
      return ValidationResult(
        isValid: false,
        error: 'Phone number cannot be empty',
      );
    }
    
    if (!normalized.startsWith('+')) {
      return ValidationResult(
        isValid: false,
        error: 'Phone number must start with +',
      );
    }
    
    PhoneNumber? extracted = extractCountryCodeAndNumber(normalized);
    if(extracted == null){
      normalized = countryCode + normalizedLocalNumber.substring(1, normalizedLocalNumber.length);
      extracted = extractCountryCodeAndNumber(normalized);
    }

    if (extracted == null) {
      return ValidationResult(
        isValid: false,
        error: 'Invalid country code',
      );
    }
    
    return ValidationResult(
      isValid: true,
      phoneNumber: extracted,
      error: null,
    );
  }

  /// Extracts country code and local number from a full phone number.
  /// Handles overlapping dial codes by matching the longest code first.
  /// Returns null if no valid country code is found.
  static PhoneNumber? extractCountryCodeAndNumber(String fullNumber) {
    String normalized = normalizePhoneNumber(fullNumber);

    if (!normalized.startsWith('+')) {
      return null;
    }
    
    // Sort countries by dial code length (longest first) to handle overlapping codes
    // For example, +1-242 should match before +1
    List<Country> sortedCountries = List.from(countries);
    sortedCountries.sort((a, b) {
      String codeA = a.dialCode.replaceAll(RegExp(r'[^\d+]'), '');
      String codeB = b.dialCode.replaceAll(RegExp(r'[^\d+]'), '');
      return codeB.length.compareTo(codeA.length); // Descending order
    });
    
    for (var country in sortedCountries) {
      String countryCode = country.dialCode;
      if (normalized.startsWith(countryCode)) {
        String localNumber = normalized.substring(countryCode.length);
        // Validate that the local number is not empty and matches length requirements
        if (localNumber.isNotEmpty &&
            localNumber.length >= country.phoneMinLength &&
            localNumber.length <= country.phoneMaxLength) {
          return PhoneNumber(
            countryCode: country.dialCode,
            localNumber: localNumber,
            country: country,
          );
        }
      }
    }
    
    return null;
  }

  /// Gets all available countries sorted alphabetically by name.
  static List<Country> getAllCountries() {
    return List.from(countries)..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Searches countries by name (case-insensitive partial match).
  static List<Country> searchCountries(String query) {
    final lowerQuery = query.toLowerCase();
    return countries.where((country) =>
        country.name.toLowerCase().contains(lowerQuery) ||
        country.isoCode.toLowerCase().contains(lowerQuery) ||
        country.dialCode.contains(query)).toList();
  }
}

/// Result of phone number validation.
class ValidationResult {
  final bool isValid;
  final PhoneNumber? phoneNumber;
  final String? error;

  ValidationResult({
    required this.isValid,
    this.phoneNumber,
    this.error,
  });

  @override
  String toString() {
    if (isValid) {
      return 'Valid: ${phoneNumber?.countryCode} ${phoneNumber?.localNumber}';
    }
    return 'Invalid: $error';
  }
}