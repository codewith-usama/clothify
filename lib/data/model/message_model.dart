// import 'package:cloud_firestore/cloud_firestore.dart';

// class MessageModel {
//   String? messageId;
//   String? sender;
//   String? text;
//   bool? seen;
//   DateTime? createdOn;

//   MessageModel({
//     this.messageId,
//     this.sender,
//     this.text,
//     this.seen,
//     this.createdOn,
//   });

//   MessageModel.fromMap(Map<String, dynamic> map) {
//     messageId = map['message_id'];
//     sender = map['sender'];
//     text = map['text'];
//     seen = map['seen'];
//     createdOn = (map['createdOn'] as Timestamp).toDate();
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'message_id': messageId,
//       'sender': sender,
//       'text': text,
//       'seen': seen,
//       'createdOn': createdOn != null ? Timestamp.fromDate(createdOn!) : null,
//     };
//   }
// }
// model code
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String messageId;
  final String sender;
  final String text;
  final bool seen;
  final DateTime createdOn;
  final String? imageUrl;
  final String type;

  MessageModel({
    required this.messageId,
    required this.sender,
    required this.text,
    required this.seen,
    required this.createdOn,
    this.imageUrl,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'sender': sender,
      'text': text,
      'seen': seen,
      'createdOn': Timestamp.fromDate(createdOn),
      'imageUrl': imageUrl,
      'type': type,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['messageId'] ?? '', // Use ?? to provide a fallback value
      sender: map['sender'] ?? '', // Use ?? to provide a fallback value
      text: map['text'] ?? '', // Use ?? to provide a fallback value
      seen: map['seen'] ?? false, // Use ?? to provide a fallback value
      createdOn: map['createdOn'] is Timestamp
          ? (map['createdOn'] as Timestamp).toDate()
          : DateTime.now(),
      imageUrl: map['imageUrl'], // No need for cast, already nullable
      type: map['type'] ?? 'text', // Use ?? to provide a fallback value
    );
  }
}
