// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat/data/datasource/user/user_datasource.dart';
import 'package:chat/data/model/message.dart';
import 'package:chat/data/repository/message/message_repository.dart';
import 'package:chat/ui/pages/chat/view/chat_page.dart';
import 'package:chat/ui/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat/data/model/chat_user.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

class UserWidget extends StatefulWidget {
  final Stream<FirebaseDocumentHelper<List<ChatUser>>> Function(DocumentSnapshot? doc) getUsers;
  final String currentUserId;
  const UserWidget({
    super.key,
    required this.getUsers,
    required this.currentUserId,
  });

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  late Stream<FirebaseDocumentHelper<List<ChatUser>>> _userStream;
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _userStream = widget.getUsers(_lastDocument);
  }

  Future<void> _loadMoreData() async {
    final moreUsers = await widget.getUsers(_lastDocument).first;
    if (true == moreUsers.data?.isNotEmpty) {
      setState(() {
        _lastDocument = moreUsers.snapshot;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseDocumentHelper<List<ChatUser>>>(
      stream: _userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final users = snapshot.data?.data;
        return ListView.builder(
          itemCount: users?.where((user) => user.uid != widget.currentUserId).length ?? 0,
          itemBuilder: (context, index) {
            final user = users?.where((user) => user.uid != widget.currentUserId).toList()[index];
            return ListTile(
              title: Text(user?.email ?? ''),
              subtitle: Text(user?.lastSeen.toString() ?? ''),
              leading: Icon(
                Icons.circle,
                color: user?.status?.color,
              ),
              onTap: () {
                final messageRepo = GetIt.I<MessageRepository>();
                final conversationId = getConversationId(widget.currentUserId, user?.uid ?? '');
                final uuid = Uuid();
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => ChatPage(
                      receiverEmail: user?.email ?? '',
                      currentUserId: widget.currentUserId,
                      getMessages: (doc) {
                        return messageRepo.getAll(
                          conversationId: conversationId,
                          startAfter: doc,
                        );
                      },
                      onSendMessage: (content) async {
                        final message = Message(
                          senderId: widget.currentUserId,
                          receiverId: user?.uid ?? '',
                          content: content,
                          date: DateTime.now().millisecondsSinceEpoch,
                          conversationId: conversationId,
                          uid: uuid.v4(),
                        );
                        final (error, _) = await messageRepo.create(
                          message,
                          conversationId,
                        );

                        return error;
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
