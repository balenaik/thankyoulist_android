import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thankyoulist/models/user_model.dart';

abstract class AuthRepository {
  Future<String> getUserId();
  Future<UserModel> getUser();
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

  @override
  Future<UserModel> getUser() async {
    final user = await firebaseAuth.currentUser();
    return UserModel.from(firebaseUser: user);
  }
}