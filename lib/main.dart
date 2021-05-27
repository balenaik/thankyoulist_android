import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thankyoulist/repositories/thankyou_repiository.dart';

import 'package:thankyoulist/views/themes/light_theme.dart';
import 'package:thankyoulist/views/screens/launch/launch_screen.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/thankyoulist_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ThankYouListApp()
  );
}

class ThankYouListApp extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(
            create: (context) => AuthRepositoryImpl(firebaseAuth: _firebaseAuth),
          ),
          Provider(
            create: (context) => ThankYouListRepositoryImpl(firestore: _firestore),
          ),
          Provider(
            create: (context) => ThankYouRepositoryImpl(firestore: _firestore),
          )
        ],
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus.unfocus(),
          child: MaterialApp(
            title: 'Thank You List',
            theme: lightTheme,
            home: LaunchScreen()
          ),
        )
    );
  }
}