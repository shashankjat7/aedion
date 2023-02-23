import 'package:aedion/Modules/Authentication/views/sign_in_view.dart';
import 'package:aedion/Modules/HomeScreen/SubModules/ProfilePage/views/secret_check_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({Key? key}) : super(key: key);

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  int tapCount = 0;

  void upCount() {
    setState(() {
      tapCount++;
    });
    if (tapCount % 21 == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecretCheckView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.popAndPushNamed(context, SignInView.routeName);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.account_circle),
            title: const Text('Account'),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          upCount();
        },
        child: Container(
          width: double.infinity,
          color: Colors.blue.withOpacity(0.02),
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Aedion',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Text(
                'For someone special',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
