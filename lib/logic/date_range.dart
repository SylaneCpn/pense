import 'package:pense/logic/month.dart';

class DateRange {
  Month beginMonth;
  int beginYear;
  Month endMonth;
  int endYear;

  DateRange({
    required this.beginMonth,
    required this.beginYear,
    required this.endMonth,
    required this.endYear,
  });

  DateRange copy() => DateRange(beginMonth: beginMonth, beginYear: beginYear, endMonth: endMonth, endYear: endYear);


  static Iterable<(Month, int)> generateDates(DateRange range) sync* {
  
  for (int y = range.beginYear; y <= range.endYear; y++) {
    if (y == range.beginYear) {
      for (int m = range.beginMonth.toInt(); m <= 12; m++) {
        yield (m.toMonth(), y);
      }
    } else if (y == range.endYear) {
      for (int m = 1; m <= range.endMonth.toInt(); m++) {
        yield (m.toMonth(), y);
      }
    } else {
      for (int m = 1; m <= 12; m++) {
        yield (m.toMonth(), y);
      }
    }
  }
}
}
