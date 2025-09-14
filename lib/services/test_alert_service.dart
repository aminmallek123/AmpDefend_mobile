import '../models/alert.dart';
import '../models/alert_statistics.dart';

class TestAlertService {
  // Test data for filters
  static List<Alert> _mockAlerts = [
    Alert(
      alertType: 'intrusion_detected',
      city: 'Paris',
      country: 'France',
      deviceId: 'device_001',
      ipBlocked: '192.168.1.100',
      location: '48.8566,2.3522',
      organization: 'Test Org',
      publicIp: '203.0.113.1',
      rawMessage: 'Intrusion détectée sur le système',
      region: 'Île-de-France',
      severity: 'critical',
      timestamp: DateTime.now().subtract(Duration(hours: 1)).millisecondsSinceEpoch.toString(),
      timezone: 'Europe/Paris',
      uploadedAt: DateTime.now().millisecondsSinceEpoch.toString(),
      vpnLikelihood: 0,
    ),
    Alert(
      alertType: 'vpn_detected',
      city: 'Lyon',
      country: 'France',
      deviceId: 'device_002',
      ipBlocked: '192.168.1.101',
      location: '45.7640,4.8357',
      organization: 'Test Org 2',
      publicIp: '203.0.113.2',
      rawMessage: 'Connexion VPN détectée',
      region: 'Auvergne-Rhône-Alpes',
      severity: 'high',
      timestamp: DateTime.now().subtract(Duration(hours: 2)).millisecondsSinceEpoch.toString(),
      timezone: 'Europe/Paris',
      uploadedAt: DateTime.now().millisecondsSinceEpoch.toString(),
      vpnLikelihood: 85,
    ),
    Alert(
      alertType: 'malware_detected',
      city: 'Marseille',
      country: 'France',
      deviceId: 'device_003',
      ipBlocked: '192.168.1.102',
      location: '43.2965,5.3698',
      organization: 'Test Org 3',
      publicIp: '203.0.113.3',
      rawMessage: 'Malware détecté dans le système',
      region: 'Provence-Alpes-Côte d\'Azur',
      severity: 'medium',
      timestamp: DateTime.now().subtract(Duration(hours: 3)).millisecondsSinceEpoch.toString(),
      timezone: 'Europe/Paris',
      uploadedAt: DateTime.now().millisecondsSinceEpoch.toString(),
      vpnLikelihood: 0,
    ),
    Alert(
      alertType: 'intrusion_detected',
      city: 'Toulouse',
      country: 'France',
      deviceId: 'device_004',
      ipBlocked: '192.168.1.103',
      location: '43.6047,1.4442',
      organization: 'Test Org 4',
      publicIp: '203.0.113.4',
      rawMessage: 'Tentative d\'intrusion bloquée',
      region: 'Occitanie',
      severity: 'low',
      timestamp: DateTime.now().subtract(Duration(hours: 4)).millisecondsSinceEpoch.toString(),
      timezone: 'Europe/Paris',
      uploadedAt: DateTime.now().millisecondsSinceEpoch.toString(),
      vpnLikelihood: 0,
    ),
    Alert(
      alertType: 'vpn_detected',
      city: 'Nice',
      country: 'France',
      deviceId: 'device_005',
      ipBlocked: '192.168.1.104',
      location: '43.7102,7.2620',
      organization: 'Test Org 5',
      publicIp: '203.0.113.5',
      rawMessage: 'Nouvelle connexion VPN suspecte',
      region: 'Provence-Alpes-Côte d\'Azur',
      severity: 'critical',
      timestamp: DateTime.now().subtract(Duration(minutes: 30)).millisecondsSinceEpoch.toString(),
      timezone: 'Europe/Paris',
      uploadedAt: DateTime.now().millisecondsSinceEpoch.toString(),
      vpnLikelihood: 95,
    ),
  ];

