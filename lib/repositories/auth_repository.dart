import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<String> getUserId();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({ @required this.firebaseAuth })
      : assert(firebaseAuth != null);

  final FirebaseAuth firebaseAuth;

  @override
  Future<String> getUserId() async {
    final user = await firebaseAuth.currentUser();
    return user.uid;
  }
}