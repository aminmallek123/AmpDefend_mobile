import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  /// Formats a date in French format
  static String formatDate(DateTime date) {
    final months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
  
  /// Calcule le temps de lecture estimé d'un texte
  static int calculateReadingTime(String text) {
    const wordsPerMinute = 200;
    final wordCount = text.split(' ').length;
    final readingTime = (wordCount / wordsPerMinute).ceil();
    return readingTime < 1 ? 1 : readingTime;
  }
  
  /// Validates an email address
  static bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }
  
  /// Validates a French phone number
  static bool isValidPhoneNumber(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\.\(\)]'), '');
    return RegExp(r'^(\+33|0)[1-9](\d{8})$').hasMatch(cleanPhone);
  }
  
  /// Opens a URL in the browser
  static Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Unable to open URL: $url');
    }
  }
  
  /// Opens the email app with a pre-filled address
  static Future<void> launchEmail(String email, {String? subject, String? body}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Unable to open email: $email');
    }
  }
  
  /// Ouvre l'application téléphone
  static Future<void> launchPhone(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Impossible d\'ouvrir le téléphone: $phoneNumber');
    }
  }
  
  /// Affiche un SnackBar avec un message
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError 
          ? Theme.of(context).colorScheme.error 
          : Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  /// Affiche une boîte de dialogue de confirmation
  static Future<bool> showConfirmationDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    ) ?? false;
  }
  
  /// Génère un gradient basé sur le thème
  static Gradient createGradient(BuildContext context, {bool isDark = false}) {
    final colors = isDark
        ? [
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
            Theme.of(context).colorScheme.secondary.withOpacity(0.6),
          ]
        : [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.05),
          ];
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }
  
  /// Retourne les initiales d'un nom
  static String getInitials(String name) {
    return name
        .split(' ')
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join();
  }
  
  /// Formate un nombre avec des séparateurs de milliers
  static String formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]} ',
    );
  }
  
  /// Vérifie si l'appareil est en mode sombre
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
  
  /// Retourne la taille de l'écran
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
  
  /// Vérifie si c'est un écran mobile
  static bool isMobile(BuildContext context) {
    return getScreenSize(context).width < 600;
  }
  
  /// Vérifie si c'est une tablette
  static bool isTablet(BuildContext context) {
    final width = getScreenSize(context).width;
    return width >= 600 && width < 1200;
  }
  
  /// Vérifie si c'est un desktop
  static bool isDesktop(BuildContext context) {
    return getScreenSize(context).width >= 1200;
  }
  
  /// Débounce une fonction (utile pour les recherches)
  static void debounce(
    Duration delay,
    VoidCallback callback,
  ) {
    Timer(delay, callback);
  }
}

/// Extension pour simplifier la navigation
extension NavigationExtension on BuildContext {
  void pushNamed(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }
  
  void pop([Object? result]) {
    Navigator.of(this).pop(result);
  }
  
  void pushReplacementNamed(String routeName, {Object? arguments}) {
    Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  }
}

/// Extension pour les widgets
extension WidgetExtension on Widget {
  Widget padding(EdgeInsets padding) {
    return Padding(padding: padding, child: this);
  }
  
  Widget center() {
    return Center(child: this);
  }
  
  Widget expanded([int flex = 1]) {
    return Expanded(flex: flex, child: this);
  }
}

/// Extension pour les couleurs
extension ColorExtension on Color {
  /// Retourne une couleur plus claire
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
  
  /// Retourne une couleur plus sombre
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