  // Get all test alerts
  static Stream<List<Alert>> getAlertsStream() {
    print('🔍 DEBUG TEST: Returning ${_mockAlerts.length} test alerts');
    
    // Debug: display available types and severities
    final types = _mockAlerts.map((a) => a.alertType).toSet().toList();
    final severities = _mockAlerts.map((a) => a.severity).toSet().toList();
    print('🔍 DEBUG TEST: Types d\'alertes disponibles: $types');
    print('🔍 DEBUG TEST: Sévérités disponibles: $severities');
    
    return Stream.value(_mockAlerts).asBroadcastStream();
  }

  // Obtenir les alertes filtrées par plage de dates
  static Stream<List<Alert>> getFilteredAlertsStream({
    DateTime? startDate,
    DateTime? endDate,
    String? alertType,
    String? severity,
  }) {
    return getAlertsStream().map((alerts) {
      var filteredAlerts = alerts;
      print('🔍 DEBUG TEST: Début filtrage - ${alerts.length} alertes totales');

      // Filtre par date
      if (startDate != null || endDate != null) {
        final beforeDateFilter = filteredAlerts.length;
        filteredAlerts = filteredAlerts.where((alert) {
          final alertDate = alert.parsedTimestamp;
          if (alertDate == null) return false;

          if (startDate != null && alertDate.isBefore(startDate)) {
            return false;
          }
          if (endDate != null && alertDate.isAfter(endDate)) {
            return false;
          }
          return true;
        }).toList();
        print('🔍 DEBUG TEST: Après filtre date: ${filteredAlerts.length}/${beforeDateFilter} alertes');
      }

      // Filtre par type d'alerte
      if (alertType != null && alertType != 'all') {
        final beforeTypeFilter = filteredAlerts.length;
        filteredAlerts = filteredAlerts.where((alert) {
          final matches = alert.alertType == alertType;
          if (!matches) {
            print('🔍 DEBUG TEST: Alerte type "${alert.alertType}" ne correspond pas à "$alertType"');
          }
          return matches;
        }).toList();
        print('🔍 DEBUG TEST: Après filtre type "$alertType": ${filteredAlerts.length}/${beforeTypeFilter} alertes');
      }

      // Filtre par sévérité
      if (severity != null && severity != 'all') {
        final beforeSeverityFilter = filteredAlerts.length;
        filteredAlerts = filteredAlerts.where((alert) {
          final matches = alert.severity.toLowerCase() == severity.toLowerCase();
          if (!matches) {
            print('🔍 DEBUG TEST: Alerte sévérité "${alert.severity}" ne correspond pas à "$severity"');
          }
          return matches;
        }).toList();
        print('🔍 DEBUG TEST: Après filtre sévérité "$severity": ${filteredAlerts.length}/${beforeSeverityFilter} alertes');
      }

      print('🔍 DEBUG TEST: Fin filtrage - ${filteredAlerts.length} alertes finales');
      return filteredAlerts;
    });
  }

  // Get alert statistics
  static Stream<AlertStatistics> getAlertStatistics() {
    return getAlertsStream().map((alerts) {
      int total = alerts.length;
      int critical = alerts.where((a) => a.severity.toLowerCase() == 'critical').length;
      int high = alerts.where((a) => a.severity.toLowerCase() == 'high').length;
      int medium = alerts.where((a) => a.severity.toLowerCase() == 'medium').length;
      int low = alerts.where((a) => a.severity.toLowerCase() == 'low').length;

      // Recent alerts (last 24h)
      final oneDayAgo = DateTime.now().subtract(Duration(days: 1));
      int recent = alerts.where((alert) {
        final alertDate = alert.parsedTimestamp;
        return alertDate != null && alertDate.isAfter(oneDayAgo);
      }).length;

      return AlertStatistics(
        total: total,
        critical: critical,
        high: high,
        medium: medium,
        low: low,
        last24Hours: recent,
        topCountries: {'France': total}, // Tous les tests sont en France
        topAlertTypes: {
          'intrusion_detected': alerts.where((a) => a.alertType == 'intrusion_detected').length,
          'vpn_detected': alerts.where((a) => a.alertType == 'vpn_detected').length,
          'malware_detected': alerts.where((a) => a.alertType == 'malware_detected').length,
        },
      );
    });
  }
}