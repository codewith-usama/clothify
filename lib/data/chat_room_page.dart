// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fyp/data/model/chat_room_model.dart';
// import 'package:fyp/data/model/message_model.dart';
// import 'package:fyp/tailor_console/tailor_model.dart';
// import 'package:fyp/user_console/user_model.dart';
// import 'package:uuid/uuid.dart';

// class ChatRoomPage extends StatefulWidget {
//   final ChatRoomModel chatRoomModel;
//   final User firebaseUser;
//   const ChatRoomPage({
//     Key? key,
//     required this.chatRoomModel,
//     required this.firebaseUser,
//   }) : super(key: key);

//   @override
//   State<ChatRoomPage> createState() => _ChatRoomPageState();
// }

// class _ChatRoomPageState extends State<ChatRoomPage> {
//   final TextEditingController _messageController = TextEditingController();
//   UserModel? userModel;
//   TailorModel? tailorModel;
//   Uuid uuid = const Uuid();

//   @override
//   void initState() {
//     super.initState();
//     fetchParticipantDetails();
//   }

//   void fetchParticipantDetails() async {
//     userModel = await fetchUserDetails(widget.chatRoomModel.userId);
//     tailorModel = await fetchTailorDetails(widget.chatRoomModel.tailorId);
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   Future<UserModel?> fetchUserDetails(String? userId) async {
//     if (userId == null) return null;
//     var doc =
//         await FirebaseFirestore.instance.collection('users').doc(userId).get();
//     if (doc.data() != null) {
//       return UserModel.fromMap(doc.data()!);
//     }
//     return null;
//   }

//   Future<TailorModel?> fetchTailorDetails(String? tailorId) async {
//     if (tailorId == null) return null;
//     var doc = await FirebaseFirestore.instance
//         .collection('tailors')
//         .doc(tailorId)
//         .get();
//     if (doc.data() != null) {
//       return TailorModel.fromMap(doc.data()!);
//     }
//     return null;
//   }

//   void sendMessage() async {
//     String msg = _messageController.text.trim();
//     _messageController.clear();

//     if (msg.isNotEmpty) {
//       MessageModel newMessage = MessageModel(
//         messageId: uuid.v1(),
//         text: msg,
//         sender: widget.firebaseUser.uid,
//         createdOn: DateTime.now(),
//         seen: false,
//       );

//       FirebaseFirestore.instance
//           .collection("chatrooms")
//           .doc(widget.chatRoomModel.chatRoomId)
//           .collection("messages")
//           .doc(newMessage.messageId)
//           .set(newMessage.toMap());

//       widget.chatRoomModel.lastMessage = msg;
//       widget.chatRoomModel.createdOn = DateTime.now();

//       FirebaseFirestore.instance
//           .collection("chatrooms")
//           .doc(widget.chatRoomModel.chatRoomId)
//           .set(widget.chatRoomModel.toMap());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Row(
//           children: [
//             if (widget.firebaseUser.uid == userModel?.id)
//               CircleAvatar(
//                 backgroundImage: NetworkImage(
//                   tailorModel?.profilePic ??
//                       'https://th.bing.com/th/id/R.72380963a35b3fba67398022db5ae99d?rik=ga0xsfijaETFdQ&riu=http%3a%2f%2f1.bp.blogspot.com%2f-NP0zmaopjRE%2fUhhnlfaNsrI%2fAAAAAAAAEuE%2fZ5HQX6Jhqik%2fs1600%2fa%2b(9).jpg&ehk=AGheMSErLhbTXsly541CsCFJA95DVaC6Hd3vxS6KKFU%3d&risl=&pid=ImgRaw&r=0',
//                 ),
//               ),
//             if (widget.firebaseUser.uid == tailorModel?.id)
//               CircleAvatar(
//                 backgroundImage: NetworkImage(
//                   userModel?.profilePic ??
//                       'https://th.bing.com/th/id/R.72380963a35b3fba67398022db5ae99d?rik=ga0xsfijaETFdQ&riu=http%3a%2f%2f1.bp.blogspot.com%2f-NP0zmaopjRE%2fUhhnlfaNsrI%2fAAAAAAAAEuE%2fZ5HQX6Jhqik%2fs1600%2fa%2b(9).jpg&ehk=AGheMSErLhbTXsly541CsCFJA95DVaC6Hd3vxS6KKFU%3d&risl=&pid=ImgRaw&r=0',
//                 ),
//               ),
//             const SizedBox(width: 10),
//             if (widget.firebaseUser.uid == tailorModel?.id)
//               Text(userModel?.userFullName ?? ''),
//             if (widget.firebaseUser.uid == userModel?.id)
//               Text(tailorModel?.fullName ?? ''),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection("chatrooms")
//                     .doc(widget.chatRoomModel.chatRoomId)
//                     .collection("messages")
//                     .orderBy("createdOn", descending: true)
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.active) {
//                     if (snapshot.data != null &&
//                         snapshot.data!.docs.isNotEmpty) {
//                       return // Inside the StreamBuilder...
//                           ListView.builder(
//                         reverse: true,
//                         itemCount: snapshot.data!.docs.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           MessageModel currentMessage = MessageModel.fromMap(
//                               snapshot.data!.docs[index].data()
//                                   as Map<String, dynamic>);
//                           bool isSentByUser =
//                               currentMessage.sender == widget.firebaseUser.uid;

//                           return Align(
//                             alignment: isSentByUser
//                                 ? Alignment.centerRight
//                                 : Alignment.centerLeft,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 15, vertical: 10),
//                               margin: const EdgeInsets.symmetric(
//                                   horizontal: 15, vertical: 5),
//                               decoration: BoxDecoration(
//                                 color: isSentByUser
//                                     ? Colors.blue
//                                     : Colors.grey[300],
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(
//                                 currentMessage.text ?? "",
//                                 style: TextStyle(
//                                   color: isSentByUser
//                                       ? Colors.white
//                                       : Colors.black,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     } else {
//                       return const Center(child: Text("No messages yet"));
//                     }
//                   }
//                   return const Center(child: CircularProgressIndicator());
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       decoration: const InputDecoration(
//                         labelText: 'Type a message',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     onPressed: sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// new code

// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:fyp/data/model/chat_room_model.dart';
import 'package:fyp/data/model/message_model.dart';
import 'package:fyp/tailor_console/tailor_model.dart';
import 'package:fyp/user_console/user_model.dart';

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

  Widget buildMessageWidget(MessageModel message) {
    if (message.type == 'text') {
      // For text messages
      return Text(
        message.text,
        style: TextStyle(
          color: message.sender == widget.firebaseUser.uid
              ? Colors.white
              : Colors.black,
        ),
      );
    } else if (message.type == 'image') {
      // For image messages
      return Image.network(message.imageUrl ?? "", fit: BoxFit.cover);
    }
    // Fallback for unknown types
    return const Text("Unsupported message type");
  }

  void fetchParticipantDetails() async {
    userModel = await fetchUserDetails(widget.chatRoomModel.userId);
    tailorModel = await fetchTailorDetails(widget.chatRoomModel.tailorId);
    if (mounted) {
      setState(() {});
    }
  }

  Future<UserModel?> fetchUserDetails(String? userId) async {
    if (userId == null) return null;
    var doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<TailorModel?> fetchTailorDetails(String? tailorId) async {
    if (tailorId == null) return null;
    var doc = await FirebaseFirestore.instance
        .collection('tailors')
        .doc(tailorId)
        .get();
    if (doc.data() != null) {
      return TailorModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> sendMessage({String? imageUrl}) async {
    String msg = _messageController.text.trim();
    String type = imageUrl == null
        ? 'text'
        : 'image'; // Determine the type based on imageUrl

    if (msg.isEmpty && imageUrl == null) {
      return;
    }

    MessageModel newMessage = MessageModel(
      messageId: uuid.v1(),
      sender: widget.firebaseUser.uid,
      text: msg,
      seen: false,
      createdOn: DateTime.now(),
      imageUrl: imageUrl,
      type: type, // Use the determined type
    );

    _messageController.clear();

    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(widget.chatRoomModel.chatRoomId)
        .collection("messages")
        .doc(newMessage.messageId)
        .set(newMessage.toMap());
  }

  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      String fileName = path.basename(file.path);
      String filePath = 'chat_images/${uuid.v1()}/$fileName';

      try {
        // Upload to Firebase Storage
        TaskSnapshot snapshot =
            await FirebaseStorage.instance.ref(filePath).putFile(file);

        // Get image URL
        String downloadURL = await snapshot.ref.getDownloadURL();

        // Send message with image URL
        sendMessage(imageUrl: downloadURL);
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            if (widget.firebaseUser.uid == userModel?.id)
              CircleAvatar(
                backgroundImage: NetworkImage(
                  tailorModel?.profilePic ??
                      'https://th.bing.com/th/id/R.72380963a35b3fba67398022db5ae99d?rik=ga0xsfijaETFdQ&riu=http%3a%2f%2f1.bp.blogspot.com%2f-NP0zmaopjRE%2fUhhnlfaNsrI%2fAAAAAAAAEuE%2fZ5HQX6Jhqik%2fs1600%2fa%2b(9).jpg&ehk=AGheMSErLhbTXsly541CsCFJA95DVaC6Hd3vxS6KKFU%3d&risl=&pid=ImgRaw&r=0',
                ),
              ),
            if (widget.firebaseUser.uid == tailorModel?.id)
              CircleAvatar(
                backgroundImage: NetworkImage(
                  userModel?.profilePic ??
                      'https://th.bing.com/th/id/R.72380963a35b3fba67398022db5ae99d?rik=ga0xsfijaETFdQ&riu=http%3a%2f%2f1.bp.blogspot.com%2f-NP0zmaopjRE%2fUhhnlfaNsrI%2fAAAAAAAAEuE%2fZ5HQX6Jhqik%2fs1600%2fa%2b(9).jpg&ehk=AGheMSErLhbTXsly541CsCFJA95DVaC6Hd3vxS6KKFU%3d&risl=&pid=ImgRaw&r=0',
                ),
              ),
            const SizedBox(width: 10),
            if (widget.firebaseUser.uid == tailorModel?.id)
              Text(userModel?.userFullName ?? ''),
            if (widget.firebaseUser.uid == userModel?.id)
              Text(tailorModel?.fullName ?? ''),
          ],
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

                          // Determine if the message was sent by the user
                          bool isSentByUser =
                              currentMessage.sender == widget.firebaseUser.uid;

                          // Use buildMessageWidget to create the appropriate widget for the message
                          Widget messageWidget =
                              buildMessageWidget(currentMessage);

                          return Align(
                            alignment: isSentByUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                color: isSentByUser
                                    ? Colors.blue
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child:
                                  messageWidget, // Use the widget returned by buildMessageWidget
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
                  IconButton(
                    icon: const Icon(Icons.photo),
                    onPressed: pickAndUploadImage,
                  ),
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
                    onPressed: () => sendMessage(),
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
