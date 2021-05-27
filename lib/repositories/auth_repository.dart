import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thankyoulist/models/user_model.dart';

abstract class AuthRepository {
  Future<String> getUserId();
  Future<UserModel> getUser();
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({ @required this.firebaseAuth })
      : assert(firebaseAuth != null);

  final FirebaseAuth firebaseAuth;

  @override
  Future<String> getUserId() async {
    final user = await firebaseAuth.currentUser;
    return user.uid;
  }

  @override
  Future<UserModel> getUser() async {
    final user = await firebaseAuth.currentUser;
    return UserModel.from(firebaseUser: user);
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}