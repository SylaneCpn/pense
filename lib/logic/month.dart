enum Month {
  january,
  febuary,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december;

  bool isFuture(int year) {
    final now = DateTime.now();
    if (year > now.year) {
      return true;
    }

    if (toInt() > now.month && year == now.year) {
      return true;
    }

    return false;
  }

  String toStringFr() {
    return switch (this) {
      Month.january => "Janvier",
      Month.febuary => "Février",
      Month.march => "Mars",
      Month.april => "Avril",
      Month.may => "Mai",
      Month.june => "Juin",
      Month.july => "Julliet",
      Month.august => "Août",
      Month.september => "Septembre",
      Month.october => "Octobre",
      Month.november => "Novembre",
      Month.december => "Décembre",
    };
  }

  int toInt() {
    return switch (this) {
      Month.january => 1,
      Month.febuary => 2,
      Month.march => 3,
      Month.april => 4,
      Month.may => 5,
      Month.june => 6,
      Month.july => 7,
      Month.august => 8,
      Month.september => 9,
      Month.october => 10,
      Month.november => 11,
      Month.december => 12,
    };
  }

  (Month, int) prev(int year) {
    final monthAsInt = toInt();
    // get a value from 0 to 11
    final modulus = monthAsInt - 1;
    final prevMonthAsIntModulus = (modulus - 1) % 12;
    // get back to a value from 1 to 12
    final prevMonthAsInt = prevMonthAsIntModulus + 1;
    final currentYear = prevMonthAsInt == 12 ? year - 1 : year;
    return (prevMonthAsInt.toMonth(), currentYear);
  }

  (Month, int) next(int year) {
    final monthAsInt = toInt();
    // get a value from 0 to 11
    final modulus = monthAsInt - 1;
    final nextMonthAsIntModulus = (modulus + 1) % 12;
    // get back to a value from 1 to 12
    final nextMonthAsInt = nextMonthAsIntModulus + 1;
    final currentYear = nextMonthAsInt == 1 ? year + 1 : year;
    return (nextMonthAsInt.toMonth(), currentYear);
  }
}

extension ToMonth on int {
  Month toMonth() {
    return switch (this) {
      1 => Month.january,
      2 => Month.febuary,
      3 => Month.march,
      4 => Month.april,
      5 => Month.may,
      6 => Month.june,
      7 => Month.july,
      8 => Month.august,
      9 => Month.september,
      10 => Month.october,
      11 => Month.november,
      12 => Month.december,
      _ => throw FormatException('Cannoth get a valid month from $this'),
    };
  }
}

int compareDates({
  required Month thisMonth,
  required int thisYear,
  required Month otherMonth,
  required int otherYear,
}) {
  if (thisYear < otherYear) {
    return -1;
  } else if (thisYear > otherYear) {
    return 1;
  }
  //sma year at this point
  if (thisMonth.toInt() < otherMonth.toInt()) {
    return -1;
  }

  if (thisMonth.toInt() > otherMonth.toInt()) {
    return 1;
  }

  return 0;
}

Iterable<(Month, int)> generateDates({
  required Month beginMonth,
  required int beginYear,
  required Month endMonth,
  required int endYear,
}) sync* {
  
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
