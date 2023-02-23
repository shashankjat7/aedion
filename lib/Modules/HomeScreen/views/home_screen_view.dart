import 'dart:developer';

import 'package:aedion/Constants/route_names.dart';
import 'package:aedion/Modules/Authentication/views/sign_in_view.dart';
import 'package:aedion/Modules/HomeScreen/SubModules/HomePage/views/home_page_view.dart';
import 'package:aedion/Modules/HomeScreen/SubModules/NotesPage/views/notes_page_view.dart';
import 'package:aedion/Modules/HomeScreen/SubModules/ProfilePage/views/profile_page_view.dart';
import 'package:aedion/Modules/HomeScreen/SubModules/RecordPage/views/record_audio_view.dart';
import 'package:aedion/Modules/Tasks/views/task_list_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreenView extends StatefulWidget {
  static const routeName = RouteNames.homeScreenViewRouteName;
  const HomeScreenView({Key? key}) : super(key: key);

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  List<Widget> pages = [
    HomePageView(),
    const RecordAudioView(),
    const TaskListPageView(),
    const ProfilePageView(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
