import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_button.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    // Show content after a delay for the logo animation
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Logo and brand section
                Column(
                  children: [
                    // Animated logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.shield,
                                size: 60,
                                color: Color(0xFF0D6EFD),
                              );
                            },
                          ),
                        ),
                      ),
                    ).animate().scale(
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.elasticOut,
                    ).then().shimmer(
                      duration: const Duration(milliseconds: 1500),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Brand name
                    Text(
                      'AMPDefend',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(
                      duration: const Duration(milliseconds: 800),
                      delay: const Duration(milliseconds: 500),
                    ).slideY(
                      begin: 0.3,
                      duration: const Duration(milliseconds: 800),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Tagline
                    Text(
                      'Smart Honeypot Shield',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w300,
                      ),
                    ).animate().fadeIn(
                      duration: const Duration(milliseconds: 800),
                      delay: const Duration(milliseconds: 800),
                    ).slideY(
                      begin: 0.3,
                      duration: const Duration(milliseconds: 800),
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Content section (appears after delay)
                if (_showContent) ...[
                  Column(
                    children: [
                      Text(
                        'Protect your infrastructure with next-generation security intelligence',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 600),
                      ).slideY(
                        begin: 0.2,
                        duration: const Duration(milliseconds: 600),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Feature highlights
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFeatureHighlight(
                            context,
                            Icons.psychology,
                            'IA Avancée',
                          ),
                          _buildFeatureHighlight(
                            context,
                            Icons.speed,
                            'Temps Réel',
                          ),
                          _buildFeatureHighlight(
                            context,
                            Icons.security,
                            'Sécurisé',
                          ),
                        ],
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 200),
                      ).slideY(
                        begin: 0.2,
                        duration: const Duration(milliseconds: 600),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Get Started button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Commencer',
                          onPressed: () {
                            context.go('/home');
                          },
                          type: ButtonType.primary,
                          height: 56,
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 400),
                      ).slideY(
                        begin: 0.2,
                        duration: const Duration(milliseconds: 600),
                      ),
                    ],
                  ),
                ],
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureHighlight(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}