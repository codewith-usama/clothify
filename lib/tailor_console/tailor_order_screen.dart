// ignore_for_file: avoid_function_literals_in_foreach_calls, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TailorOrderScreen extends StatelessWidget {
  const TailorOrderScreen({super.key});

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
            .where('tailorId', isEqualTo: currentUser?.uid)
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
                final userId = order['userId'];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
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
                      final userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final userName = userData['userFullName'];
                      final userImage = userData['profilePic'];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(userImage),
                          ),
                          title: Text(status),
                          subtitle: Text('User: $userName'),
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

class OrderDetailScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order['status'];
  }

  void _updateStatus() {
    FirebaseFirestore.instance
        .collection('orders')
        .where('tailorId',
            isEqualTo: widget.order['tailorId']) // Filter by tailorId
        .get()
        .then((querySnapshot) {
      // Iterate over the documents with the same tailorId
      querySnapshot.docs.forEach((doc) {
        // Update the status for each document
        doc.reference.update({'status': _selectedStatus}).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Status updated successfully')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update status: $error')),
          );
        });
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $error')),
      );
    });
  }

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
          Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                const ListTile(
                  title: Text('Total Bill'),
                  subtitle: Text('\$43.35'),
                  trailing: Icon(Icons.credit_card),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        value: _selectedStatus,
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        },
                        items: <String>['Pending', 'In-progress', 'Completed']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      ElevatedButton(
                        onPressed: _updateStatus,
                        child: const Text('Update Status'),
                      ),
                    ],
                  ),
                ),
              ],
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
