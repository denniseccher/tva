import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Funzione per il login con Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Avvia il flusso di Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Se l'utente annulla il login
      if (googleUser == null) {
        return null;
      }

      // 2. Ottieni i dettagli dell'autenticazione dalla richiesta
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Crea una credenziale Firebase con i token Google
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Esegui l'accesso a Firebase con la credenziale
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      print("Utente loggato con Google: ${userCredential.user?.uid}");
      return userCredential;

    } on FirebaseAuthException catch (e) {
      print("Errore FirebaseAuth: ${e.message}");
      // Gestisci errori specifici di Firebase Auth (es. account-exists-with-different-credential)
      return null;
    } catch (e) {
      print("Errore generico durante il Google Sign-In: $e");
      return null;
    }
  }

  // Funzione per il logout
  Future<void> signOut() async {
    await _googleSignIn.signOut(); // Logout da Google
    await _auth.signOut();       // Logout da Firebase
    print("Utente disconnesso");
  }

  // Stream per ascoltare i cambiamenti dello stato di autenticazione
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}