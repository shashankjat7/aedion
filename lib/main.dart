import 'package:aedion/Modules/HomeScreen/views/home_screen_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Modules/Authentication/views/sign_in_view.dart';

String initialRoute = SignInView.routeName;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser != null) {
    initialRoute = HomeScreenView.routeName;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aedion',
      debugShowCheckedModeBanner: false,
      routes: {
        SignInView.routeName: (context) => const SignInView(),
        HomeScreenView.routeName: (context) => const HomeScreenView(),
      },
      initialRoute: initialRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
