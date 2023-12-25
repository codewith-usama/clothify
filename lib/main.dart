import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp/firebase_options.dart';
import 'package:fyp/splash_screen.dart';
import 'package:fyp/tailor_console/tailor_authentication_vm.dart';
import 'package:fyp/tailor_console/tailor_master_view_model.dart';
import 'package:fyp/theme.dart';
import 'package:fyp/user_console/user_authentication_vm.dart';
import 'package:fyp/user_console/user_master_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserMasterViewModel>(
            create: (_) => UserMasterViewModel()),
        ChangeNotifierProvider<TailorMasterViewModel>(
            create: (_) => TailorMasterViewModel()),
        ChangeNotifierProvider<TailorAuthenticationVm>(
            create: (_) => TailorAuthenticationVm()),
        ChangeNotifierProvider<UserAuthenticationVM>(
            create: (_) => UserAuthenticationVM()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: const SplashScreen(),
      ),
    );
  }
}
