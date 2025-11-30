enum RetrospectType {
  income,
  expense,
  diff;

  String title() {
    return switch (this) {
      RetrospectType.expense => "Dépenses",
      RetrospectType.income => "Revenus",
      RetrospectType.diff => "Epargne",
    };
  }

  String subtitle() {
    return switch (this) {
      RetrospectType.expense => "Somme dépensée par mois",
      RetrospectType.income => "Revenus obtenus par mois",
      RetrospectType.diff => "Somme épargnée par mois",
    };
  }
}