// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/data/model/chat_room_model.dart';
import 'package:fyp/data/chat_room_page.dart';
import 'package:fyp/main.dart';
import 'package:fyp/tailor_console/tailor_model.dart';
import 'package:fyp/user_console/order_details_screen.dart';
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

    void placeOrder() async {
      String documentId = '${widget.userModel.id}_${widget.tailorModel.id}';

      // Check if the document already exists
      bool documentExists = await FirebaseFirestore.instance
          .collection('orders')
          .doc(documentId)
          .get()
          .then((doc) => doc.exists);

      if (documentExists) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmation'),
            content: const Text(
                'You already have measurements recorded for this tailor. Do you want to rewrite them?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  // Save the order
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return OrderDetailsScreen(
                          userId: widget.userModel.id!,
                          tailorId: widget.tailorModel.id!,
                        );
                      },
                    ),
                  );
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('No'),
              ),
            ],
          ),
        );
      } else {
        // If document does not exist, save the order directly
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return OrderDetailsScreen(
                userId: widget.userModel.id!,
                tailorId: widget.tailorModel.id!,
              );
            },
          ),
        );
      }
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
                          radius: 60,
                          backgroundImage:
                              NetworkImage(widget.shopDetails['profilePic']),
                        )
                      : const CircleAvatar(
                          child: Image(
                            image: AssetImage('assets/icon.png'),
                          ),
                        ),
                  const SizedBox(width: 20),
                  const Text(
                    'Say Hi',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
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
              Text(
                widget.shopDetails['fullName'] ?? '',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),

              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                widget.shopDetails['description'] ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              // Phone Number
              const Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.shopDetails['phoneNumber'] ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              // Area
              const Text(
                'Area',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.shopDetails['area'] ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              // Available Timing
              const Text(
                'Available Timing',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.shopDetails['availableTimings'] ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              // Recent Orders
              const Text(
                'Recent Orders',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CarouselSlider(
                items: [
                  for (var order in recentOrders)
                    Container(
                      margin: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(order.toString()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
                options: CarouselOptions(
                  height: 180.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.9,
                ),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  placeOrder();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Order Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
