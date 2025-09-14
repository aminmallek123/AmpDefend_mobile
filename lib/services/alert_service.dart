import 'package:firebase_database/firebase_database.dart';
import '../models/alert.dart';
import '../models/alert_statistics.dart';

class AlertService {
  static final FirebaseDatabase _database = FirebaseDatabase.instance;
  static final DatabaseReference _alertsRef = _database.ref('alerts');

  static Stream<List<Alert>> getAlertsStream() {
    return _alertsRef
        .orderByChild('uploaded_at')
        .limitToLast(100)
        .onValue
        .map((event) {
      final data = event.snapshot.value;
      if (data == null) return <Alert>[];

      final alerts = <Alert>[];
      if (data is Map<dynamic, dynamic>) {
        data.forEach((key, value) {
          try {
            if (value is Map<dynamic, dynamic>) {
              final alertData = Map<String, dynamic>.from(value);
              final alert = Alert.fromJson(alertData);
              alerts.add(alert);
            }
          } catch (e) {
            print('Erreur parsing alerte: $e');
          }
        });
      }

      alerts.sort((a, b) {
        final timestampA = a.parsedTimestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
        final timestampB = b.parsedTimestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
        return timestampB.compareTo(timestampA);
      });

      return alerts;
    }).asBroadcastStream();
  }

  static Stream<AlertStatistics> getAlertStatistics() {
    return getAlertsStream().map((alerts) {
      if (alerts.isEmpty) {
        return AlertStatistics(
          total: 0,
          critical: 0,
          high: 0,
          medium: 0,
          low: 0,
          last24Hours: 0,
          topCountries: <String, int>{'No data': 0},
          topAlertTypes: <String, int>{'No data': 0},
        );
      }
      
      final int total = alerts.length;
      final int critical = alerts.where((a) => a.severity.toLowerCase() == 'critical').length;
      final int high = alerts.where((a) => a.severity.toLowerCase() == 'high').length;
      final int medium = alerts.where((a) => a.severity.toLowerCase() == 'medium').length;
      final int low = alerts.where((a) => a.severity.toLowerCase() == 'low').length;

      final last24Hours = DateTime.now().subtract(const Duration(hours: 24));
      final int recentAlerts = alerts.where((alert) {
        final alertDate = alert.parsedTimestamp;
        return alertDate != null && alertDate.isAfter(last24Hours);
      }).length;

      final Map<String, int> countriesCount = <String, int>{};
      for (final alert in alerts) {
        final country = alert.country.isNotEmpty ? alert.country : 'Inconnu';
        countriesCount[country] = (countriesCount[country] ?? 0) + 1;
      }

      final Map<String, int> alertTypesCount = <String, int>{};
      for (final alert in alerts) {
        alertTypesCount[alert.alertType] = (alertTypesCount[alert.alertType] ?? 0) + 1;
      }

      return AlertStatistics(
        total: total,
        critical: critical,
        high: high,
        medium: medium,
        low: low,
        last24Hours: recentAlerts,
        topCountries: countriesCount.isNotEmpty ? countriesCount : <String, int>{'No data': 0},
        topAlertTypes: alertTypesCount.isNotEmpty ? alertTypesCount : <String, int>{'No data': 0},
      );
    });
  }

  static Stream<List<Alert>> getFilteredAlertsStream({
    String? alertType,
    String? severity,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return getAlertsStream().map((alerts) {
      return alerts.where((alert) {
        if (alertType != null && alertType.isNotEmpty && alert.alertType != alertType) {
          return false;
        }
        if (severity != null && severity.isNotEmpty && alert.severity != severity) {
          return false;
        }
        if (startDate != null) {
          final alertDate = alert.parsedTimestamp;
          if (alertDate == null || alertDate.isBefore(startDate)) {
            return false;
          }
        }
        if (endDate != null) {
          final alertDate = alert.parsedTimestamp;
          if (alertDate == null || alertDate.isAfter(endDate)) {
            return false;
          }
        }
        return true;
      }).toList();
    });
  }

  static Future<void> addMultipleTestAlerts() async {
    try {
      final now = DateTime.now();
      final testAlerts = <Map<String, dynamic>>[
        {
          'alert_type': 'intrusion_detected',
          'city': 'Paris',
          'country': 'France',
          'device_id': 'device_001',
          'ip_blocked': '192.168.1.100',
          'loc': '48.8566,2.3522',
          'org': 'Test Organization',
          'public_ip': '203.0.113.1',
          'raw_message': 'Intrusion detectee depuis Paris',
          'region': 'Ile-de-France',
          'severity': 'high',
          'timestamp': now.millisecondsSinceEpoch.toString(),
          'timezone': 'Europe/Paris',
          'uploaded_at': now.millisecondsSinceEpoch.toString(),
          'vpn_likelihood': 0,
        },
        {
          'alert_type': 'vpn_analysis',
          'city': 'Lyon',
          'country': 'France',
          'device_id': 'device_002',
          'ip_blocked': '192.168.1.101',
          'loc': '45.7640,4.8357',
          'org': 'Test VPN',
          'public_ip': '203.0.113.2',
          'raw_message': 'VPN analysis from Lyon',
          'region': 'Auvergne-Rhone-Alpes',
          'severity': 'medium',
          'timestamp': now.millisecondsSinceEpoch.toString(),
          'timezone': 'Europe/Paris',
          'uploaded_at': now.millisecondsSinceEpoch.toString(),
          'vpn_likelihood': 85,
        },
        {
          'alert_type': 'ip_blocked',
          'city': 'Marseille',
          'country': 'France',
          'device_id': 'device_003',
          'ip_blocked': '192.168.1.102',
          'loc': '43.2965,5.3698',
          'org': 'Test Block',
          'public_ip': '203.0.113.3',
          'raw_message': 'IP bloquee depuis Marseille',
          'region': 'Provence-Alpes-Cote d\'Azur',
          'severity': 'critical',
          'timestamp': now.millisecondsSinceEpoch.toString(),
          'timezone': 'Europe/Paris',
          'uploaded_at': now.millisecondsSinceEpoch.toString(),
          'vpn_likelihood': 0,
        },
      ];

      for (final alertData in testAlerts) {
        await _alertsRef.push().set(alertData);
      }
      print('✅ ${testAlerts.length} alertes de test ajoutees');
    } catch (e) {
      print('❌ Erreur lors de l\'ajout des alertes de test: $e');
    }
  }
}