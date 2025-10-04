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
  december

}

extension ToMonth on int {

  Month toMonth() {
    return switch(this) {
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
      _ => throw FormatException('Cannoth get a valid month from $this')
    };
  } 
}

