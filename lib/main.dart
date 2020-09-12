import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:thankyoulist/launch_screen.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/thankyoulist_repository.dart';
import 'package:thankyoulist/viewmodels/thankyou_calendar_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ThankYouListApp()
  );
}

class ThankYouListApp extends StatelessWidget {
  final _firestore = Firestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThankYouCalendarViewModel(
          ThankYouListRepositoryImpl(firestore: _firestore),
          AuthRepositoryImpl(firebaseAuth: _firebaseAuth)
      ),
      child: MaterialApp(
          title: 'Thank You List',
          home: LaunchScreen()
      ),
    );
  }
}