// lib/data/services/firebase_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    String message;
    print(e.code);
    switch (e.code) {
      case 'user-not-found':
        message = 'No user found with this email.';
        break;
      case 'email-already-in-use':
        message = 'The email address is already in use.';
        break;
      case 'invalid-email':
        message = 'The email address is invalid.';
        break;
      case 'weak-password':
        message = 'The password is too weak.';
        break;
      case 'operation-not-allowed':
        message = 'This operation is not allowed.';
        break;
      case 'invalid-credential':
        message = 'Incorrect email or password';
      default:
        message = 'An error occurred. Please try again.';
    }
    return message;
  }

  // Google Authentication
  Future<User?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      return userCredential.user;
    } catch (e) {
      print("Google Sign_In Error: $e");
      return null;
    }
  }

  // Future<void> _signOut() async {
  //   await _googleSignIn.signOut();
  //   await _auth.signOut();
  // }
}
