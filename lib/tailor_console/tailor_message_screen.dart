import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp/user_console/user_message_screen.dart';

class TailorConversationsScreen extends StatelessWidget {
  final String? tailorId;

  const TailorConversationsScreen({Key? key, required this.tailorId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tailor Conversations')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((userDoc) {
              return ListTile(
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(userDoc['profilePic'])),
                title: Text(
                  '${userDoc['userFullName']}',
                  style: const TextStyle(fontSize: 18),
                ),
                onTap: () {
                  // Navigate to chat screen with this user
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        tailorID: tailorId!,
                        userID: userDoc.id,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
