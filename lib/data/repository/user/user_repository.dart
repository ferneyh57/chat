// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat/data/datasource/user/user_datasource.dart';
import 'package:chat/data/model/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserRepository {
  final UserDataSource userDataSource;
  UserRepository({
    required this.userDataSource,
  });
  Future<(String?, ChatUser?)> getByUid(String uid) async {
    try {
      final result = await userDataSource.getByUid(uid);
      if (result == null) return ('The user could not be get', null);
      return (null, result);
    } catch (e) {
      debugPrint('error at UserRepository in getByUid: $e');
      return ('error getting the user', null);
    }
  }

  Future<(String?, ChatUser?)> create(String uid, ChatUser user) async {
    try {
      final result = await userDataSource.create(uid, user);
      if (result == null) return ('The user could not be created', null);
      return (null, result);
    } catch (e) {
      debugPrint('error at UserRepository in create: $e');
      return ('error creating the user', null);
    }
  }

  Stream<FirebaseDocumentHelper<List<ChatUser>>> getAll({int limit = 10, DocumentSnapshot? startAfter}) {
    return userDataSource.getAll(limit: limit, startAfter: startAfter);
  }
}
