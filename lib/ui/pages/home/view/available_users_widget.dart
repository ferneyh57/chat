// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat/data/datasource/user/user_datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat/data/model/chat_user.dart';

class UserWidget extends StatefulWidget {
  final Stream<FirebaseDocumentHelper<List<ChatUser>>> Function(DocumentSnapshot? doc) getUsers;
  const UserWidget({
    super.key,
    required this.getUsers,
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
    if (moreUsers.data.isNotEmpty) {
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
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final users = snapshot.data?.data;
          return ListView.builder(
            itemCount: users!.length + 1,
            itemBuilder: (context, index) {
              if (index < users.length) {
                final user = users[index];
                return ListTile(
                  title: Text(user.email ?? ''),
                  subtitle: Text(user.lastSeen.toString()),
                  onTap: () {},
                );
              } else {
                if (index == users.length && users.length % 10 == 0) {
                  _loadMoreData();
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  // Si hemos cargado todos los datos disponibles.
                  return SizedBox();
                }
              }
            },
          );
        }
      },
    );
  }
}
