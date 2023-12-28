import 'package:flutter/material.dart';

class UserOrderScreen extends StatelessWidget {
  final List<Map<String, dynamic>> orders = [
    {
      'status': 'Processing',
      'date': 'Today',
      'id': '4544882266',
      'image': 'assets/profile1.jpg',
    },
    {
      'status': 'Working',
      'date': 'Yesterday',
      'id': '4544231066',
      'image': 'assets/profile2.jpg',
    },
    {
      'status': 'Completed',
      'date': 'Yesterday',
      'id': '4004112266',
      'image': 'assets/profile3.jpg',
    },
    {
      'status': 'Processing',
      'date': 'Today',
      'id': '4543288966',
      'image': 'assets/profile4.jpg',
    },
    {
      'status': 'Processing',
      'date': 'Today',
      'id': '4521889866',
      'image': 'assets/profile5.jpg',
    },
  ];

  UserOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(
                  order['image'],
                ),
              ),
              title: Text(order['status']),
              subtitle: Text('Order ID: ${order['id']}'),
              trailing: Text(order['date']),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailScreen(order: order),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Column(
        children: [
          // Placeholder for order tracking widget
          Expanded(
            child: ListView(
              children: const [
                TrackingStep(title: 'Confirmed', time: '04:30pm'),
                TrackingStep(title: 'Processing', time: '04:38pm'),
                TrackingStep(title: 'On the way', time: '04:42pm'),
                TrackingStep(title: 'Delivered', time: '04:46pm'),
              ],
            ),
          ),
          // Placeholder for billing information
          const Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text('Total Bill'),
              subtitle: Text('\$43.35'),
              trailing: Icon(Icons.credit_card),
            ),
          ),
        ],
      ),
    );
  }
}

class TrackingStep extends StatelessWidget {
  final String title;
  final String time;

  const TrackingStep({super.key, required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(time),
      leading: const Icon(Icons.check_circle_outline),
    );
  }
}
