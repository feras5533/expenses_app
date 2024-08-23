import 'package:expenses_app/common/prints.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '/widgets/bottom_navigation_bar_widget.dart';
// import 'views/login_view.dart';
import 'views/signup_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBUDPJivaTPEuUBsdrFq5DOq5pW5jhpwtU',
      appId: '6eea9b89-3b03-4c55-abe2-bb18f4860eff',
      messagingSenderId: '1051689997927',
      projectId: 'expenses-app-5533',
      storageBucket: 'expenses-app-5533.appspot.com',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    authStateChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'expenses app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignUpView(),
    );
  }

  authStateChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        printWarning('User is currently signed out!');
      } else {
        printWarning('User is signed in!');
      }
    });
  }
}
