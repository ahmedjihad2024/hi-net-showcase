import 'package:money2/money2.dart';

void loadMyCurrencies() {
  Currencies().registerList([
    Currency.create(
      'SAR',
      3,
      symbol: '\u{FDFC}', // U+FDFC \u{FDFC}
      pattern: 'S#,##0.000',
      country: 'Saudi Arabia',
      unit: 'Riyal',
      name: 'Saudi Arabia Riyal',
    )
  ]);
}
