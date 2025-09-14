class Alert {
  final String alertType;
  final String city;
  final String country;
  final String deviceId;
  final String ipBlocked;
  final String location;
  final String organization;
  final String publicIp;
  final String rawMessage;
  final String region;
  final String severity;
  final String timestamp;
  final String timezone;
  final String uploadedAt;
  final int vpnLikelihood;

  Alert({
    required this.alertType,
    required this.city,
    required this.country,
    required this.deviceId,
    required this.ipBlocked,
    required this.location,
    required this.organization,
    required this.publicIp,
    required this.rawMessage,
    required this.region,
    required this.severity,
    required this.timestamp,
    required this.timezone,
    required this.uploadedAt,
    required this.vpnLikelihood,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      alertType: json['alert_type'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      deviceId: json['device_id'] ?? '',
      ipBlocked: json['ip_blocked'] ?? '',
      location: json['loc'] ?? '',
      organization: json['org'] ?? '',
      publicIp: json['public_ip'] ?? '',
      rawMessage: json['raw_message'] ?? '',
      region: json['region'] ?? '',
      severity: json['severity'] ?? '',
      timestamp: json['timestamp'] ?? '',
      timezone: json['timezone'] ?? '',
      uploadedAt: json['uploaded_at'] ?? '',
      vpnLikelihood: json['vpn_likelihood'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alert_type': alertType,
      'city': city,
      'country': country,
      'device_id': deviceId,
      'ip_blocked': ipBlocked,
      'loc': location,
      'org': organization,
      'public_ip': publicIp,
      'raw_message': rawMessage,
      'region': region,
      'severity': severity,
      'timestamp': timestamp,
      'timezone': timezone,
      'uploaded_at': uploadedAt,
      'vpn_likelihood': vpnLikelihood,
    };
  }

  // Getter pour le niveau de gravité
  AlertSeverity get severityLevel {
    switch (severity.toLowerCase()) {
      case 'critical':
        return AlertSeverity.critical;
      case 'high':
        return AlertSeverity.high;
      case 'medium':
        return AlertSeverity.medium;
      case 'low':
        return AlertSeverity.low;
      default:
        return AlertSeverity.unknown;
    }
  }

  // Getter pour le type d'alerte formaté
  String get formattedAlertType {
    return alertType.split('_').map((word) => 
      word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  // Getter pour la localisation formatée
  String get formattedLocation {
    List<String> coords = location.split(',');
    if (coords.length == 2) {
      return 'Lat: ${coords[0]}, Long: ${coords[1]}';
    }
    return location;
  }

  // Getter pour la probabilité VPN formatée
  String get vpnLikelihoodDescription {
    if (vpnLikelihood >= 80) {
      return 'Très probable';
    } else if (vpnLikelihood >= 60) {
      return 'Probable';
    } else if (vpnLikelihood >= 40) {
      return 'Possible';
    } else if (vpnLikelihood >= 20) {
      return 'Peu probable';
    } else {
      return 'Très peu probable';
    }
  }

  // Méthode pour obtenir la date formatée
  DateTime? get parsedTimestamp {
    try {
      return DateTime.parse(uploadedAt);
    } catch (e) {
      return null;
    }
  }

  String get timeAgo {
    final date = parsedTimestamp;
    if (date == null) return timestamp;
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}j';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Maintenant';
    }
  }
}

enum AlertSeverity {
  critical,
  high,
  medium,
  low,
  unknown,
}