// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String userId;
  final String tailorId;

  const OrderDetailsScreen({
    Key? key,
    required this.userId,
    required this.tailorId,
  }) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClothType;
  String? _selectedGender;
  final double _fixedPrice = 1100;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      String documentId = '${widget.userId}_${widget.tailorId}';
      // Fetch the user data from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('orders')
          .doc(documentId)
          .get();

      if (snapshot.exists) {
        // If data exists, update the TextEditingController with fetched data
        Map<String, dynamic> data = snapshot.data()!;
        _measurementsControllers['Shoulder']!.text = data['Shoulder'];
        _measurementsControllers['Chest']!.text = data['Chest'];
        _measurementsControllers['Neck']!.text = data['Neck'];
        _measurementsControllers['Sleeve length']!.text = data['Sleeve length'];
        _measurementsControllers['Bicep']!.text = data['Bicep'];
        _measurementsControllers['Back width']!.text = data['Back width'];
        _specialDescriptionController.text = data['specialDescription'];
      }
    } catch (error) {
      // Handle error if necessary
    }
  }

  final Map<String, TextEditingController> _measurementsControllers = {
    'Shoulder': TextEditingController(),
    'Chest': TextEditingController(),
    'Neck': TextEditingController(),
    'Sleeve length': TextEditingController(),
    'Bicep': TextEditingController(),
    'Back width': TextEditingController(),
  };
  final _specialDescriptionController = TextEditingController();

  void _placeOrder() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> orderData = {
        'userId': widget.userId,
        'tailorId': widget.tailorId,
        'Shoulder': _measurementsControllers['Shoulder']!.text,
        'Chest': _measurementsControllers['Chest']!.text,
        'Neck': _measurementsControllers['Neck']!.text,
        'Sleeve length': _measurementsControllers['Sleeve length']!.text,
        'Bicep': _measurementsControllers['Bicep']!.text,
        'Back width': _measurementsControllers['Back width']!.text,
        'specialDescription': _specialDescriptionController.text,
        'status': 'Pending',
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

  // Define clothing categories and associated images
  final Map<String, Map<String, List<String>>> _clothes = {
    'Men': {
      'Men Shirt': [
        'assets/men/shirts/1_shirt.jpg',
        'assets/men/shirts/2_shirt.jpg',
        'assets/men/shirts/3_shirt.jpg',
        'assets/men/shirts/4_shirt.jpg',
      ],
      'Men Pant': [
        'assets/men/pants/1_pant.jpg',
        'assets/men/pants/2_pant.jpg',
        'assets/men/pants/3_pant.jpg',
        'assets/men/pants/4_pant.jpg',
      ],
      'Men Suits': [
        'assets/men/suits/1_suit.jpg',
        'assets/men/suits/2_suit.jpg',
      ],
      'Men T-Shirts': [
        'assets/men/t_shirts/1_tshirt.jpg',
        'assets/men/t_shirts/2_tshirt.jpg',
        'assets/men/t_shirts/3_tshirt.jpg',
        'assets/men/t_shirts/4_tshirt.jpg',
      ],
    },
    'Women': {
      'Women Dresses': [
        'assets/women/dresses/1_dress.jpg',
        'assets/women/dresses/2_dress.jpg',
        'assets/women/dresses/3_dress.jpg',
      ],
      'Women Pants': [
        'assets/women/pants/5_dress.jpg',
        'assets/women/pants/4_dress.jpg',
      ]
    }
  };

  // Map to link each clothing item to its model image
  final Map<String, String> _modelImages = {
    'assets/men/shirts/1_shirt.jpg': 'assets/men/shirts/1_shirt_model.jpg',
    'assets/men/shirts/2_shirt.jpg': 'assets/men/shirts/2_shirt_model.jpg',
    'assets/men/shirts/3_shirt.jpg': 'assets/men/shirts/3_shirt_model.jpg',
    'assets/men/shirts/4_shirt.jpg': 'assets/men/shirts/4_shirt_model.jpg',
    'assets/men/pants/1_pant.jpg': 'assets/men/pants/1_pant_model.jpg',
    'assets/men/pants/2_pant.jpg': 'assets/men/pants/2_pant_model.jpg',
    'assets/men/pants/3_pant.jpg': 'assets/men/pants/3_pant_model.jpg',
    'assets/men/pants/4_pant.jpg': 'assets/men/pants/4_pant_model.jpg',
    'assets/men/suits/1_suit.jpg': 'assets/men/suits/1_suit_model.jpg',
    'assets/men/suits/2_suit.jpg': 'assets/men/suits/2_suit_model.jpg',
    'assets/men/t_shirts/1_tshirt.jpg':
        'assets/men/t_shirts/1_tshirt_model.jpg',
    'assets/men/t_shirts/2_tshirt.jpg':
        'assets/men/t_shirts/2_tshirt_model.jpg',
    'assets/men/t_shirts/3_tshirt.jpg':
        'assets/men/t_shirts/3_tshirt_model.jpg',
    'assets/men/t_shirts/4_tshirt.jpg':
        'assets/men/t_shirts/4_tshirt_model.jpg',
    'assets/women/dresses/1_dress.jpg':
        'assets/women/dresses/1_dress_model.jpg',
    'assets/women/dresses/2_dress.jpg':
        'assets/women/dresses/2_dress_model.jpg',
    'assets/women/dresses/3_dress.jpg':
        'assets/women/dresses/3_dress_model.jpg',
    'assets/women/pants/5_dress.jpg': 'assets/women/pants/5_dress_model.jpg',
    'assets/women/pants/4_dress.jpg': 'assets/women/pants/4_dress_model.jpg',
  };

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
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Men'),
                        leading: Radio<String>(
                          value: 'Men',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                              _selectedClothType = null; // Reset cloth type
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Women'),
                        leading: Radio<String>(
                          value: 'Women',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                              _selectedClothType = null; // Reset cloth type
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                if (_selectedGender != null) ...[
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
                    items: _clothes[_selectedGender]!.keys.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
                if (_selectedClothType != null) ...[
                  Wrap(
                    spacing: 8.0, // space between images
                    children: _clothes[_selectedGender]![_selectedClothType]!
                        .map((image) => GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Image.asset(_modelImages[image]!),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Image.asset(
                                image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ))
                        .toList(),
                  ),
                ],
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
                      double.infinity,
                      50,
                    ),
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
