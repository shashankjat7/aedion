import 'dart:developer';

import 'package:aedion/Modules/Compass/views/compass_view.dart';
import 'package:flutter/material.dart';

class SecretCheckView extends StatefulWidget {
  const SecretCheckView({Key? key}) : super(key: key);

  @override
  _SecretCheckViewState createState() => _SecretCheckViewState();
}

class _SecretCheckViewState extends State<SecretCheckView> {
  String secretCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA20913),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    secretCode = value;
                  });
                },
                cursorColor: Colors.white,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
                decoration: InputDecoration(
                  labelText: 'Book Padhli?',
                  floatingLabelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  focusColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            IconButton(
              onPressed: () {
                if (secretCode.toLowerCase() == 'daali rat') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CompassPageView(),
                    ),
                  );
                }
              },
              icon: Icon(Icons.arrow_forward_outlined),
              iconSize: 30,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
