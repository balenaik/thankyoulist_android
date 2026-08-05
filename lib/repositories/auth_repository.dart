import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thankyoulist/models/user_model.dart';

class AuthException implements Exception {}
class UserNotFoundException implements AuthException {}

abstract class AuthRepository {
  Future<String> getUserId();
  Future<UserModel> getUser();
  Future<void> logout();
  Future<void> deleteAccount();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({ required this.firebaseAuth })
      : assert(firebaseAuth != null);

  final FirebaseAuth firebaseAuth;

  @override
  Future<String> getUserId() async {
    final user = await firebaseAuth.currentUser;
    if (user == null) {
      throw UserNotFoundException();
    }
    return user.uid;
  }

  @override
  Future<UserModel> getUser() async {
    final user = await firebaseAuth.currentUser;
    if (user == null) {
      throw UserNotFoundException();
    }
    return UserModel.from(firebaseUser: user);
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    final user = firebaseAuth.currentUser;
    if (user == null) throw UserNotFoundException();

    final googleUser = await GoogleSignIn().signInSilently();
    if (googleUser == null) throw AuthException();

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    await user.reauthenticateWithCredential(credential);
    await user.delete();
  }
}