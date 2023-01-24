import 'dart:developer';

import 'package:aedion/Constants/route_names.dart';
import 'package:aedion/Modules/Authentication/services/google_sign_in_service.dart';
import 'package:aedion/Modules/HomeScreen/views/home_screen_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInView extends StatefulWidget {
  static const routeName = RouteNames.signInViewRouteName;
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool _isSignInUnderway = false;

  Future<void> signIn() async {
    setState(() {
      _isSignInUnderway = true;
    });
    bool signInSuccess = await GoogleSignInService().signInWithGoogle();
    if (signInSuccess) {
      log('the sign in was a success');
    }
    log('${FirebaseAuth.instance.currentUser}');
    setState(() {
      _isSignInUnderway = false;
    });
    if (mounted) {
      Navigator.popAndPushNamed(context, HomeScreenView.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isSignInUnderway ? const CircularProgressIndicator() : Container(),
            _isSignInUnderway
                ? const SizedBox(
                    height: 20,
                  )
                : Container(),
            TextButton(
              onPressed: () {
                signIn();
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
