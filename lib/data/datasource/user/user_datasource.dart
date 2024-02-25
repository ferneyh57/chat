import 'package:chat/data/model/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreDataSource {
  final _userCollection = FirebaseFirestore.instance.collection('Users');
  Future<ChatUser?> getChatUser(String uid) async {
    final user = await _userCollection.doc(uid).get();
    if (!user.exists || user.data() == null) return null;
    return ChatUser.fromJson(user.data()!);
  }

  Future<ChatUser?> saveChatUser(String uid, ChatUser user) async {
    await _userCollection.doc(uid).set(user.toJson());
    return user;
  }

  Stream<List<ChatUser>> getMessages({int limit = 10, DocumentSnapshot? startAfter}) {
    Query query = _userCollection.orderBy('lastSeen', descending: true).limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ChatUser.fromJson(doc.data()! as Map<String, dynamic>)).toList();
    });
  }
}
