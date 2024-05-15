// ignore_for_file: library_private_types_in_public_api, unused_element, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TailorOrderDetailScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const TailorOrderDetailScreen({Key? key, required this.order})
      : super(key: key);

  @override
  _TailorOrderDetailScreenState createState() =>
      _TailorOrderDetailScreenState();
}

class _TailorOrderDetailScreenState extends State<TailorOrderDetailScreen> {
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order['status'];
  }

  void _updateStatus() {
    FirebaseFirestore.instance
        .collection('orders')
        .where('tailorId', isEqualTo: widget.order['tailorId'])
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
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

  void _openFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: InteractiveViewer(
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> customerOrder = widget.order['customerOrder'] ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        // Use SingleChildScrollView to accommodate long content
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Measurements:',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Back Width: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${widget.order['Back width']} inches',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Bicep: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${widget.order['Bicep']} inches',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Chest: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${widget.order['Chest']} inches',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Neck: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${widget.order['Neck']} inches',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shoulders: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${widget.order['Shoulder']} inches',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sleeve Length: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${widget.order['Sleeve length']} inches',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Special Description: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${widget.order['specialDescription']} inches',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Customer Designs:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Center(
                  child: SizedBox(
                    height: 200, // Set a fixed height for the image list
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: customerOrder.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _openFullScreenImage(
                              context, customerOrder[index]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(customerOrder[index]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      const ListTile(
                        title: Text('Total Bill'),
                        subtitle: Text('PKR: 43.35'),
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
                              items: <String>[
                                'Pending',
                                'In-progress',
                                'Completed'
                              ].map((String value) {
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
          ),
        ),
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
