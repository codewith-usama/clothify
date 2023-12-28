import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/tailor_console/tailor_master_view_model.dart';
import 'package:fyp/tailor_console/tailor_messages_tile.dart';
import 'package:fyp/tailor_console/tailor_model.dart';
import 'package:fyp/tailor_console/tailor_setting_screen.dart';
import 'package:provider/provider.dart';

class TailorHomeMasterScreen extends StatefulWidget {
  final TailorModel tailorModel;
  final User user;

  const TailorHomeMasterScreen({
    super.key,
    required this.user,
    required this.tailorModel,
  });

  @override
  State<TailorHomeMasterScreen> createState() => _TailorHomeMasterScreenState();
}

class _TailorHomeMasterScreenState extends State<TailorHomeMasterScreen> {
  late final FirebaseAuth firebaseAuth;

  _TailorHomeMasterScreenState() : firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const Center(child: Text('Page 1')),
      const Center(child: Text('Page 2')),
      TailorMessagesTile(user: widget.user),
      const TailorSettingScreen(),
    ];
    return Scaffold(
      body: Consumer<TailorMasterViewModel>(
        builder: (context, value, _) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              pages[value.selectedPageIndex],
              SafeArea(
                child: Card(
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
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
                        // InkWell(
                        //   onTap: () => value.onPageUpdated(0),
                        //   child: Column(
                        //     mainAxisSize: MainAxisSize.min,
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Icon(
                        //         value.selectedPageIndex == 0
                        //             ? Icons.explore
                        //             : Icons.explore_outlined,
                        //       ),
                        //       const Text('Explore'),
                        //     ],
                        //   ),
                        // ),
                        InkWell(
                          onTap: () => value.onPageUpdated(0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                value.selectedPageIndex == 0
                                    ? Icons.add_box
                                    : Icons.add_box_outlined,
                              ),
                              const Text('Order'),
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
                                    ? Icons.scale
                                    : Icons.scale_outlined,
                              ),
                              const Text('Size'),
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
          );
        },
      ),
    );
  }
}
