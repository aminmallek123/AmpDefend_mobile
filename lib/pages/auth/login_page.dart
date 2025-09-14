import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      UserCredential? result;
      
      if (_isSignUp) {
        result = await AuthService.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
        if (result != null) {
          _showMessage('Compte créé avec succès!');
        }
      } else {
        result = await AuthService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
      }
      
      // Vérifier que la connexion a réussi
      if (result != null && result.user != null && mounted) {
        context.go('/dashboard');
      } else if (mounted) {
        _showMessage('Erreur de connexion inconnue', isError: true);
      }
    } catch (e) {
      if (mounted) {
        _showMessage(e.toString(), isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      // Essayer d'abord la méthode standard
      UserCredential? result = await AuthService.signInWithGoogle();
      
      if (result != null && result.user != null && mounted) {
        context.go('/dashboard');
        return;
      } else if (mounted) {
        _showMessage('Connexion Google annulée', isError: false);
        return;
      }
      
    } catch (e) {
      // Si erreur PigeonUserDetails, essayer la méthode alternative
      if (e.toString().contains('PigeonUserDetails') || 
          e.toString().contains('List<Object?>')) {
        try {
          if (mounted) {
            _showMessage('Nouvelle tentative de connexion Google...', isError: false);
          }
          
          final result = await AuthService.signInWithGoogleAlternative();
          
          if (result != null && result.user != null && mounted) {
            context.go('/dashboard');
            return;
          }
        } catch (alternativeError) {
          if (mounted) {
            _showMessage('Google Sign-In indisponible. Utilisez la connexion par email.', isError: true);
          }
          return;
        }
      }
      
      // Autres erreurs
      if (mounted) {
        _showMessage('Erreur Google Sign-In: ${e.toString()}', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      _showMessage('Veuillez entrer votre email', isError: true);
      return;
    }

    try {
      await AuthService.resetPassword(_emailController.text.trim());
      _showMessage('Email de réinitialisation envoyé!');
    } catch (e) {
      _showMessage(e.toString(), isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.primary,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo/Titre
                        Icon(
                          Icons.security,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isSignUp ? 'Créer un compte' : 'Connexion',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          'AmpDefend - Protection Avancée',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Champ Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre email';
                            }
                            if (!value.contains('@')) {
                              return 'Email invalide';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Champ Mot de passe
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre mot de passe';
                            }
                            if (_isSignUp && value.length < 6) {
                              return 'Le mot de passe doit contenir au moins 6 caractères';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Bouton principal
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: _isSignUp ? 'Créer le compte' : 'Se connecter',
                            onPressed: _isLoading ? null : _submitForm,
                            isLoading: _isLoading,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[300])),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OU',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey[300])),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Bouton Google
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _signInWithGoogle,
                            icon: const Icon(Icons.login),
                            label: const Text('Continuer avec Google'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Mot de passe oublié
                        if (!_isSignUp)
                          TextButton(
                            onPressed: _resetPassword,
                            child: const Text('Mot de passe oublié ?'),
                          ),

                        const SizedBox(height: 16),

                        // Basculer entre connexion et inscription
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isSignUp
                                  ? 'Déjà un compte ?'
                                  : 'Pas encore de compte ?',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isSignUp = !_isSignUp;
                                  _formKey.currentState?.reset();
                                });
                              },
                              child: Text(_isSignUp ? 'Se connecter' : 'S\'inscrire'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}