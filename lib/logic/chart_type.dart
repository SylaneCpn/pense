enum ChartType {
  income,
  expense,
  diff;

  String title() {
    return switch (this) {
      ChartType.expense => "Dépenses",
      ChartType.income => "Revenus",
      ChartType.diff => "Epargne",
    };
  }

  String subtitle() {
    return switch (this) {
      ChartType.expense => "Somme dépensée par mois",
      ChartType.income => "Revenus obtenus par mois",
      ChartType.diff => "Somme épargnée par mois",
    };
  }
}