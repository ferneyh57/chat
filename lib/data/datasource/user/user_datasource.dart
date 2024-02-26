// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat/data/model/chat_user.dart';

class UserDataSource {
  final _userCollection = FirebaseFirestore.instance.collection('Users');
  Future<ChatUser?> getByUid(String uid) async {
    final user = await _userCollection.doc(uid).get();
    if (!user.exists || user.data() == null) return null;
    return ChatUser.fromJson(user.data()!);
  }

  Future<ChatUser?> create(String uid, ChatUser user) async {
    await _userCollection.doc(uid).set(user.toJson());
    return user;
  }

  Stream<FirebaseDocumentHelper<List<ChatUser>>> getAll({int limit = 10, DocumentSnapshot? startAfter}) {
    Query query = _userCollection.orderBy('lastSeen', descending: true).limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    return query.snapshots().map((snapshot) {
      final users =
          snapshot.docs.map((doc) => ChatUser.fromJson(doc.data()! as Map<String, dynamic>)).toList();
      final lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      final result = FirebaseDocumentHelper<List<ChatUser>>(data: users, snapshot: lastDocument);
      return result;
    });
  }
}

class FirebaseDocumentHelper<T> {
  final DocumentSnapshot? snapshot;
  final T? data;
  FirebaseDocumentHelper({
    this.snapshot,
    required this.data,
  });
}
