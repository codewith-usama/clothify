import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String? chatRoomId;
  Map<String, dynamic>? participants;
  String? userId;
  String? tailorId;
  String? lastMessage;
  Timestamp? createdOn;

  ChatRoomModel({
    this.chatRoomId,
    this.participants,
    this.userId,
    this.tailorId,
    this.lastMessage,
    this.createdOn,
  });

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomId = map['chat_room_id'];
    participants = map['participants'];
    userId = map['user_id'];
    tailorId = map['tailor_id'];
    lastMessage = map['last_message'];
    createdOn = map['created_on'];
  }

  Map<String, dynamic> toMap() => {
        'chat_room_id': chatRoomId,
        'participants': participants,
        'user_id': userId,
        'tailor_id': tailorId,
        'last_message': lastMessage,
        'created_on': createdOn,
      };
}