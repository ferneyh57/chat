// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat/data/datasource/user/user_datasource.dart';
import 'package:chat/data/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat/data/model/chat_user.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final Stream<FirebaseDocumentHelper<List<Message>>>? Function(DocumentSnapshot? doc) getMessages;
  final Future<String?> Function(String content) onSendMessage;
  final String currentUserId;
  final String receiverEmail;
  const ChatPage({
    super.key,
    required this.getMessages,
    required this.onSendMessage,
    required this.currentUserId,
    required this.receiverEmail,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Stream<FirebaseDocumentHelper<List<Message>>>? _messageStream;
  DocumentSnapshot? _lastDocument;
  final TextEditingController _chatController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _messageStream = widget.getMessages(_lastDocument);
  }

/*
  Future<void> _loadMoreData() async {
    final moreUsers = await widget.getMessages(_lastDocument)?.first;
    if (true == moreUsers?.data.isNotEmpty) {
      setState(() {
        _lastDocument = moreUsers?.snapshot;
      });
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: StreamBuilder<FirebaseDocumentHelper<List<Message>>>(
          stream: _messageStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Center(child: SelectableText('Error: ${snapshot.error}'));
            }
            final messages = snapshot.data?.data;
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: messages?.length ?? 0,
                    itemBuilder: (context, index) {
                      final message = messages?[index];
                      final timestamp = Timestamp.fromMillisecondsSinceEpoch(message?.date ?? 0);
                      return Column(
                        crossAxisAlignment: widget.currentUserId == message?.senderId
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(message?.content ?? ''),
                          ),
                          const SizedBox(height: 6),
                          Text(DateFormat('dd/MM hh:mm a').format(timestamp.toDate())),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  ),
                ),
                const Spacer(),
                TextFormField(
                  controller: _chatController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        final error = await widget.onSendMessage(_chatController.text);
                        if (error != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                            ),
                          );
                          return;
                        }
                        _chatController.clear();
                      },
                    ),
                    hintText: 'Type something',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
