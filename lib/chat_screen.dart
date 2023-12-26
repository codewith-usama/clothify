// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fyp/chat_message.dart';
import 'package:fyp/chat_service.dart';

class UserChatScreen extends StatefulWidget {
  final String userId;
  final String tailorId;

  const UserChatScreen({Key? key, required this.userId, required this.tailorId})
      : super(key: key);

  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String chatId = getChatId(widget.userId, widget.tailorId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.getMessages(chatId),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isCurrentUser = message.senderId == widget.userId;

                    return ListTile(
                      title: Text(message.text),
                      subtitle: Text(message.senderId),
                      trailing: isCurrentUser ? const Icon(Icons.check) : null,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(labelText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      await _chatService.sendMessage(
                          chatId,
                          ChatMessage(
                            senderId: widget.userId,
                            text: _messageController.text,
                            timestamp: DateTime.now(),
                          ));
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getChatId(String userId, String tailorId) {
    return userId.compareTo(tailorId) <= 0
        ? "$userId-$tailorId"
        : "$tailorId-$userId";
  }
}
