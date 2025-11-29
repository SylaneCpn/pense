import 'dart:math';
import 'package:flutter/material.dart';

Color randomColor() {
  final generatedColor = Random().nextInt(Colors.primaries.length);
  return Colors.primaries[generatedColor];
}

Color colorShade(Color color, int index, int length) {
  final asHsv = HSVColor.fromColor(color);
  return asHsv.withHue((asHsv.hue + index / length * 45) % 360).toColor();
}

Color gradientPairColor(Color color) {
  return colorShade(color, 1, 2);
}

extension IntUtils on int {
  (String, String) centsToWhole() {
    final asString = toString();
    if (asString.isEmpty) {
      return ("0", "0");
    }
    if (asString.length == 1) {
      return ("0", "0$asString");
    }
    if (asString.length == 2) {
      return ("0", asString);
    }
    final whole = asString.substring(0, asString.length - 2);
    final dec = asString.substring(asString.length - 2);
    return (whole, dec);
  }

  String prettyCentsToWhole() {
    final (String whole, String decimal) = centsToWhole();
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

extension DoubleUtils on double {
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

  String toPercentage(int decimals) {
    return "${(this * 100).truncateToDecimalPlaces(decimals)} %";
  }

}
