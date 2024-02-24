import 'package:chat/data/model/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreDataSource {
  Future<ChatUser?> getChatUser(String uid) async {
    final user = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    if (!user.exists) return null;
  }
}
