class AlertStatistics {
  final int total;
  final int critical;
  final int high;
  final int medium;
  final int low;
  final int last24Hours;
  final Map<String, int> topCountries;
  final Map<String, int> topAlertTypes;

  AlertStatistics({
    required this.total,
    required this.critical,
    required this.high,
    required this.medium,
    required this.low,
    required this.last24Hours,
    required this.topCountries,
    required this.topAlertTypes,
  });

  // Getter pour calculer le pourcentage de sévérité
  double get criticalPercentage => total > 0 ? (critical / total) * 100 : 0;
  double get highPercentage => total > 0 ? (high / total) * 100 : 0;
  double get mediumPercentage => total > 0 ? (medium / total) * 100 : 0;
  double get lowPercentage => total > 0 ? (low / total) * 100 : 0;

  // Getter pour avoir les top 5 pays
  List<MapEntry<String, int>> get topCountriesList {
    var sorted = topCountries.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(5).toList();
  }

  // Getter pour avoir les top 5 types d'alertes
  List<MapEntry<String, int>> get topAlertTypesList {
    var sorted = topAlertTypes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(5).toList();
  }
}