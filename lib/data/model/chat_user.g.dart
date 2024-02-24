// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUser _$ChatUserFromJson(Map<String, dynamic> json) => ChatUser(
      userName: json['userName'] as String?,
      lastSeen: json['lastSeen'] as int?,
      email: json['email'] as String?,
      uid: json['uid'] as String?,
    );

Map<String, dynamic> _$ChatUserToJson(ChatUser instance) => <String, dynamic>{
      'userName': instance.userName,
      'lastSeen': instance.lastSeen,
      'email': instance.email,
      'uid': instance.uid,
    };
