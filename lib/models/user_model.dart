import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String photoUrl;

  UserModel({
    this.id,
    this.displayName,
    this.email,
    this.photoUrl
  });

  factory UserModel.from({FirebaseUser firebaseUser}) {
    return UserModel(
        id: firebaseUser.uid,
        displayName: firebaseUser.displayName,
        email: firebaseUser.email,
        photoUrl: firebaseUser.photoUrl
    );
  }
}