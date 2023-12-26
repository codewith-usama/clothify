import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/chat_message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ChatMessage>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage(
                  senderId: doc['senderId'],
                  text: doc['text'],
                  timestamp: doc['timestamp'].toDate(),
                ))
            .toList());
  }

  Future<void> sendMessage(String chatId, ChatMessage message) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': message.senderId,
      'text': message.text,
      'timestamp': message.timestamp,
    });
  }
}
