import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/chat_screen.dart';

class UserExploreDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> shopDetails;

  const UserExploreDetailsScreen({
    Key? key,
    required this.shopDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    String getChatId(String userId, String tailorId) {
      return userId.compareTo(tailorId) <= 0
          ? "$userId-$tailorId"
          : "$tailorId-$userId";
    }

    List<dynamic> recentOrders = shopDetails['recentOrders'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(shopDetails['shopName'] ?? 'Shop Details'),
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
                  shopDetails['profilePic'] != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(shopDetails['profilePic']),
                        )
                      : const CircleAvatar(
                          child: Image(
                            image: AssetImage('assets/icon.png'),
                          ),
                        ),
                  const SizedBox(width: 30),
                  Text(
                    shopDetails['fullName'] ?? '',
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserChatScreen(
                          userId: shopDetails['id'],
                          tailorId: getChatId(
                              shopDetails['id'], firebaseAuth.currentUser!.uid),
                        ),
                      ),
                    ),
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
                shopDetails['description'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // Phone Number
              const Text('Phone Number',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(
                shopDetails['phoneNumber'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // Area
              const Text('Area',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(
                shopDetails['area'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // Available Timing
              const Text('Available Timing',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(
                shopDetails['availableTimings'] ?? '',
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
