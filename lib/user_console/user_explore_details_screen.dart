// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/data/model/chat_room_model.dart';
import 'package:fyp/data/chat_room_page.dart';
import 'package:fyp/main.dart';
import 'package:fyp/tailor_console/tailor_model.dart';
import 'package:fyp/user_console/user_model.dart';

class UserExploreDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> shopDetails;
  final UserModel userModel;
  final TailorModel tailorModel;
  final User user;

  const UserExploreDetailsScreen({
    Key? key,
    required this.shopDetails,
    required this.userModel,
    required this.tailorModel,
    required this.user,
  }) : super(key: key);

  @override
  State<UserExploreDetailsScreen> createState() =>
      _UserExploreDetailsScreenState();
}

class _UserExploreDetailsScreenState extends State<UserExploreDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> recentOrders = widget.shopDetails['recentOrders'] ?? [];

    Future<ChatRoomModel?> getChatRoomModel(TailorModel targetUser) async {
      final ChatRoomModel? chatRoomModel;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("chatrooms")
          .where("participants.${widget.userModel.id}", isEqualTo: true)
          .where("participants.${targetUser.id}", isEqualTo: true)
          .get();
      if (snapshot.docs.isNotEmpty) {
        var docData = snapshot.docs[0].data();
        final ChatRoomModel existingChatRoom =
            ChatRoomModel.fromMap(docData as Map<String, dynamic>);

        chatRoomModel = existingChatRoom;
      } else {
        final ChatRoomModel newChatRoom = ChatRoomModel(
          chatRoomId: uuid.v1(),
          lastMessage: "",
          userId: widget.userModel.id,
          tailorId: widget.tailorModel.id,
          participants: {
            widget.userModel.id.toString(): true,
            targetUser.id.toString(): true,
          },
          users: [
            widget.userModel.id.toString(),
            targetUser.id.toString(),
          ],
          createdOn: DateTime.now(),
        );

        await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(newChatRoom.chatRoomId)
            .set(newChatRoom.toMap());

        chatRoomModel = newChatRoom;
      }
      return chatRoomModel;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shopDetails['shopName'] ?? 'Shop Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  widget.shopDetails['profilePic'] != null
                      ? CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(widget.shopDetails['profilePic']),
                      )
                      : const CircleAvatar(
                          child: Image(
                            image: AssetImage('assets/icon.png'),
                          ),
                        ),
                  const SizedBox(width: 20),
                  Text(
                    widget.shopDetails['fullName'] ?? '',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () async {
                      ChatRoomModel? chatRoomModel =
                          await getChatRoomModel(widget.tailorModel);
                      if (chatRoomModel != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatRoomPage(
                              chatRoomModel: chatRoomModel,
                              firebaseUser: widget.user,
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.message_outlined,
                      size: 30,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              // Description
              const Text('Description',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(
                widget.shopDetails['description'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // Phone Number
              const Text('Phone Number',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(
                widget.shopDetails['phoneNumber'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // Area
              const Text('Area',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(
                widget.shopDetails['area'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // Available Timing
              const Text('Available Timing',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(
                widget.shopDetails['availableTimings'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // Recent Orders
              const Text('Recent Orders',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              for (var order in recentOrders)
                SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.network(
                      order.toString(),
                      errorBuilder: (context, error, stackTrace) {
                        return const Image(
                          image: AssetImage('assets/icon.png'),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
