import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/user_console/user_explore_details_screen.dart';

class UserExploreScreen extends StatelessWidget {
  const UserExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID from Firebase Authentication
    final userId = FirebaseAuth.instance.currentUser?.uid;

    // Check if the user is logged in
    if (userId == null) {
      return const Scaffold(
        body: SafeArea(
          child: Center(child: Text('User not logged in')),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance.collection('users').doc(userId).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (userSnapshot.hasError || !userSnapshot.data!.exists) {
              return const Center(child: Text('Unable to fetch user data'));
            }

            var userZipCode = userSnapshot.data![
                'userZipcode']; // Assuming the user's document has a 'zipCode' field

            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("tailors")
                  .where("zipCode", isEqualTo: userZipCode)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No Tailor Available in this ZipCode'));
                }

                var shopDocuments = snapshot.data?.docs ?? [];
                return ListView.builder(
                  itemCount: shopDocuments.length,
                  itemBuilder: (context, index) {
                    var shop =
                        shopDocuments[index].data() as Map<String, dynamic>;

                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserExploreDetailsScreen(
                            shopDetails: shop,
                          ),
                        ),
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: (shop['imageURL'] != null)
                                    ? Image.network(shop['imageURL'])
                                    : const Image(
                                        image: AssetImage(
                                            'assets/image.jpg'), // Placeholder image
                                      ),
                              ),
                              const SizedBox(width: 40),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shop['shopName'] ?? 'Shop Name',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                    Text(
                                      shop['fullName'] ?? 'Full Name',
                                      style: const TextStyle(
                                        fontSize: 19,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      shop['description'] ??
                                          'Short description',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      color: const Color.fromARGB(
                                          255, 130, 171, 243),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          shop['tailorTiming'] ??
                                              'Available Timings',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
