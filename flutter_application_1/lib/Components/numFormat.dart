import 'package:intl/intl.dart';

var intlmarket =
    NumberFormat.currency(locale: "ko_KR", symbol: " ", decimalDigits: 2);
var intlperc =
    NumberFormat.currency(locale: "ko_KR", symbol: "", decimalDigits: 2);
var intlprice = NumberFormat.currency(locale: "ko_KR", symbol: "");
var intlchange = NumberFormat.currency(locale: "ko_KR", symbol: "");
var intlvol = NumberFormat.currency(locale: "ko_KR", symbol: "");

String marketCapFormat(var marketCap) {
  marketCap = int.parse(marketCap);
  String stringMarketCap = marketCap.toString();
  stringMarketCap = stringMarketCap.split('').reversed.join();
  print(marketCap);
  if (marketCap > 9999 && marketCap <= 99999999) {
    stringMarketCap = stringMarketCap.substring(0, 4) +
        " 만" +
        stringMarketCap.substring(4, stringMarketCap.length);
  } else if (marketCap > 99999999 && marketCap <= 999999999999) {
    stringMarketCap = stringMarketCap.substring(0, 4) +
        " 만" +
        stringMarketCap.substring(4, 8) +
        " 억" +
        stringMarketCap.substring(8, stringMarketCap.length);
  } else if (marketCap > 999999999999 && marketCap <= 9999999999999999) {
    stringMarketCap = stringMarketCap.substring(0, 4) +
        " 만" +
        stringMarketCap.substring(4, 8) +
        " 억" +
        stringMarketCap.substring(8, 12) +
        " 조" +
        stringMarketCap.substring(12, stringMarketCap.length);
  } else if (marketCap > 9999999999999999) {
    stringMarketCap = stringMarketCap.substring(0, 4) +
        " 만" +
        stringMarketCap.substring(4, 8) +
        " 억" +
        stringMarketCap.substring(8, 12) +
        " 조" +
        stringMarketCap.substring(12, 16) +
        " 경" +
        stringMarketCap.substring(16, stringMarketCap.length);
  }

  stringMarketCap = stringMarketCap.split('').reversed.join();
  return stringMarketCap;
}
