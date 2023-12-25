import 'package:flutter/material.dart';

class UserExploreDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> shopDetails;
  const UserExploreDetailsScreen({
    super.key,
    required this.shopDetails,
  });

  @override
  Widget build(BuildContext context) {
    // Extracting recentOrders from shopDetails
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
              const Image(
                image: AssetImage('assets/image.jpg'),
              ),
              const Text('Full Name'),
              Text(
                shopDetails['fullName'] ?? '',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Description'),
              Text(
                shopDetails['description'] ?? '',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text('Recent Orders'),
              // Iterating over recentOrders to display each image
              for (var order in recentOrders) 
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Image.network(order),
                ),
            ],
          ),
        ),
      ),
    );
  }
}