import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/helper/firebase_helper.dart';
import 'package:fyp/tailor_console/tailor_model.dart';
import 'package:fyp/user_console/user_explore_details_screen.dart';
import 'package:fyp/user_console/user_model.dart';
import 'package:google_fonts/google_fonts.dart';

class UserExploreScreen extends StatefulWidget {
  final UserModel userModel;
  const UserExploreScreen({
    super.key,
    required this.userModel,
  });

  @override
  State<UserExploreScreen> createState() => _UserExploreScreenState();
}

class _UserExploreScreenState extends State<UserExploreScreen> {
  UserModel? userModel;
  TailorModel? tailorModel;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getModels();
  }

  void getModels() async {
    userModel = await FirebaseHelper.getUserModelById(userId);
  }

  Future<TailorModel?> getTailorModel(String id) async =>
      await FirebaseHelper.getTailorModelById(id);

  void navigateToUserExploreDetailsPage(Map<String, dynamic> shop) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserExploreDetailsScreen(
          shopDetails: shop,
          userModel: userModel!,
          tailorModel: tailorModel!,
          user: user!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
              // see
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.userModel.userFullName!,
                    style: GoogleFonts.mali(
                      textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2,
                        fontSize: width * 0.08,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .get(),
                  builder:
                      (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (userSnapshot.hasError || !userSnapshot.data!.exists) {
                      return const Center(
                          child: Text('Unable to fetch user data'));
                    }

                    var userZipCode = userSnapshot.data![
                        'userZipcode']; // Assuming the user's document has a 'zipCode' field

                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("tailors")
                          .where("zipCode", isEqualTo: userZipCode)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child:
                                  Text('No Tailor Available in this ZipCode'));
                        }

                        var shopDocuments = snapshot.data?.docs ?? [];
                        return ListView.builder(
                          itemCount: shopDocuments.length,
                          itemBuilder: (context, index) {
                            var shop = shopDocuments[index].data()
                                as Map<String, dynamic>;

                            return InkWell(
                              onTap: () async {
                                tailorModel = await getTailorModel(shop['id']);
                                if (tailorModel != null) {
                                  navigateToUserExploreDetailsPage(shop);
                                }
                              },
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
                                        child: (shop['profilePic'] != null)
                                            ? CircleAvatar(
                                                radius: 60,
                                                backgroundImage: NetworkImage(
                                                    shop['profilePic']))
                                            : const CircleAvatar(
                                                radius: 60,
                                                backgroundImage: AssetImage(
                                                    'assets/image.jpg'),
                                              ),
                                      ),
                                      const SizedBox(width: 40),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                            Row(
                                              children: [
                                                Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  color: const Color.fromARGB(
                                                      255, 130, 171, 243),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      shop['availableTimings'] ??
                                                          'Available Timings',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 3),
                                                SizedBox(
                                                  width: 75,
                                                  child: Card(
                                                    color:
                                                        shop['orderStatus'] ==
                                                                "Closed"
                                                            ? Colors.red
                                                            : Colors.green,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: Text(
                                                          shop['orderStatus'],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
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
            ],
          ),
        ),
      ),
    );
  }
}
