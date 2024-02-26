// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat/data/datasource/auth/auth_datasource.dart';
import 'package:chat/data/datasource/user/user_datasource.dart';
import 'package:chat/data/model/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepository({
    required this.authDataSource,
  });

  Future<(String?, User?)> login({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await authDataSource.signInWithEmailPassword(email: email, password: password);
      return (null, authResponse.user);
    } on FirebaseAuthException catch (e) {
      debugPrint('error at AuthRepository FirebaseAuthException: ${e.code}');
      return (e.message, null);
    } catch (e) {
      debugPrint('error at AuthRepository: $e');
      return ('We can not find your user', null);
    }
  }

  Future<(String?, User?)> register({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse =
          await authDataSource.createUserWithEmailAndPassword(email: email, password: password);
      return (null, authResponse.user);
    } on FirebaseAuthException catch (e) {
      debugPrint('error at AuthRepository FirebaseAuthException: $e');
      return (e.message, null);
    } catch (e) {
      debugPrint('error at AuthRepository: $e');
      return ('We can not find your user', null);
    }
  }

  Future<void> logout() => authDataSource.logout();

  User? getCurrentAuthUser() => authDataSource.getCurrentAuthUser();
  Stream<User?> getUserStatus() => authDataSource.getUserStatus();
}
