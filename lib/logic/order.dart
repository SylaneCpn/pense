enum Order {
  ascending,
  descending;

  String toStringFr() => switch (this) {
    Order.ascending => "Croissant",
    Order.descending => "Décroissant",
  };
}
