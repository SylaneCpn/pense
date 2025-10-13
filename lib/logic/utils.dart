import 'dart:math';

extension TruncateToDecimalPlaces on double {

double truncateToDecimalPlaces( int fractionalDigits) =>
    (this * pow(10, fractionalDigits)).truncate() / pow(10, fractionalDigits);

}



