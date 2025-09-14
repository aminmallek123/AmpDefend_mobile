import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/feature_card.dart';
import '../../widgets/testimonial_card.dart';
import '../../services/mock_data.dart';
import '../../services/auth_service.dart';
import '../../theme/theme_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarTransparent = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isTransparent = _scrollController.offset < 100;
    if (isTransparent != _isAppBarTransparent) {
      setState(() {
        _isAppBarTransparent = isTransparent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        isTransparent: _isAppBarTransparent,
        actions: [
          StreamBuilder<User?>(
            stream: AuthService.authStateChanges,
            builder: (context, snapshot) {
              final isSignedIn = snapshot.data != null;
              
              if (isSignedIn) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.brightness_6),
                      onPressed: () {
                        ThemeManager().toggleTheme();
                      },
                      tooltip: 'Changer le thème',
                    ),
                    IconButton(
                      icon: const Icon(Icons.dashboard),
                      onPressed: () {
                        context.go('/dashboard');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        await AuthService.signOut();
                      },
                    ),
                  ],
                );
              } else {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.brightness_6),
                      onPressed: () {
                        ThemeManager().toggleTheme();
                      },
                      tooltip: 'Changer le thème',
                    ),
                    IconButton(
                      icon: const Icon(Icons.login),
                      onPressed: () {
                        context.go('/login');
                      },
                    ),
                  ],
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: _buildDrawer(context),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _buildHeroSection(context),
            _buildFeaturesSection(context),
            _buildStatsSection(context),
            _buildTestimonialsSection(context),
            _buildClientLogosSection(context),
            _buildCTASection(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
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
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            
            // Hero content
            Column(
              children: [
                Text(
                  'AMPDefend',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'Smart Honeypot Shield',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  'Protégez votre infrastructure avec des solutions de cybersécurité intelligentes et proactives. Notre technologie de honeypots avancée détecte les menaces en temps réel.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // CTA Buttons
                StreamBuilder<User?>(
                  stream: AuthService.authStateChanges,
                  builder: (context, snapshot) {
                    final isSignedIn = snapshot.data != null;
                    
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        if (isSignedIn) ...[
                          CustomButton(
                            text: 'Accéder au Dashboard',
                            onPressed: () {
                              context.go('/dashboard');
                            },
                            icon: Icons.dashboard,
                            width: 220,
                            height: 56,
                          ),
                          CustomButton(
                            text: 'Voir Statistiques',
                            onPressed: () {
                              context.go('/statistics');
                            },
                            type: ButtonType.secondary,
                            icon: Icons.analytics,
                            width: 200,
                            height: 56,
                          ),
                        ] else ...[
                          CustomButton(
                            text: 'Se Connecter',
                            onPressed: () {
                              context.go('/login');
                            },
                            icon: Icons.login,
                            width: 200,
                            height: 56,
                          ),
                          CustomButton(
                            text: 'En Savoir Plus',
                            onPressed: () {
                              context.go('/features');
                            },
                            type: ButtonType.secondary,
                            width: 200,
                            height: 56,
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
            
            const Spacer(),
            
            // Scroll indicator
            Column(
              children: [
                Text(
                  'Découvrir',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Fonctionnalités Principales',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Découvrez les technologies qui font d\'AMPDefend la solution de sécurité la plus avancée du marché.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Features carousel
          CarouselSlider(
            options: CarouselOptions(
              height: 300,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              viewportFraction: 0.9,
            ),
            items: MockData.features.take(4).map((feature) {
              return FeatureCard(
                feature: feature,
                isHighlighted: feature.isHighlighted,
                onTap: () {
                  context.go('/features');
                },
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          CustomButton(
            text: 'Voir Toutes les Fonctionnalités',
            onPressed: () {
              context.go('/features');
            },
            type: ButtonType.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final stats = MockData.statistics;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
      ),
      child: Column(
        children: [
          Text(
            'Chiffres Clés',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildStatCard(context, stats['threatsDetected']!.toString(), 'Menaces Détectées'),
              _buildStatCard(context, stats['clientsProtected']! as String, 'Clients Protégés'),
              _buildStatCard(context, stats['uptimePercentage']!.toString(), 'Disponibilité'),
              _buildStatCard(context, stats['averageResponseTime']!.toString(), 'Temps de Réponse'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestimonialsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Ce que disent nos clients',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          CarouselSlider(
            options: CarouselOptions(
              height: 220,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              viewportFraction: 0.9,
            ),
            items: MockData.testimonials.map((testimonial) {
              return TestimonialCard(testimonial: testimonial);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildClientLogosSection(BuildContext context) {
    // Liste des logos d'assets
    final List<String> logoAssets = [
      'assets/centro.png',
      'assets/global.png',
      'assets/pes.png',
      'assets/region_8.png',
      'assets/smart.png',
      'assets/tn_section.png',
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        children: [
          Text(
            'Ils nous font confiance',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Affichage des vraies images de logos
          Wrap(
            spacing: 32,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: logoAssets.map((assetPath) {
              return Container(
                width: 120,
                height: 60,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // Arrière-plan sombre pour que les logos blancs soient toujours visibles
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade800,
                      Colors.grey.shade700,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade600,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Prêt à sécuriser votre infrastructure ?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Commencez votre essai gratuit dès aujourd\'hui et découvrez la puissance d\'AMPDefend.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          CustomButton(
            text: 'Démarrer l\'essai gratuit',
            onPressed: () {
              context.go('/contact');
            },
            icon: Icons.rocket_launch,
            width: 250,
            height: 56,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shield,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'AMPDefend',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            '© 2024 AMPDefend. Tous droits réservés.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.shield,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'AMPDefend',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Smart Security',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Accueil'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Dashboard Sécurité'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Fonctionnalités'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/features');
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Blog'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/blog');
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('À propos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/contact');
            },
          ),
          
          const Spacer(),
          
          // Social links
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.link),
                  onPressed: () {},
                  tooltip: 'LinkedIn',
                ),
                IconButton(
                  icon: const Icon(Icons.alternate_email),
                  onPressed: () {},
                  tooltip: 'Twitter',
                ),
                IconButton(
                  icon: const Icon(Icons.code),
                  onPressed: () {},
                  tooltip: 'GitHub',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}