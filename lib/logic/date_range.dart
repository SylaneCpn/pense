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


  Iterable<(Month, int)> generateDates() sync* {
  if (compareDates(thisMonth: beginMonth, thisYear: beginYear, otherMonth: endMonth, otherYear: endYear) != -1) return; 
  for (int y = beginYear; y <= endYear; y++) {
    if (y == beginYear) {
      for (int m = beginMonth.toInt(); m <= 12; m++) {
        yield (m.toMonth(), y);
      }
    } else if (y == endYear) {
      for (int m = 1; m <= endMonth.toInt(); m++) {
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
