import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/data/chat_room_page.dart';
import 'package:fyp/data/model/chat_room_model.dart';
import 'package:fyp/helper/firebase_helper.dart';
import 'package:fyp/tailor_console/tailor_model.dart';

class UserMessageTile extends StatefulWidget {
  final User user;
  const UserMessageTile({
    super.key,
    required this.user,
  });

  @override
  State<UserMessageTile> createState() => _UserMessageTileState();
}

class _UserMessageTileState extends State<UserMessageTile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(
          'ChitChatHub',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatrooms")
              .where("users", arrayContains: widget.user.uid)
              .orderBy("created_on", descending: true)
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot? chatRoomSnapshot =
                    snapshot.data as QuerySnapshot;
                return ListView.builder(
                  itemCount: chatRoomSnapshot.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                        chatRoomSnapshot.docs[index].data()
                            as Map<String, dynamic>);
                    Map<String, dynamic>? participants =
                        chatRoomModel.participants;
                    List<String> participantsKeys = participants!.keys.toList();

                    participantsKeys.remove(widget.user.uid);

                    return FutureBuilder(
                      future:
                          FirebaseHelper.getTailorModelById(participantsKeys[0]),
                      builder: (BuildContext context, tailorData) {
                        if (tailorData.connectionState ==
                            ConnectionState.done) {
                          if (tailorData.data != null) {
                            TailorModel targetUser =
                                tailorData.data as TailorModel;

                            return ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatRoomPage(
                                        chatRoomModel: chatRoomModel,
                                        firebaseUser: widget.user),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage:
                                    NetworkImage(tailorData.data!.profilePic!),
                              ),
                              title: Text(targetUser.fullName.toString()),
                              subtitle: (chatRoomModel.lastMessage
                                      .toString()
                                      .isEmpty)
                                  ? Text(
                                      "Say Hi to your new Friend",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    )
                                  : Text(chatRoomModel.lastMessage.toString()),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.hasError.toString()));
              } else {
                return const Center(child: Text('No chats'));
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
