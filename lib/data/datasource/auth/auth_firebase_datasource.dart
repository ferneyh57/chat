import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource {
  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  User? getCurrentAuthUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
