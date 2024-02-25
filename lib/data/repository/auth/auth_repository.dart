// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat/data/datasource/auth/auth_firebase_datasource.dart';
import 'package:chat/data/datasource/user/user_datasource.dart';
import 'package:chat/data/model/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final FirebaseAuthDataSource firebaseAuthDataSource;
  final FireStoreDataSource fireStoreDataSource;
  AuthRepository({
    required this.firebaseAuthDataSource,
    required this.fireStoreDataSource,
  });

  Future<(String?, ChatUser?)> login({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse =
          await firebaseAuthDataSource.signInWithEmailPassword(email: email, password: password);
      final firestoreResponse = await fireStoreDataSource.getChatUser(authResponse.user?.uid ?? '');
      if (firestoreResponse == null) return ('We can not find your user', null);
      return (null, firestoreResponse);
    } on FirebaseAuthException catch (e) {
      debugPrint('error at AuthRepository FirebaseAuthException: $e');
      return (e.message, null);
    } catch (e) {
      debugPrint('error at AuthRepository: $e');
      return ('We can not find your user', null);
    }
  }

  Future<(String?, ChatUser?)> register({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse =
          await firebaseAuthDataSource.createUserWithEmailAndPassword(email: email, password: password);
      final user = authResponse.user;
      final firestoreResponse = await fireStoreDataSource.saveChatUser(
        user?.uid ?? '',
        ChatUser(
          userName: user?.displayName,
          email: user?.email,
          lastSeen: DateTime.now().millisecondsSinceEpoch,
        ),
      );
      if (firestoreResponse == null) return ('We can not find your user', null);
      return (null, firestoreResponse);
    } on FirebaseAuthException catch (e) {
      debugPrint('error at AuthRepository FirebaseAuthException: $e');
      return (e.message, null);
    } catch (e) {
      debugPrint('error at AuthRepository: $e');
      return ('We can not find your user', null);
    }
  }
}
