import 'package:firebase_auth/firebase_auth.dart';
import 'package:woofcare/config/constants.dart';

class Auth {
  User? get currentUser => AUTH.currentUser;

  Stream<User?> get authStateChanges => AUTH.authStateChanges();

  Future<void> login({required String email, required String password}) async {
    await AUTH.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signup({required String email, required String password}) async {
    await AUTH.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await AUTH.signOut();
  }
}
