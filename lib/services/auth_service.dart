import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn? _googleSignIn;
  
  // Conditional initialization of GoogleSignIn
  static GoogleSignIn get googleSignIn {
    _googleSignIn ??= GoogleSignIn(
      scopes: ['email'],
      // Specific configuration to avoid type cast errors
      serverClientId: null, // Use default configuration
    );
    return _googleSignIn!;
  }

  // Obtenir l'utilisateur actuel
  static User? get currentUser => _auth.currentUser;

  // Stream to listen to authentication state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login with email and password
  static Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      // Input validation
      if (email.trim().isEmpty) {
        throw 'Email cannot be empty';
      }
      if (password.isEmpty) {
        throw 'Password cannot be empty';
      }
      
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Login error: $e';
    }
  }

  // Sign up with email and password
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

  // Google Sign-In (fixed version)
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // First clean up any previous session
      await googleSignIn.signOut();
      await _auth.signOut();
      
      // New connection attempt
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        // User cancelled the connection
        return null;
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create Firebase credentials
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Connect to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      return userCredential;
      
    } on FirebaseAuthException catch (e) {
      // Clean up in case of Firebase error
      await _cleanupGoogleSignIn();
      throw _handleAuthException(e);
    } catch (e) {
      // Clean up in case of general error
      await _cleanupGoogleSignIn();
      
      // Specific handling of PigeonUserDetails error
      if (e.toString().contains('PigeonUserDetails')) {
        throw 'Temporary Google Sign-In error. Please try again or use email login.';
      }
      
      throw 'Error during Google Sign-In: ${e.toString()}';
    }
  }
  
  // Cleanup method for Google Sign-In
  static Future<void> _cleanupGoogleSignIn() async {
    try {
      await googleSignIn.signOut();
    } catch (e) {
      // Ignorer les erreurs de nettoyage
      print('Erreur lors du nettoyage Google Sign-In: $e');
    }
  }

  // Password reset
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      // Sign out Google Sign-In first (if signed in)
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      // Then sign out Firebase Auth
      await _auth.signOut();
    } catch (e) {
      // Even in case of error, force local logout
      print('Error during sign out: $e');
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
      // Create a new GoogleSignIn instance to avoid conflicts
      final GoogleSignIn freshGoogleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      
      // Ensure we start from a clean state
      await freshGoogleSignIn.signOut();
      
      // Attempt connection
      final GoogleSignInAccount? googleUser = await freshGoogleSignIn.signIn();
      
      if (googleUser == null) {
        return null; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (googleAuth.accessToken == null && googleAuth.idToken == null) {
        throw 'Unable to obtain authentication tokens';
      }
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
      
    } catch (e) {
      if (e.toString().contains('PigeonUserDetails') || 
          e.toString().contains('List<Object?>')) {
        throw 'Google Sign-In temporarily unavailable. Use email login.';
      }
      throw 'Google Sign-In error: ${e.toString()}';
    }
  }
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already in use.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Invalid email.';
      case 'invalid-credential':
        return 'Invalid credentials.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}