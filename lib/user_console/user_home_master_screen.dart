import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/user_console/user_explore_screen.dart';
import 'package:fyp/user_console/user_master_view_model.dart';
import 'package:fyp/user_console/users_setting_screen.dart';
import 'package:provider/provider.dart';

class UserHomeMasterScreen extends StatefulWidget {
  const UserHomeMasterScreen({super.key});

  @override
  State<UserHomeMasterScreen> createState() => _UserHomeMasterScreenState();
}

class _UserHomeMasterScreenState extends State<UserHomeMasterScreen> {
  late final FirebaseAuth firebaseAuth;

  _UserHomeMasterScreenState() : firebaseAuth = FirebaseAuth.instance;
  final List<Widget> _pages = [
    const UserExploreScreen(),
    const Center(child: Text('Two')),
    const Center(child: Text('Three')),
    const UsersSettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserMasterViewModel>(
        builder: (context, value, child) => Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _pages[value.selectedPageIndex],
            SafeArea(
              child: Card(
                shape: StadiumBorder(
                  side: BorderSide(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  ),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () => value.onPageUpdated(0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              value.selectedPageIndex == 0
                                  ? Icons.explore
                                  : Icons.explore_outlined,
                            ),
                            const Text('Explore'),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => value.onPageUpdated(1),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              value.selectedPageIndex == 1
                                  ? Icons.add_box
                                  : Icons.add_box_outlined,
                            ),
                            const Text('Order'),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => value.onPageUpdated(2),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              value.selectedPageIndex == 2
                                  ? Icons.message
                                  : Icons.message_outlined,
                            ),
                            const Text('Message'),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => value.onPageUpdated(3),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              value.selectedPageIndex == 3
                                  ? Icons.settings
                                  : Icons.settings_outlined,
                            ),
                            const Text('Setting'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
