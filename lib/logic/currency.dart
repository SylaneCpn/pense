enum Currency {
  euro,
  dollar,
  pound;

  String symbol() {
    return switch (this) {
      Currency.euro => '€',
      Currency.dollar => '\$',
      Currency.pound => '£',
    };
  }

  String toStringFr() {
    return switch (this) {
      Currency.euro => "Euro",
      Currency.dollar => "Dollar",
      Currency.pound => "Livre",
    };
  }
}
