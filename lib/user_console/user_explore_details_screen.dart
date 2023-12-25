import 'package:flutter/material.dart';

class UserExploreDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> shopDetails;

  const UserExploreDetailsScreen({
    Key? key,
    required this.shopDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> recentOrders = shopDetails['recentOrders'] ?? [];
    print(recentOrders[0]);

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
              // Tailor Profile Picture

              Row(
                children: [
                  const SizedBox(width: 10),
                  shopDetails['profilePic'] != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(shopDetails['profilePic']))
                      : const CircleAvatar(
                          child: Image(image: AssetImage('assets/icon.png'))),
                  const SizedBox(width: 30),
                  Text(
                    shopDetails['fullName'] ?? '',
                    style: const TextStyle(fontSize: 28),
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
