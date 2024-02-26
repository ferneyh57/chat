// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      content: json['content'] as String,
      date: json['date'] as int,
      seen: json['seen'] as bool? ?? false,
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.text,
      uid: json['uid'] as String,
      conversationId: json['conversationId'] as String,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'uid': instance.uid,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'content': instance.content,
      'date': instance.date,
      'seen': instance.seen,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'conversationId': instance.conversationId,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.audio: 'audio',
  MessageType.video: 'video',
  MessageType.photo: 'photo',
};
