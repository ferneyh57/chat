// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
part 'message.g.dart';

@JsonSerializable()
class Message {
  final String uid;
  final String senderId;
  final String receiverId;
  final String content;
  final int date;
  final bool seen;
  final MessageType type;
  final String conversationId;
  Message({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.date,
    this.seen = false,
    this.type = MessageType.text,
    required this.uid,
    required this.conversationId,
  });
  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  Message copyWith({
    String? uid,
    String? senderId,
    String? receiverId,
    String? content,
    int? date,
    bool? seen,
    MessageType? type,
    String? conversationId,
  }) {
    return Message(
      uid: uid ?? this.uid,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      date: date ?? this.date,
      seen: seen ?? this.seen,
      type: type ?? this.type,
      conversationId: conversationId ?? this.conversationId,
    );
  }
}

enum MessageType {
  text('text'),
  audio('audio'),
  video('video'),
  photo('photo');

  const MessageType(this.value);
  final String value;
}
