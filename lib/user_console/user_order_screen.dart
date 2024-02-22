import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserOrderScreen extends StatelessWidget {
  const UserOrderScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final orders = snapshot.data!.docs;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index].data() as Map<String, dynamic>;
                final status =
                    order['status'] == true ? 'Completed' : 'Processing';
                final tailorId = order['tailorId'];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('tailors')
                      .doc(tailorId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 10,
                        width: 10,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final tailorData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final tailorName = tailorData['fullName'];
                      final tailorImage = tailorData['profilePic'];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(tailorImage),
                          ),
                          title: Text(status),
                          subtitle: Text('Tailor: $tailorName'),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailScreen(order: order),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Column(
        children: [
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

  const TrackingStep({Key? key, required this.title, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(time),
      leading: const Icon(Icons.check_circle_outline),
    );
  }
}
