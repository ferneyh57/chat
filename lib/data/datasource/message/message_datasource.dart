import 'package:chat/data/datasource/datasource.dart';
import 'package:chat/data/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageDataSource {
  final _converstionCollection = FirebaseFirestore.instance.collection('Conversations');
  Stream<FirebaseDocumentHelper<List<Message>>>? getAll({
    required String conversationId,
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) {
    try {
      Query query = _converstionCollection
          .doc(conversationId)
          .collection('Messages')
          .orderBy('date', descending: false)
          .limit(limit);
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }
      return query.snapshots().map((snapshot) {
        final users =
            snapshot.docs.map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>)).toList();
        final lastDocument = snapshot.docs.last;
        final result = FirebaseDocumentHelper<List<Message>>(data: users, snapshot: lastDocument);
        return result;
      });
    } catch (e) {
      debugPrint('error at MessageDataSource in getAll: $e');
    }
    return null;
  }

  Future<Message> create(
    Message message,
    String conversationId,
  ) async {
    final docRef = _converstionCollection.doc(conversationId);
    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      await docRef.set({'lastMessage': message.toJson()});
    } else {
      await docRef.update({'lastMessage': message.toJson()});
    }
    await docRef.collection('Messages').add(message.toJson());
    return message;
    ;
  }
}
