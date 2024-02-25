// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
part 'chat_user.g.dart';

@JsonSerializable()
class ChatUser {
  final String? userName;
  final int? lastSeen;
  final String? email;
  final String? uid;
  ChatUser({
    this.userName,
    this.lastSeen,
    this.email,
    this.uid,
  });
  factory ChatUser.fromJson(Map<String, dynamic> json) => _$ChatUserFromJson(json);
  Map<String, dynamic> toJson() => _$ChatUserToJson(this);
}
