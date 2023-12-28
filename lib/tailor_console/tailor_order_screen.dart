import 'package:flutter/material.dart';

class TailorOrderScreen extends StatelessWidget {
  final List<Map<String, dynamic>> orders = [
    {
      'status': 'Processing',
      'date': 'Today',
      'id': '4544882266',
      'image': 'assets/profile1.jpg',
    },
    {
      'status': 'Delivered',
      'date': '23 Aug, 2020',
      'id': '4544882265',
      'image': 'assets/profile2.jpg',
    },
    {
      'status': 'Processing',
      'date': 'Today',
      'id': '4544882266',
      'image': 'assets/profile3.jpg',
    },
    {
      'status': 'Delivered',
      'date': '23 Aug, 2020',
      'id': '4544882265',
      'image': 'assets/profile4.jpg',
    },
    {
      'status': 'Processing',
      'date': 'Today',
      'id': '4544882266',
      'image': 'assets/profile5.jpg',
    },
    {
      'status': 'Delivered',
      'date': '23 Aug, 2020',
      'id': '4544882265',
      'image': 'assets/profile2.jpg',
    },
  ];

  TailorOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          var order = orders[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderTrackingScreen(order: order),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class OrderTrackingScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order ${order['id']}')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: const [
                OrderStatusTile(status: 'Confirmed', time: '04:30pm'),
                OrderStatusTile(status: 'Processing', time: '04:38pm'),
                OrderStatusTile(status: 'On the way', time: '04:42pm'),
                OrderStatusTile(status: 'Delivered', time: '04:46pm'),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const ListTile(
                    title: Text('Total Bill'),
                    subtitle: Text('\$43.35'),
                  ),
                  ListTile(
                    title: const Text('Payment Method'),
                    trailing: Image.asset('assets/icon.png'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderStatusTile extends StatelessWidget {
  final String status;
  final String time;

  const OrderStatusTile({super.key, required this.status, required this.time});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.circle, color: Colors.yellow),
          if (status != 'Delivered')
            const Expanded(
              child: VerticalDivider(
                color: Colors.grey,
                thickness: 2,
              ),
            ),
        ],
      ),
      title: Text(status),
      trailing: Text(time),
    );
  }
}
