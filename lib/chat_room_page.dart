import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/chat_room_model.dart';
import 'package:fyp/message_model.dart';
import 'package:fyp/tailor_console/tailor_model.dart';
import 'package:fyp/user_console/user_model.dart';
import 'package:uuid/uuid.dart';

class ChatRoomPage extends StatefulWidget {
  final ChatRoomModel chatRoomModel;
  final User firebaseUser;
  const ChatRoomPage({
    Key? key,
    required this.chatRoomModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  UserModel? userModel;
  TailorModel? tailorModel;
  Uuid uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    fetchParticipantDetails();
  }

  void fetchParticipantDetails() async {
    userModel = await fetchUserDetails(widget.chatRoomModel.userId);
    tailorModel = await fetchTailorDetails(widget.chatRoomModel.tailorId);
    setState(() {});
  }

  Future<UserModel> fetchUserDetails(String? userId) async {
    var doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return UserModel.fromMap(doc.data()!);
  }

  Future<TailorModel> fetchTailorDetails(String? tailorId) async {
    var doc = await FirebaseFirestore.instance
        .collection('tailors')
        .doc(tailorId)
        .get();
    return TailorModel.fromMap(doc.data()!);
  }

  void sendMessage() async {
    String msg = _messageController.text.trim();
    _messageController.clear();

    if (msg.isNotEmpty) {
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        text: msg,
        sender: widget.firebaseUser.uid,
        createdOn: DateTime.now(),
        seen: false,
      );

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatRoomId)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      widget.chatRoomModel.lastMessage = msg;
      widget.chatRoomModel.createdOn = Timestamp.now();

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatRoomId)
          .set(widget.chatRoomModel.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel?.userFullName ?? 'Chat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoomModel.chatRoomId)
                    .collection("messages")
                    .orderBy("createdOn", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data != null &&
                        snapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          MessageModel currentMessage = MessageModel.fromMap(
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>);
                          return Align(
                            alignment:
                                currentMessage.sender == widget.firebaseUser.uid
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                currentMessage.text ?? "",
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("No messages yet"));
                    }
                  }
                  return const Center(child: CircularProgressIndicator());
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
                      decoration: const InputDecoration(
                        labelText: 'Type a message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
