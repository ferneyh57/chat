import 'package:chat/data/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageDataSource {
  final _messageCollection = FirebaseFirestore.instance.collection('Messages');

  Stream<List<Message>> getMessages({int limit = 10, DocumentSnapshot? startAfter}) {
    Query query = _messageCollection.orderBy('date', descending: true).limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromJson(doc.data()! as Map<String, dynamic>)).toList();
    });
  }

  Future<Message> sendMessage(Message message) async {
    await _messageCollection.add(message.toJson());
    return message;
  }
}
