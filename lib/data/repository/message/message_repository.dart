// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat/data/datasource/message/message_datasource.dart';
import 'package:chat/data/datasource/user/user_datasource.dart';
import 'package:chat/data/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageRepository {
  final MessageDataSource messageDataSource;
  MessageRepository({
    required this.messageDataSource,
  });
  Stream<FirebaseDocumentHelper<List<Message>>>? getAll({
    required String conversationId,
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) {
    try {
      return messageDataSource.getAll(
        conversationId: conversationId,
        startAfter: startAfter,
      );
    } catch (e) {
      debugPrint('error at MessageRepository in getAll: $e');
      return null;
    }
  }

  Future<(String?, Message?)> create(
    Message message,
    String conversationId,
  ) async {
    try {
      final result = await messageDataSource.create(message, conversationId);
      return (null, result);
    } catch (e) {
      debugPrint('error at MessageRepository in create: $e');
      return ('Error sending the message try again', null);
    }
  }
}
