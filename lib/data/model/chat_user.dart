// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ChatUser {
  final UserCredential? credential;
  final String userName;
  final int? lastSeen;
  ChatUser({
    required this.userName,
    this.credential,
    this.lastSeen,
  });
  factory ChatUser.fromJson(Map<String, dynamic> json) => _$ChatUserFromJson(json);
  Map<String, dynamic> toJson() => _$ChatUserToJson(this);
}
