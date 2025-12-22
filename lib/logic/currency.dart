enum Currency {
  euro,
  dollar,
  pound,
  yen
  ;

  String symbol() {
    return switch (this) {
      Currency.euro => '€',
      Currency.dollar => '\$',
      Currency.pound => '£',
      Currency.yen => '¥'
    };
  }

  String toStringFr() {
    return switch (this) {
      Currency.euro => "Euro",
      Currency.dollar => "Dollar",
      Currency.pound => "Livre",
      Currency.yen => "Yen"
    };
  }
}
