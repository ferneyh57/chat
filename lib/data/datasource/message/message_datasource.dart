import 'package:chat/data/datasource/datasource.dart';
import 'package:chat/data/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageDataSource {
  final _messageCollection = FirebaseFirestore.instance.collection('Messages');

  Stream<FirebaseDocumentHelper<List<Message>>> getAll({
    required String conversationId,
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) {
    Query query = _messageCollection
        .where('ConversationId', isEqualTo: conversationId)
        .orderBy('date', descending: true)
        .limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    return query.snapshots().map((snapshot) {
      final users =
          snapshot.docs.map((doc) => Message.fromJson(doc.data()! as Map<String, dynamic>)).toList();
      final lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      final result = FirebaseDocumentHelper<List<Message>>(data: users, snapshot: lastDocument);
      return result;
    });
  }

  Future<Message> create(Message message) async {
    await _messageCollection.add(message.toJson());
    return message;
  }
}
