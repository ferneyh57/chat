// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'chat_user.g.dart';

@JsonSerializable()
class ChatUser {
  final String? userName;
  final int? lastSeen;
  final String? email;
  final String? uid;
  final UserStatus? status;
  ChatUser({
    this.userName,
    this.lastSeen,
    this.email,
    this.uid,
    this.status = UserStatus.online,
  });
  factory ChatUser.fromJson(Map<String, dynamic> json) => _$ChatUserFromJson(json);
  Map<String, dynamic> toJson() => _$ChatUserToJson(this);
}

//FIXME:hexa colors
@JsonEnum(valueField: 'value')
enum UserStatus {
  online('online', Colors.green),
  away('away', Colors.yellow),
  offline('offline', Colors.red);

  const UserStatus(this.value, this.color);
  final String value;
  final Color color;
}
