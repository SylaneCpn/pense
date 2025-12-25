enum CategoryType {
  income,
  expense;

  String toStringFr() {
    return switch(this) {
      CategoryType.income => "revenu",
      CategoryType.expense => "dépense"

    };
  }

  String fancyToStringFr() {
    return switch(this) {
      CategoryType.income => "Revenus",
      CategoryType.expense => "Dépenses"

    };
  }
}

