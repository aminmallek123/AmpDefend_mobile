import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../pages/splash/splash_page.dart';
import '../pages/home/home_page.dart';
import '../pages/features/features_page.dart';
import '../pages/about/about_page.dart';
import '../pages/blog/blog_page.dart';
import '../pages/blog/blog_detail_page.dart';
import '../pages/contact/contact_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/auth_wrapper.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/dashboard/statistics_page.dart';
import '../test_firebase.dart';
import '../models/blog_post.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // Start with the home page
    debugLogDiagnostics: true,
    routes: [
      // Auth Wrapper
      GoRoute(
        path: '/',
        name: 'auth',
        builder: (context, state) => const AuthWrapper(),
      ),
      
      // Login
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      
      // Splash/Onboarding
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      
      // Home
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      
      // Dashboard
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      
      // Statistics
      GoRoute(
        path: '/statistics',
        name: 'statistics',
        builder: (context, state) => const StatisticsPage(),
      ),
      
      // Features
      GoRoute(
        path: '/features',
        name: 'features',
        builder: (context, state) => const FeaturesPage(),
      ),
      
      // About
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const AboutPage(),
      ),
      
      // Blog
      GoRoute(
        path: '/blog',
        name: 'blog',
        builder: (context, state) => const BlogPage(),
        routes: [
          GoRoute(
            path: '/:id',
            name: 'blog-detail',
            builder: (context, state) {
              final blogPost = state.extra as BlogPost?;
              if (blogPost == null) {
                return const Scaffold(
                  body: Center(
                    child: Text('Article non trouvé'),
                  ),
                );
              }
              return BlogDetailPage(post: blogPost);
            },
          ),
        ],
      ),
      
      // Contact
      GoRoute(
        path: '/contact',
        name: 'contact',
        builder: (context, state) => const ContactPage(),
      ),
      
      // Test Firebase (temporaire)
      GoRoute(
        path: '/test-firebase',
        name: 'test-firebase',
        builder: (context, state) => const FirebaseTestPage(),
      ),
    ],
    
    // Error page
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Erreur'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Page not found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.uri.toString()}" does not exist.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    ),
  );
}