import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn? _googleSignIn;
  
  // Initialisation conditionnelle de GoogleSignIn
  static GoogleSignIn get googleSignIn {
    _googleSignIn ??= GoogleSignIn(
      scopes: ['email'],
      // Configuration spécifique pour éviter les erreurs de type cast
      serverClientId: null, // Utiliser la configuration par défaut
    );
    return _googleSignIn!;
  }

  // Obtenir l'utilisateur actuel
  static User? get currentUser => _auth.currentUser;

  // Stream pour écouter les changements d'état d'authentification
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Connexion avec email et mot de passe
  static Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      // Validation des entrées
      if (email.trim().isEmpty) {
        throw 'L\'email ne peut pas être vide';
      }
      if (password.isEmpty) {
        throw 'Le mot de passe ne peut pas être vide';
      }
      
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Erreur de connexion: $e';
    }
  }

  // Inscription avec email et mot de passe
  static Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Connexion avec Google (version corrigée)
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Nettoyer d'abord toute session précédente
      await googleSignIn.signOut();
      await _auth.signOut();
      
      // Nouvelle tentative de connexion
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        // L'utilisateur a annulé la connexion
        return null;
      }

      // Obtenir les détails d'authentification
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Créer les credentials Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Se connecter à Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      return userCredential;
      
    } on FirebaseAuthException catch (e) {
      // Nettoyer en cas d'erreur Firebase
      await _cleanupGoogleSignIn();
      throw _handleAuthException(e);
    } catch (e) {
      // Nettoyer en cas d'erreur générale
      await _cleanupGoogleSignIn();
      
      // Gestion spécifique de l'erreur PigeonUserDetails
      if (e.toString().contains('PigeonUserDetails')) {
        throw 'Erreur temporaire de Google Sign-In. Veuillez réessayer ou utilisez la connexion par email.';
      }
      
      throw 'Erreur lors de la connexion avec Google: ${e.toString()}';
    }
  }
  
  // Méthode de nettoyage pour Google Sign-In
  static Future<void> _cleanupGoogleSignIn() async {
    try {
      await googleSignIn.signOut();
    } catch (e) {
      // Ignorer les erreurs de nettoyage
      print('Erreur lors du nettoyage Google Sign-In: $e');
    }
  }

  // Réinitialisation du mot de passe
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Déconnexion
  static Future<void> signOut() async {
    try {
      // Déconnecter Google Sign-In d'abord (si connecté)
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      // Puis déconnecter Firebase Auth
      await _auth.signOut();
    } catch (e) {
      // Même en cas d'erreur, on force la déconnexion locale
      print('Erreur lors de la déconnexion: $e');
      try {
        await googleSignIn.signOut();
      } catch (_) {}
      try {
        await _auth.signOut();
      } catch (_) {}
    }
  }

  // Version alternative de Google Sign-In pour contourner l'erreur PigeonUserDetails
  static Future<UserCredential?> signInWithGoogleAlternative() async {
    try {
      // Créer une nouvelle instance GoogleSignIn pour éviter les conflits
      final GoogleSignIn freshGoogleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      
      // S'assurer qu'on part d'un état propre
      await freshGoogleSignIn.signOut();
      
      // Tenter la connexion
      final GoogleSignInAccount? googleUser = await freshGoogleSignIn.signIn();
      
      if (googleUser == null) {
        return null; // Utilisateur a annulé
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (googleAuth.accessToken == null && googleAuth.idToken == null) {
        throw 'Impossible d\'obtenir les tokens d\'authentification';
      }
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
      
    } catch (e) {
      if (e.toString().contains('PigeonUserDetails') || 
          e.toString().contains('List<Object?>')) {
        throw 'Google Sign-In temporairement indisponible. Utilisez la connexion par email.';
      }
      throw 'Erreur Google Sign-In: ${e.toString()}';
    }
  }
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'weak-password':
        return 'Le mot de passe est trop faible.';
      case 'invalid-email':
        return 'Email invalide.';
      case 'invalid-credential':
        return 'Identifiants invalides.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';
      default:
        return 'Erreur d\'authentification: ${e.message}';
    }
  }
}