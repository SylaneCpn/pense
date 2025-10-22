import 'dart:math';

extension TruncateToDecimalPlaces on double {
  double truncateToDecimalPlaces(int fractionalDigits) =>
      (this * pow(10, fractionalDigits)).truncate() / pow(10, fractionalDigits);

  String prettyToString() {
    final [String whole, String decimal] = toString().split('.');
    final res = StringBuffer();
    for (int i = 0; i < whole.length; i++) {
      if ((whole.length - i) % 3 == 0 && whole.length - i != 0) {
        res.write(' ');
      }
      res.write(whole[i]);
    }
    res.write(".$decimal");
    return res.toString();
  }
}
