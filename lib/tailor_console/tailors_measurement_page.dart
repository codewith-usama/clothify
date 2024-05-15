// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TailorsMeasurementPage extends StatefulWidget {
  const TailorsMeasurementPage({Key? key}) : super(key: key);

  @override
  State<TailorsMeasurementPage> createState() => _TailorsMeasurementPageState();
}

class _TailorsMeasurementPageState extends State<TailorsMeasurementPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String? getTailorId() {
    final user = firebaseAuth.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    final tailorId = getTailorId();

    return Scaffold(
      appBar: AppBar(title: const Text('Store Measurements')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder(
            stream: firestore
                .collection('measurements')
                .where('tailorId', isEqualTo: tailorId)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    return Card(
                      child: ListTile(
                        title: Text(doc['customerName']),
                        subtitle: Text(
                            'Chest: ${doc['chest']}, Waist: ${doc['waist']}, Hip: ${doc['hip']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDelete(doc.id),
                        ),
                        onTap: () => _showAddOrEditMeasurementForm(doc),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOrEditMeasurementForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Do you want to delete this measurement?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await firestore.collection('measurements').doc(docId).delete();
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddOrEditMeasurementForm([DocumentSnapshot? doc]) {
    final TextEditingController customerNameController =
        TextEditingController(text: doc?.get('customerName') ?? '');
    final TextEditingController chestController =
        TextEditingController(text: doc?.get('chest') ?? '');
    final TextEditingController waistController =
        TextEditingController(text: doc?.get('waist') ?? '');
    final TextEditingController hipController =
        TextEditingController(text: doc?.get('hip') ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(doc == null ? 'Add Measurement' : 'Edit Measurement'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: customerNameController,
                    keyboardType: TextInputType.name,
                    decoration:
                        const InputDecoration(labelText: 'Customer Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter customer name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: chestController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Chest (inches)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter chest measurement';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: waistController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Waist (inches)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter waist measurement';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: hipController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Hip (inches)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter hip measurement';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  final data = {
                    'customerName': customerNameController.text.trim(),
                    'chest': chestController.text.trim(),
                    'waist': waistController.text.trim(),
                    'hip': hipController.text.trim(),
                    'tailorId': getTailorId(),
                  };
                  if (doc == null) {
                    await firestore.collection('measurements').add(data);
                  } else {
                    await firestore
                        .collection('measurements')
                        .doc(doc.id)
                        .update(data);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(doc == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }
}
