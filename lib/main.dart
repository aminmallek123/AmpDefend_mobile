import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'theme/theme_manager.dart';
import 'services/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: AMPDefendApp(),
    ),
  );
}

class AMPDefendApp extends StatefulWidget {
  const AMPDefendApp({super.key});

  @override
  State<AMPDefendApp> createState() => _AMPDefendAppState();
}

class _AMPDefendAppState extends State<AMPDefendApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    // Enregistrer la fonction de basculement de thème
    ThemeManager().setToggleThemeCallback(toggleTheme);
  }

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AMPDefend - Smart Honeypot Shield',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      
      // Router configuration
      routerConfig: AppRouter.router,
      
      // Localization (for future use)
      locale: const Locale('fr', 'FR'),
      
      // App metadata
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
          ),
          child: child!,
        );
      },
    );
  }
}