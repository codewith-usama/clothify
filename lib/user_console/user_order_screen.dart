// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserOrderScreen extends StatelessWidget {
  const UserOrderScreen({
    Key? key,
  }) : super(key: key);

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
                      final status = order['status'];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(tailorImage),
                          ),
                          title: const Text('Tailor'),
                          subtitle: Text('$tailorName'),
                          trailing: SizedBox(
                            width: 100,
                            child: Card(
                              color: status == "Pending"
                                  ? Colors.brown
                                  : status == "Completed"
                                      ? Colors.green
                                      : Colors.blue,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    status,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
          if (order['status'] == 'Completed')
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return RatingBottomSheet(
                      userId: order['userId'],
                      tailorId: order['tailorId'],
                    );
                  },
                );
              },
              child: const Text('Rate this order'),
            )
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

class RatingBottomSheet extends StatefulWidget {
  final String userId;
  final String tailorId;

  const RatingBottomSheet({
    Key? key,
    required this.userId,
    required this.tailorId,
  }) : super(key: key);

  @override
  _RatingBottomSheetState createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Rate this order',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 1; i <= 5; i++)
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedRating = i;
                    });
                  },
                  icon: Icon(
                    selectedRating >= i ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Code to store the rating in Firebase database
              firebaseFirestore.collection('ratings').add({
                'userId': widget.userId,
                'tailorId': widget.tailorId,
                'rating': selectedRating,
              });
              Navigator.pop(context); // Close the bottom sheet
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class RatingStars extends StatefulWidget {
  final Function(int) onRatingUpdate;

  const RatingStars({Key? key, required this.onRatingUpdate}) : super(key: key);

  @override
  _RatingStarsState createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  int _selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) {
          int starIndex = index + 1;
          return IconButton(
            onPressed: () {
              setState(() {
                _selectedRating = starIndex;
              });
              widget.onRatingUpdate(_selectedRating);
            },
            icon: Icon(
              _selectedRating >= starIndex ? Icons.star : Icons.star_border,
              color: Colors.orange,
            ),
          );
        },
      ),
    );
  }
}
