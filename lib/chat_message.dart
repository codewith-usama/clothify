class User {
  final String userId;
  User({required this.userId});
}

class Tailor {
  final String tailorId;
  Tailor({required this.tailorId});
}

class ChatMessage {
  final String senderId;
  final String text;
  final DateTime timestamp;

  ChatMessage(
      {required this.senderId, required this.text, required this.timestamp});
}
