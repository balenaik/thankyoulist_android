import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:thankyoulist/views/screens/login/login_screen.dart';
import 'package:thankyoulist/views/screens/main/main_screen.dart';

class LaunchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
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