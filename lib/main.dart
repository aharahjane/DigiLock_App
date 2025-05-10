import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/ui_home_screen.dart';
import 'screens/purchase_screen.dart';
import 'screens/my_uploads_screen.dart';
import 'screens/upload_choice_screen.dart';
import 'screens/upload_steps_screen.dart';
import 'screens/my_works_screen.dart';
import 'screens/upload_work_screen.dart';
import 'screens/import_screen.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DigiLock',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0C1C30)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const UiHomeScreen(),
        '/purchases': (context) => const PurchaseScreen(),
        '/uploads': (context) => const MyUploadsScreen(),
        '/upload_my_work': (context) => const UploadChoiceScreen(),
        '/uploadSteps': (context) => const UploadStepsScreen(),
        '/myWorks': (context) => const MyWorksScreen(),
        '/uploadWork': (context) => const UploadWorkScreen(),
      
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1C30),
      body: Center(child: Image.asset("assets/logo_outlined.png", width: 150)),
    );
  }
}
