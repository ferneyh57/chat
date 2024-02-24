import 'package:chat/data/model/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDataSource {
  Future<ChatUser> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<ChatUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String userName,
  });
}
