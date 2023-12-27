import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdOn;

  MessageModel({
    this.messageId,
    this.sender,
    this.text,
    this.seen,
    this.createdOn,
  });

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageId = map['message_id'];
    sender = map['sender'];
    text = map['text'];
    seen = map['seen'];
    createdOn = (map['createdOn'] as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'message_id': messageId,
      'sender': sender,
      'text': text,
      'seen': seen,
      'createdOn': createdOn != null ? Timestamp.fromDate(createdOn!) : null,
    };
  }
}
