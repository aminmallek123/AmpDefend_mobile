class AppConstants {
  // App info
  static const String appName = 'AMPDefend';
  static const String appTagline = 'Smart Honeypot Shield';
  static const String appDescription = 'Protégez votre infrastructure avec des solutions de cybersécurité intelligentes et proactives';
  static const String appVersion = '1.0.0';
  
  // Company info
  static const String companyName = 'AMPDefend SAS';
  static const String companyEmail = 'contact@ampdefend.com';
  static const String companyPhone = '+33 1 23 45 67 89';
  static const String companyAddress = '123 Avenue de la Cybersécurité\n75001 Paris, France';
  
  // Social links
  static const String linkedInUrl = 'https://linkedin.com/company/ampdefend';
  static const String twitterUrl = 'https://twitter.com/ampdefend';
  static const String githubUrl = 'https://github.com/ampdefend';
  static const String youtubeUrl = 'https://youtube.com/c/ampdefend';
  
  // API endpoints (à configurer selon l'environnement)
  static const String baseUrl = 'https://api.ampdefend.com';
  static const String contactEndpoint = '/contact';
  static const String blogEndpoint = '/blog';
  static const String featuresEndpoint = '/features';
  
  // App settings
  static const Duration splashDelay = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration carouselAutoPlayInterval = Duration(seconds: 4);
  static const int maxRetryAttempts = 3;
  
  // UI constants
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  static const double defaultElevation = 4.0;
  
  // Feature categories
  static const List<String> featureCategories = [
    'Security',
    'Monitoring',
    'Analytics',
    'Deployment',
    'Intelligence',
    'Integration',
  ];
  
  // Blog categories
  static const List<String> blogCategories = [
    'Security',
    'Threat Intelligence',
    'Architecture',
    'Best Practices',
    'News',
    'Tutorials',
  ];
  
  // Error messages
  static const String networkErrorMessage = 'Erreur de connexion. Vérifiez votre connexion internet.';
  static const String genericErrorMessage = 'Une erreur est survenue. Veuillez réessayer.';
  static const String validationErrorMessage = 'Veuillez vérifier les informations saisies.';
  
  // Success messages
  static const String contactSuccessMessage = 'Votre message a été envoyé avec succès !';
  static const String subscriptionSuccessMessage = 'Inscription réussie à notre newsletter !';
}

class AppAssets {
  // Images
  static const String logo = 'assets/images/logo.png';
  static const String heroBackground = 'assets/images/hero_bg.jpg';
  static const String defaultAvatar = 'assets/images/default_avatar.png';
  
  // Icons
  static const String shieldIcon = 'assets/icons/shield.svg';
  static const String alertIcon = 'assets/icons/alert.svg';
  static const String analyticsIcon = 'assets/icons/analytics.svg';
  static const String deployIcon = 'assets/icons/deploy.svg';
  static const String intelligenceIcon = 'assets/icons/intelligence.svg';
  static const String apiIcon = 'assets/icons/api.svg';
  
  // Fonts
  static const String primaryFont = 'Inter';
}

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String features = '/features';
  static const String about = '/about';
  static const String blog = '/blog';
  static const String blogDetail = '/blog/:id';
  static const String contact = '/contact';
}

enum Environment {
  development,
  staging,
  production,
}

class EnvironmentConfig {
  static const Environment currentEnvironment = Environment.development;
  
  static bool get isDevelopment => currentEnvironment == Environment.development;
  static bool get isStaging => currentEnvironment == Environment.staging;
  static bool get isProduction => currentEnvironment == Environment.production;
  
  static String get apiBaseUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return 'https://dev-api.ampdefend.com';
      case Environment.staging:
        return 'https://staging-api.ampdefend.com';
      case Environment.production:
        return 'https://api.ampdefend.com';
    }
  }
  
  static bool get enableLogging => !isProduction;
  static bool get enableAnalytics => isProduction;
}