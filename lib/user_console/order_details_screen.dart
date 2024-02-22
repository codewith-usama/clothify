// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String userId;
  final String tailorId;
  const OrderDetailsScreen({
    super.key,
    required this.userId,
    required this.tailorId,
  });

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClothType;
  final Map<String, TextEditingController> _measurementsControllers = {
    'Bust': TextEditingController(),
    'Waist': TextEditingController(),
    'Hip': TextEditingController(),
    'Flare': TextEditingController(),
    'StrapToHem': TextEditingController(),
    'WaistToHem': TextEditingController(),
  };
  final _specialDescriptionController = TextEditingController();
  final List<String> _clothTypes = [
    'Long Shirt',
    'Short Shirt',
    'Pants',
    'Dress'
  ];
  final double _fixedPrice = 1100;

  void _placeOrder() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> orderData = {
        'userId': widget.userId,
        'tailorId': widget.tailorId,
        'bust': _measurementsControllers['Bust']!.text,
        'waist': _measurementsControllers['Waist']!.text,
        'hip': _measurementsControllers['Hip']!.text,
        'flare': _measurementsControllers['Flare']!.text,
        'strapToHem': _measurementsControllers['StrapToHem']!.text,
        'waistToHem': _measurementsControllers['WaistToHem']!.text,
        'specialDescription': _specialDescriptionController.text,
        'status': false,
      };

      String documentId = '${widget.userId}_${widget.tailorId}';

      FirebaseFirestore.instance
          .collection('orders')
          .doc(documentId)
          .set(orderData)
          .then((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Order Confirmation'),
            content: const Text('Your order has been placed!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to place order: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Tailor Order'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedClothType,
                  hint: const Text('Select Cloth Type'),
                  onChanged: (value) {
                    setState(() {
                      _selectedClothType = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a cloth type' : null,
                  items: _clothTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage('assets/guide.png'),
                    height: 300,
                  ),
                ),
                const SizedBox(height: 10),
                ..._measurementsControllers.keys.map((measurement) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: _measurementsControllers[measurement],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: measurement,
                        hintText: 'Enter your $measurement measurement',
                      ),
                      validator: (value) {
                        return (value == null || value.isEmpty)
                            ? 'Please enter your $measurement'
                            : null;
                      },
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _specialDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Special Description',
                    hintText:
                        'Any special requests or descriptions for the tailor',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'Fixed Price: \$$_fixedPrice',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _placeOrder,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                        double.infinity, 50), // Full width and 50px height
                  ),
                  child: const Text('Place Order'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
