import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:thankyoulist/login_screen.dart';
import 'package:thankyoulist/main_screen.dart';

class LaunchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
          if (user == null) {
            return LoginScreen();
          }
          return MainScreen(
            items: [
              BottomAppBarItem(icon: Icons.list, title: 'List'),
              BottomAppBarItem(icon: Icons.calendar_today, title: 'calendar'),
            ],
            centerItemTitle: 'Add Thank You',
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}